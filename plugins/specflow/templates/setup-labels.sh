#!/usr/bin/env bash
# 為目前 repo 建立 specflow 狀態機需要的 labels（需 gh 已登入、cwd 已連到 remote repo）。
# 已存在的 label 會被略過（gh 報錯但不中斷）。狀態 label 互斥由流程保證，非 GitHub 強制。
set -uo pipefail

create() { gh label create "$1" --color "$2" --description "$3" 2>/dev/null \
  && echo "  + $1" || echo "  · $1（已存在或略過）"; }

echo "建立 specflow 狀態 labels："
create "needs-design" "FBCA04" "要討論 / 跨端：先在 issue 對齊，議定後 ready"
create "ready"        "0E8A16" "可認領：明確、無阻塞，待人 claim"
create "in-progress"  "1D76DB" "開發中（無 assignee = 待接手）"
create "in-review"    "5319E7" "已開 PR，等 CI / review / merge"
create "no-spec"      "BFBFBF" "無行為變更，豁免 specs CI 守門"

echo ""
echo "（選填）若有領域分工，再自行建立領域 labels，例如："
echo "  gh label create frontend --color D4C5F9 --description '前端'"
echo "  gh label create backend  --color C2E0C6 --description '後端'"
