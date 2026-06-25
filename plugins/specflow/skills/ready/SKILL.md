---
name: ready
description: Use when a needs-design card has been aligned and the user wants to open it for claiming — 議定好了 / 這張可以開放認領 / 對齊完了 / 可以開工了 / mark #n ready. Flips the issue from needs-design to ready. Needs an issue number.
---

把議定好的卡開放認領（needs-design → ready）。使用者給的 issue 編號 `#<n>` 為輸入。

「人按下這個動作 = 確認已對齊」——這是開工前唯一的共識關卡。

1. 快速確認 issue `#<n>` 目前是 `needs-design`、且 comment 已有對齊結論（沒有就先提醒使用者尚未議定）。
2. 升級狀態：
   ```bash
   gh issue edit <n> --add-label ready --remove-label needs-design
   ```
3. 回報已開放認領，提示可用 `/specflow:claim <n>` 認領。
