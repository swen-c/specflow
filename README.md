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
| `review` | 審 PR：對照驗收條件 + 查 specs 同步 + 找 bug，給 approve / 要修改 | `/specflow:review [<n>]` |
| `adr` | 記一筆架構決策（為什麼）到 `docs/adr/`，編號 + 模板 | `/specflow:adr` |
| `init` | **一次性**把新專案接上：建 labels、scaffold `specs/` / `CLAUDE.md` / CI 守門 | `/specflow:init` |
| `doctor` | 健檢專案有沒有接好（labels / CLAUDE.md 佔位 / specs / CI / gh 登入），列出待補項 | `/specflow:doctor` |

## 安裝與使用（一般使用者）

不用 clone 這個 repo、不用碰任何路徑。整個過程就是「在 Claude Code 裡打幾行字」。

### 前置：先裝 GitHub CLI 並登入（每台電腦做一次）

specflow 靠 GitHub CLI（`gh`）幫你開卡 / 認領 / 開 PR，所以先把它準備好。**依你的系統挑一段裝**：

**macOS**
```bash
brew install gh                       # 用 Homebrew
# 沒有 Homebrew？到 https://cli.github.com 下載 .pkg 安裝
```

**Windows**（PowerShell）
```powershell
winget install --id GitHub.cli        # 內建 winget，最簡單
# 或：scoop install gh / choco install gh
# 都沒有？到 https://cli.github.com 下載 .msi 安裝
```

**Linux**
```bash
sudo apt install gh                   # Debian / Ubuntu
sudo dnf install gh                   # Fedora / RHEL / CentOS
sudo pacman -S github-cli             # Arch
# 其他發行版或要最新版：見 https://github.com/cli/cli/blob/trunk/docs/install_linux.md
```

裝好後，**三個系統都一樣**，登入並確認：
```bash
gh auth login        # 照提示選 GitHub.com，用瀏覽器登入
gh auth status       # 看到綠勾就代表登入成功
```

### 第 1 步：安裝 specflow（在 Claude Code 裡打這兩行）

```
/plugin marketplace add swen-c/specflow
/plugin install specflow@specflow
```

裝這一次就好，之後每個專案、每次開 Claude Code 都會自動帶著。
（日後流程有更新，再打一次 `/plugin marketplace update specflow` 就能拉到新版。）

### 第 2 步：在你的專案啟用（每個專案做一次）

1. 用 Claude Code 打開你要管理的專案（要是一個已經連到 GitHub 的 git 專案）。
2. 直接跟它說「**幫我初始化 specflow**」（或打 `/specflow:init`）。它會自動建好 GitHub labels、`specs/` 記憶夾、`CLAUDE.md` 規範、CI 守門。
3. 過程中它會請你補兩件專案專屬的小事：**領域 label**（如 frontend / backend，沒有可略過）和 **typecheck / build 指令**；照著填即可。

### 第 3 步：開始用 —— 直接講白話就好

不用記任何指令，像平常聊天一樣跟 Claude 說：

- 「開一張卡：登入頁要加記住我」 → 自動幫你開 issue
- 「現在有什麼可以接？」 → 列出可接的卡
- 「我來接 #12」 → 自動認領、開 branch、載入相關記憶
- 「收尾開 PR」 → 自動整理 specs、跑檢查、開 PR

> 想精確控制時，也可以直接打 `/specflow:<動作>`（例 `/specflow:claim 12`）—— 但這只是備援，平常講白話就夠了。

### 選配：只看自己領域的卡

團隊有前後端分工時，每人每台電腦設一個環境變數（**不要 commit**），開工簡報與「現在有什麼可以接」就只會顯示你領域的卡：

```bash
export DEV_DOMAIN=frontend   # 或 backend
```

## 想改 specflow 本身？（開發者，需要 clone）

一般使用者用不到這段 —— 只有你要**修改 specflow 插件內容**（改流程、改文案、加動作）時才需要。
這時不經 marketplace，而是把 repo 抓到本機、直接從資料夾載入，改完即時生效：

```bash
# 1. 把這個 repo 抓到本機
git clone https://github.com/swen-c/specflow.git

# 2. 切到你的測試專案，用本機這份插件啟動 claude（路徑指到含 .claude-plugin 的那層）
cd /你的/測試專案
claude --plugin-dir /剛剛clone的位置/specflow/plugins/specflow
```

- 改了 `plugins/specflow/` 裡的檔案後，在 claude 裡打 `/reload-plugins` 即生效，不用重開。
- 這種掛載只在當次 session 有效；要常用 / 給別人用還是回到上面的 marketplace 安裝。

常見客製：
- **改命令前綴**：把 `plugins/specflow/.claude-plugin/plugin.json` 與 `.claude-plugin/marketplace.json` 的 `name` 改掉（指令會變成 `/<新名>:claim`）。
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
│   ├── skills/{new-feature,ready,next,claim,report,finish,review,adr,init,doctor}/SKILL.md
│   ├── hooks/{hooks.json,session-start.sh}
│   ├── scripts/doctor.sh
│   ├── rules/issue-template.md
│   └── templates/{CLAUDE.md.template,specs-README.md,ci-specs-gate.yml,setup-labels.sh,adr-template.md}
└── README.md
```
