#!/usr/bin/env bash
# specflow SessionStart hook：開工即知「協作流程、專案記憶有哪些、有哪些卡可接」。
# stdout 會被注入成 agent 可見的 context，人不必開 issue 頁、不必人工篩選。
# 在「使用者的專案目錄」執行（cwd = 專案根），讀該專案的 specs/ 與 GitHub issues。
set -euo pipefail

# 每台機器本機設定 DEV_DOMAIN=<領域>（如 frontend / backend，不 commit）；未設定則不過濾領域。
DOMAIN="${DEV_DOMAIN:-}"

echo "## 本專案協作流程（specflow，詳見 CLAUDE.md）"
echo "開輕量 issue（目標/要做什麼/驗收）→ /specflow:claim 開 branch + 讀 specs/ → 開發 → 更新 specs/ → /specflow:finish 開 PR。"
echo "PR 須過 CI（typecheck / build / specs 守門）；改了行為一定要更新 specs/。"
echo ""

echo "## 專案記憶（specs/ — 系統現在做什麼）"
if [ -d specs ]; then
  find specs -maxdepth 1 -name '*.md' ! -name 'README.md' -exec basename {} .md \; 2>/dev/null | sort | sed 's/^/  - /'
else
  echo "  (尚無 specs/；可用 /specflow:init 初始化)"
fi
echo ""

# gh 未登入時整段靜默跳過，不讓 hook 失敗擋住開工。
if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  echo "## 全新可認領（ready + 未指派${DOMAIN:+ + $DOMAIN}）"
  gh issue list --state open \
    --search "no:assignee label:ready${DOMAIN:+ label:$DOMAIN}" \
    --json number,title --jq '.[] | "#\(.number) \(.title)"' || true
  echo ""

  echo "## 待接手（交接中：in-progress 但無人指派${DOMAIN:+ + $DOMAIN}）"
  gh issue list --state open \
    --search "no:assignee label:in-progress${DOMAIN:+ label:$DOMAIN}" \
    --json number,title --jq '.[] | "#\(.number) \(.title)"' || true
  echo ""

  echo "## 待審 PR（in-review，等人 review）"
  gh pr list --state open \
    --json number,title,author,isDraft \
    --jq '.[] | select(.isDraft | not) | "#\(.number) \(.title) — @\(.author.login)"' || true
else
  echo "## GitHub issue 概況"
  echo "  (gh 未登入；執行 'gh auth login' 後可在開工時看到 ready / 待接手清單)"
fi
