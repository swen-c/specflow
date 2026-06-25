---
name: init
description: Use to bootstrap THIS project onto the specflow workflow — 初始化流程 / 接上 specflow / 設定協作流程 / set up the workflow / init specflow. One-time setup: creates GitHub labels, scaffolds specs/, CLAUDE.md, and the specs CI gate. The SessionStart briefing comes from the installed plugin automatically.
---

把目前這個專案接上 specflow 協作流程。**逐項先確認、已存在的就略過不覆蓋**，最後回報還需要使用者手動補什麼。

1. **建立 GitHub labels**（狀態機 + no-spec）：需 `gh` 已登入、cwd 已連到 remote repo。跑：
   ```bash
   bash "${CLAUDE_PLUGIN_ROOT}/templates/setup-labels.sh"
   ```
   若專案有領域分工，另外補領域 label（如 `frontend` / `backend`）。
2. **specs/ 記憶夾**：若無 `specs/`，建立並把樣板複製進去：
   ```bash
   mkdir -p specs && cp "${CLAUDE_PLUGIN_ROOT}/templates/specs-README.md" specs/README.md
   ```
3. **CLAUDE.md 協作規範**：若根目錄無 `CLAUDE.md`，把樣板複製過來，再把 `<...>` 佔位（專案名、領域 label、各領域的 typecheck/build 指令）依實況填好：
   ```bash
   cp "${CLAUDE_PLUGIN_ROOT}/templates/CLAUDE.md.template" CLAUDE.md
   ```
4. **specs CI 守門**：把 `${CLAUDE_PLUGIN_ROOT}/templates/ci-specs-gate.yml` 的 `specs` job 併入專案 `.github/workflows/`（既有 CI 就把該 job 加進去；沒有就把整檔放成新 workflow）。提醒使用者到 GitHub repo 設定把 `specs` 設為 **required status check**。
5. **（選填）本機領域過濾**：提示每位成員每台機器設 `export DEV_DOMAIN=<領域>`（**不要 commit**），SessionStart 與 `next` 會只顯示該領域的卡。
6. 回報已完成哪幾項、哪些需使用者手動處理（如 required status checks 只能在 GitHub repo 設定頁開）。
