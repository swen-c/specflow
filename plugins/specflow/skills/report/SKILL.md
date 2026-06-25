---
name: report
description: Use when the user wants to report progress or hand off a card — 回報進度 / push 一下 / 同步進度 / 交接這張卡 / 我先做到這 / hand off / handover. Commits, pushes, comments progress on the issue, and (on handoff) removes the assignee while keeping in-progress. Needs an issue number.
---

回報進度（含交接）。使用者給的 issue 編號 `#<n>`（與是否交接，講「交接 / hand off」即帶 `--handoff` 語意）為輸入。

1. **push**（先上傳，符合交接情境）：
   ```bash
   git add -A && git commit -m "<conventional commit 訊息>" && git push -u origin HEAD
   ```
2. **留進度 comment**（對照 issue 的「驗收條件」說明還差哪幾條）：
   ```bash
   gh issue comment <n> --body "已完成：… / 剩下：… / 阻塞：… / 是否待接手：…"
   ```
3. **交接時**：移除自己 assignee、保留 `in-progress`：
   ```bash
   gh issue edit <n> --remove-assignee @me
   ```
   → 該卡進入「in-progress + 無 assignee = 待接手」，他人 `/specflow:next` 看得到。comment 註明卡在哪、下一步是什麼。
4. 回報目前進度與是否已轉待接手。
