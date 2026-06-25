# 開發 / 貢獻 specflow

## 本機開發

```bash
git clone https://github.com/swen-c/specflow.git
cd /你的/測試專案
claude --plugin-dir /clone的位置/specflow/plugins/specflow
```

改了 `plugins/specflow/` 裡的檔案後，在 claude 裡打 `/reload-plugins` 即生效，不用重開。

## 加一個新動作（skill）

1. 建 `plugins/specflow/skills/<name>/SKILL.md`，frontmatter 要有 `name` 與 `description`。
   - `description` 寫清楚**白話觸發語意**（中英都列）——Agent 靠它自動觸發，這是品質關鍵。
2. body 寫該動作的步驟。要引用插件內檔案用 `${CLAUDE_PLUGIN_ROOT}/...`（安裝後路徑會自動解析）。
3. 需要遠端資料就用 `gh` 指令；牽涉**對外送出 / 改 GitHub 狀態**的動作，body 要提醒「先跟使用者確認」（對齊 CLAUDE.md 的 AI 權限表）。
4. 同步更新 `README.md` 的動作表與結構樹。

## 慣例

- commit 用 [Conventional Commits](https://www.conventionalcommits.org/)（`feat` / `docs` / `refactor` / `fix`…）。
- 文案預設**繁體中文**，跟現有風格一致；sentence case、不用 emoji。
- 純檢查 / CI 一律**純 git diff + grep，不呼叫 AI 模型**（省 token、可重現）。
- 動到 `templates/` 或 specs 格式時，記得讓 `scripts/doctor.sh` 與 `ci-specs-gate.yml` 同步。

## 發版

1. 更新 `CHANGELOG.md` 與 `plugins/specflow/.claude-plugin/plugin.json` 的 `version`。
2. 打 tag 並開 Release：`git tag vX.Y.Z && git push --tags`，`gh release create vX.Y.Z`。
3. 使用者用 `/plugin marketplace update specflow` 拉新版。
