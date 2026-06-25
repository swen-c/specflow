# Changelog

本檔記錄 specflow 的版本變更。格式參考 [Keep a Changelog](https://keepachangelog.com/)，版號依 [SemVer](https://semver.org/)。

## [1.0.0] — 2026-06-25

首個版本。把「開 issue → 認領 → 開發 → 更新 specs → 開 PR」的團隊協作流程包成 Claude Code 插件，講白話讓 AI Agent 自動跑流程。

### 動作（skills，亦可 `/specflow:<name>` 明確呼叫）

- `new-feature` / `ready` / `next` / `claim` / `report` / `finish` — 開卡到開 PR 的完整生命週期
- `review` — 審查 PR：對照驗收條件、查 `specs/` 是否同步、找 bug，給 approve / 要修改
- `adr` — 把架構決策（為什麼）記到 `docs/adr/`
- `init` — 一鍵把新專案接上：建 labels、scaffold `specs/` / `CLAUDE.md` / CI 守門
- `doctor` — 專案健檢（labels / CLAUDE.md 佔位 / specs / CI / gh 登入）

### 機制

- SessionStart 開工簡報：協作流程 + `specs/` 記憶 + 可認領的卡 + 待接手的卡 + 待審 PR
- specs CI 守門：強制每個 PR 更新 `specs/`，並檢查四段格式（純 git diff + grep、不呼叫 AI）
- 記憶三分工：`issue`（這次做什麼）/ `specs/`（系統現在怎樣）/ `docs/adr/`（為什麼這樣設計）
- 模板：issue 模板、`CLAUDE.md`（含 AI 權限表）、specs README、ADR、specs CI gate、setup-labels
- 白話自動觸發 + `/specflow:<name>` 明確指令並存

[1.0.0]: https://github.com/swen-c/specflow/releases/tag/v1.0.0
