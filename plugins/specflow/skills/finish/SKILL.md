---
name: finish
description: Use when the user is done and wants to wrap up — 完工 / 開 PR / 整理 specs 開 PR / 收尾 / ship it / open a PR / done with this. Updates specs/, runs typecheck+build, opens a PR with Closes #n, and flips the issue to in-review. Needs an issue number.
---

整理 specs 並開 PR。使用者給的 issue 編號 `#<n>` 為輸入。

1. **整理 `specs/`（必做、CI 會擋）**：把這次的行為變更整理回 `specs/`（格式見專案 `specs/README.md`）——
   - 改既有行為 → 更新對應 `specs/<主題>.md` 的「## 行為 / ## 介面」。
   - 新增功能 → 新增 `specs/<主題>.md`，並在 `specs/README.md` 目錄補一行。
   - **純重構 / 修字 / 純文件**（無行為變更）→ 不必改 specs，但 PR 要掛 `no-spec` label 才過得了 CI。
2. **本機自我檢查**：對每個有改動的子專案，跑專案 `CLAUDE.md`「本機自我檢查」列出的 typecheck + build（例：`npm --prefix <dir> run typecheck && npm --prefix <dir> run build`）。任一不過就停下修。
3. **開 PR**（body 必含 `Closes #<n>`，依 conventional commit）：
   ```bash
   gh pr create --title "feat: <一句話>" \
     --body "Closes #<n>"$'\n\n'"<變更摘要 + 這次更新了哪些 specs>"
   ```
   無行為變更時記得：`gh pr edit --add-label no-spec`。
4. **轉狀態**：
   ```bash
   gh issue edit <n> --add-label in-review --remove-label in-progress
   ```
5. CI 守門（typecheck + build + `specs` job）綠燈後 merge；`Closes #<n>` 會自動關 issue。回報 PR 連結。
