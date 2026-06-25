---
name: doctor
description: Use to check a project is correctly wired to specflow — 健檢 / 檢查 specflow 有沒有裝好 / specflow doctor / 流程設定對不對 / 為什麼流程沒作用 / why isn't the workflow working. Reports missing labels, unfilled CLAUDE.md placeholders, missing specs/ or CI gate, and gh login status.
---

健檢這個專案有沒有正確接上 specflow。先跑健檢腳本，再依結果主動幫使用者補齊缺的部分：

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/doctor.sh"
```

腳本會逐項回報 ✓/✗：gh 是否登入、是否在連到 GitHub 的 git repo、狀態 labels 是否齊、`CLAUDE.md` 是否存在且佔位符已填、`specs/` 與 `specs/README.md` 是否存在、CI 是否含 specs 守門。

對每個 ✗ 主動提修法並（經使用者同意後）動手：
- 缺 labels → 跑 `${CLAUDE_PLUGIN_ROOT}/templates/setup-labels.sh`
- 缺 `specs/` / `CLAUDE.md` → 走 `/specflow:init`
- `CLAUDE.md` 佔位符未填 → 幫使用者填（領域 label、typecheck/build 指令）
- 缺 CI 守門 → 把 `${CLAUDE_PLUGIN_ROOT}/templates/ci-specs-gate.yml` 的 `specs` job 併入 `.github/workflows/`

最後回報還剩哪些要人工處理（如 required status check 只能在 GitHub repo 設定頁開）。
