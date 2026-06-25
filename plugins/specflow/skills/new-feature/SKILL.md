---
name: new-feature
description: Use when the user wants to start a new task or feature, or asks to 開卡 / 開需求 / 開 issue / 補接口 / 叫前端或後端做某事 / hand work to the other side. Opens a lightweight GitHub issue (目標 / 要做什麼 / 驗收條件) per this project's workflow. Do NOT use for finishing or claiming existing cards.
---

依專案工作流開一張**輕量 issue**（一張 TODO：要做什麼 / 目標 / 驗收）。把使用者本次訊息描述的需求當作輸入。

1. **整理內容**：讀 `${CLAUDE_PLUGIN_ROOT}/rules/issue-template.md`，把需求整理成 `## 目標` / `## 要做什麼` / `## 驗收條件`。驗收條件要可驗證，並含一條「相關行為已整理進 `specs/`」。
2. **判斷初始狀態**（預設可開工，有疑慮才擋）：
   - 明確、無跨端聯動、已有共識 → `ready`
   - 需討論或牽涉另一端 → `needs-design`
3. **判斷領域 label**：依專案的領域分工（見專案 `CLAUDE.md`；常見 `frontend` / `backend`，無領域分工可省略此項）。
4. **開 issue**：
   ```bash
   gh issue create --title "[功能] <一句話>" \
     --label "<domain>,<ready|needs-design>" \
     --body-file <暫存檔>
   ```
5. 回報 issue 連結、初始狀態、預計 branch `feat/<n>-<slug>`。
