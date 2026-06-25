---
name: claim
description: Use when the user wants to take / claim a task and start working on it — 認領 #n / 我來做這張 / 我接 #n / 開工 / start this issue / pick up #n. Assigns the issue, flips it to in-progress, opens the feat branch, and loads relevant specs/. Needs an issue number.
---

認領 issue 並開 branch 開工。使用者給的 issue 編號 `#<n>` 為輸入。

1. **防競態**：先確認 issue `#<n>` 仍是 `ready` 且未指派。若已被指派或不是 ready，停下回報，不要硬接。
   ```bash
   gh issue view <n> --json assignees,labels,title
   ```
2. **認領 + 轉狀態**：
   ```bash
   gh issue edit <n> --add-assignee @me --add-label in-progress --remove-label ready
   ```
3. **開 branch**（從最新 main）：
   ```bash
   git checkout main && git pull && git checkout -b feat/<n>-<slug>
   ```
   `<slug>` 取 issue 標題的簡短英文 kebab。
4. **載入專案記憶**：讀這次需求相關的 `specs/`（`ls specs/` 看有哪些主題，開對應 `specs/<主題>.md` 看內容），先掌握系統現況再動手。
5. 回報：已認領、branch 名、相關 specs。
