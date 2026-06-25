---
name: review
description: Use when reviewing a pull request in the specflow flow — 審查 / review #n / 幫我看這個 PR / 有什麼要 review 的 / 這張可以合併嗎 / approve or request changes. With no number, lists open PRs awaiting review; with a number, reviews that PR (code + specs + 驗收條件) and drafts an approve / request-changes verdict.
---

審查 PR（`in-review` 這段）。原則：**不審自己開的 PR**；**merge 由人決定，不自動合併**；送出審查結論前先讓使用者確認。

## 沒給編號 → 列出待審的 PR

```bash
gh pr list --state open --json number,title,author,isDraft \
  --jq '.[] | select(.isDraft | not) | "#\(.number) \(.title) — @\(.author.login)"'
```

回報清單，提示用 `/specflow:review <n>` 挑一個審。

## 給了 PR 編號 → 實際審查

1. 拉出 PR 內容與變更（含 `specs/`）：
   ```bash
   gh pr view <n> --json title,body,author,files
   gh pr diff <n>
   ```
2. 對照三件事審：
   - **驗收條件**：打開 PR body `Closes #<issue>` 連到的 issue，逐條看驗收條件有沒有達成。
   - **specs 同步**：PR 有沒有把行為變更整理回 `specs/`，且 specs 描述與實際 diff 一致 —— specs 是唯一事實來源，這裡是最後一道把關（CI 只擋格式，內容對不對靠這步）。
   - **正確性**：明顯 bug、漏掉的邊界、與現有 specs 行為衝突。
3. 把結論與理由先回報給使用者；**經同意後**再回寫到 PR：
   - 可合併：
     ```bash
     gh pr review <n> --approve --body "<重點 + 已確認 specs 同步>"
     ```
   - 要修改：
     ```bash
     gh pr review <n> --request-changes --body "<逐項列出要改什麼>"
     ```
4. 回報結論。**approve 後由作者 / 維護者自行 merge**（merge → CI 綠燈 → `Closes #<issue>` 自動關卡 → 卡進 `closed`）；要修改則作者改完再 re-request，卡續留 `in-review`。
