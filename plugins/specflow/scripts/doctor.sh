#!/usr/bin/env bash
# specflow 專案健檢：確認這個專案有沒有正確接上流程。
# 純檢查、不改任何東西。在「使用者的專案根目錄」執行（cwd = 專案根）。
set -uo pipefail

warn=0; bad=0
pass() { echo "  ✓ $1"; }
fail() { echo "  ✗ $1"; bad=$((bad + 1)); }
skip() { echo "  • $1"; warn=$((warn + 1)); }

echo "specflow 健檢 — $(pwd)"

echo ""
echo "[GitHub CLI]"
GH_OK=0
if command -v gh >/dev/null 2>&1; then
  if gh auth status >/dev/null 2>&1; then pass "gh 已安裝且登入"; GH_OK=1
  else fail "gh 已安裝但未登入 → 跑 gh auth login"; fi
else
  fail "未安裝 gh → 見 README『前置：先裝 GitHub CLI』"
fi

echo ""
echo "[Git / 遠端]"
REMOTE_OK=0
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  pass "在 git repo 內"
  if git remote get-url origin >/dev/null 2>&1; then pass "有 origin 遠端"; REMOTE_OK=1
  else fail "沒有 origin 遠端 → 連到 GitHub 才能開卡 / 開 PR"; fi
else
  fail "不在 git repo 內"
fi

echo ""
echo "[狀態 labels]"
if [ "$GH_OK" = 1 ] && [ "$REMOTE_OK" = 1 ]; then
  existing=$(gh label list --limit 200 --json name -q '.[].name' 2>/dev/null || echo "")
  for l in needs-design ready in-progress in-review no-spec; do
    if printf '%s\n' "$existing" | grep -qx "$l"; then pass "$l"
    else fail "$l 不存在 → 跑 templates/setup-labels.sh 或 /specflow:init"; fi
  done
else
  skip "略過（需 gh 登入 + origin 才能查 labels）"
fi

echo ""
echo "[CLAUDE.md]"
if [ -f CLAUDE.md ]; then
  pass "CLAUDE.md 存在"
  if grep -nE '<PROJECT_NAME>|<領域|<dir-[ab]>|<例' CLAUDE.md >/dev/null 2>&1; then
    fail "CLAUDE.md 還有未填的佔位符（<PROJECT_NAME> / <領域...> / <dir-a> 等）→ 請填好專案專屬處"
  else
    pass "佔位符已填"
  fi
else
  fail "沒有 CLAUDE.md → 走 /specflow:init"
fi

echo ""
echo "[specs/ 記憶夾]"
if [ -d specs ]; then
  pass "specs/ 存在"
  if [ -f specs/README.md ]; then pass "specs/README.md 存在"
  else fail "缺 specs/README.md → 從 templates/specs-README.md 複製"; fi
else
  fail "沒有 specs/ → 走 /specflow:init"
fi

echo ""
echo "[CI specs 守門]"
if ls .github/workflows/*.y*ml >/dev/null 2>&1 && grep -rlq 'no-spec' .github/workflows 2>/dev/null; then
  pass "CI 含 specs 守門（偵測到 no-spec 豁免邏輯）"
else
  fail "CI 沒有 specs 守門 → 把 templates/ci-specs-gate.yml 的 specs job 併入 .github/workflows"
fi

echo ""
echo "—"
if [ "$bad" -eq 0 ]; then
  echo "全部就緒 ✓（$warn 項略過）"
else
  echo "$bad 項待補（見上面 ✗）；提示用 /specflow:init 或依各項修法處理。"
fi
