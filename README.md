# specflow

一套**可跨專案引用**的協作流程，包成 Claude Code 插件。核心理念：

> **`specs/`** = 專案記憶（系統做什麼）· **GitHub Issue** = 輕量 TODO（這次做什麼）· **branch / PR / CI** = 程式碼與守門。
> 三層零重疊，狀態流轉一律經固定動作 —— 讓多人 / 多個 AI agent 能無痛接力同一專案。

![specflow 協作流程狀態機：需求 → needs-design → ready → in-progress → in-review → closed，以及 in-progress 移除 assignee 後成為「待接手」、他人 next 看到並 claim 接手的迴圈](assets/flow.png)

## 為什麼用它

- **新 agent 接手不靠口頭交接**：靠 GitHub issue 的 `label + assignee` 當唯一真相，靠 `specs/` 當「系統現在做什麼」的記憶。`claim` 後讀 specs 就能上手，不必重掃 codebase。
- **記憶不腐壞**：CI `specs` job 擋下「改了行為卻沒更新 specs/」的 PR。
- **不用記指令，講白話就好**：每個動作都是會「自動觸發」的 skill —— 你描述意圖（「叫後端補接口」「我來接 #5」「收尾開 PR」），Agent 自己辨識並走對應流程；slash 指令只當明確呼叫的備援。

## 怎麼用：講白話，Agent 自己跑流程

**主要用法不是打指令，而是用白話跟 Agent 說話。** 安裝後每個動作都是一個會自動觸發的 skill，Agent 讀到你話裡的意圖就主動走對應流程 —— 你不用記指令、也不用打 `/`。

| 你（用白話）說 | Agent 自動做 |
|---|---|
| 「開張卡：登入頁加記住我」/「叫後端補 `/api/x` 接口」 | `new-feature` 開 issue |
| 「這張議定好了，可以開放認領」 | `ready` |
| 「現在有什麼可以接？」/「下一張做什麼？」 | `next` 列可接清單 |
| 「我來接 #12」/「開工」 | `claim` 認領 + 開 branch + 載入 specs |
| 「同步一下進度」/「我先做到這，交接出去」 | `report`（含交接） |
| 「收尾開 PR」/「完工了」 | `finish` 整理 specs + 開 PR |

**為什麼 Agent 會自己跑**（三個機制疊加，裝好就生效）：

- **skill 自動觸發**：每個動作的觸發語意寫在 skill 裡，Agent 比對你的話就主動執行，不必有人打 `/`。
- **CLAUDE.md 規範**：`init` 會在專案放一份 `CLAUDE.md`，明令 Agent「收到對應語意就主動走流程、別繞過」；牽涉開卡 / 認領 / 交接等動作時會先跟你確認再做（安全網）。
- **開工簡報**：每開一個新對話，SessionStart 自動把「協作流程、`specs/` 有哪些記憶、現在有哪些卡可接」餵進 Agent 的 context，它一開場就知道現況。

> 想精確控制時仍可直接打明確指令 `/specflow:<name>`（例 `/specflow:claim 12`）—— 白話與指令並存，指令是備援、不是必需。

## 接任務的兩個入口

對照最上方流程圖，「接任務」都走 `next` → `claim`：

| 場景 | 怎麼接 |
|---|---|
| 接全新的卡 | `next` 列 `ready + 未指派` → `claim <n>` |
| 接別人交接的卡 | `next` 列 `in-progress + 無 assignee`（待接手）→ `claim <n>` |

## 動作清單（細節對照）

每個動作優先用白話觸發（見上）；需要時也能用右欄的明確指令。

| 動作 | 做什麼 | 明確指令（選填） |
|---|---|---|
| `new-feature` | 開一張輕量 issue（目標 / 要做什麼 / 驗收條件） | `/specflow:new-feature <需求>` |
| `ready` | 議定後把 `needs-design` 開放認領（→ `ready`） | `/specflow:ready <n>` |
| `next` | 列現在可接的卡（全新可認領 + 待接手），依 `DEV_DOMAIN` 過濾 | `/specflow:next` |
| `claim` | 認領：指派 + 轉 `in-progress` + 開 `feat/<n>-<slug>` + 載入 specs | `/specflow:claim <n>` |
| `report` | 回報進度（commit/push/留言）；帶交接語意則移除 assignee | `/specflow:report <n>` |
| `finish` | 整理 specs → typecheck/build → 開 PR（`Closes #<n>`）→ 轉 `in-review` | `/specflow:finish <n>` |
| `init` | **一次性**把新專案接上：建 labels、scaffold `specs/` / `CLAUDE.md` / CI 守門 | `/specflow:init` |

## 安裝

### 給團隊一起用（建議：透過 marketplace）

成員在自己的 Claude Code 執行（一次 add，之後 install）：

```
/plugin marketplace add swen-c/specflow
/plugin install specflow@specflow
```

往後流程有更新，成員用 `/plugin marketplace update specflow` 拉新版即可。

### 本機開發 / 試用（免安裝）

```bash
claude --plugin-dir /path/to/specflow/plugins/specflow
```

> 插件指令一律命名空間化為 `/specflow:<name>`（例 `/specflow:next`、`/specflow:claim 12`）。
> 白話也能觸發：「我來接 #5」→ claim、「叫後端補接口」→ new-feature、「收尾開 PR」→ finish。

## 新專案 30 秒接上

1. 安裝插件（見上）。
2. 在專案根目錄執行 `/specflow:init`，它會：
   - 建立 GitHub labels（`needs-design` / `ready` / `in-progress` / `in-review` / `no-spec`）。
   - 若無 `specs/` → scaffold `specs/README.md`。
   - 若無 `CLAUDE.md` → 從樣板複製，**請填好專案專屬處**（領域 label、各領域的 typecheck/build 指令）。
   - 提示把 `templates/ci-specs-gate.yml` 的 `specs` job 併入 CI，並在 repo 設為 required status check。
3. （選填）每人每台機器 `export DEV_DOMAIN=<領域>`（不要 commit），開工簡報與 `next` 會只顯示你領域的卡。
4. 之後就**用白話跟 Agent 說話**即可（見上方「怎麼用」）—— `init` 放進專案的 `CLAUDE.md` 會讓 Agent 自動走流程，不需要每次打指令。

## 客製

- **改命令前綴**：把 `plugins/specflow/.claude-plugin/plugin.json` 與 `.claude-plugin/marketplace.json` 的 `name` 改成你要的（指令會跟著變成 `/<新名>:claim`）。
- **加領域分工**：在各專案的 `CLAUDE.md` 與 labels 自行定義（如 frontend/backend）；插件本身不綁死領域。
- **調 specs 格式 / CI**：改 `templates/specs-README.md`、`templates/ci-specs-gate.yml`。

## 授權

MIT，見 [LICENSE](LICENSE)。

## 結構

```
specflow/                                   ← 此 repo（同時是 marketplace）
├── .claude-plugin/marketplace.json
├── plugins/specflow/                       ← 插件本體
│   ├── .claude-plugin/plugin.json
│   ├── skills/{new-feature,ready,next,claim,report,finish,init}/SKILL.md
│   ├── hooks/{hooks.json,session-start.sh}
│   ├── rules/issue-template.md
│   └── templates/{CLAUDE.md.template,specs-README.md,ci-specs-gate.yml,setup-labels.sh}
└── README.md
```
