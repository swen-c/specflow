---
name: today
description: Use when the user asks what they can work on, 今天做什麼 / 有什麼卡可接 / 有什麼可以做 / what's available / what can I pick up. Lists claimable (ready, unassigned) and hand-off (in-progress, unassigned) GitHub issues, filtered by DEV_DOMAIN.
---

回報「今天可做什麼」。跑下面兩段查詢，整理成清單回報。若本機有設 `DEV_DOMAIN`（領域名，如 frontend/backend），加上對應 `label:$DEV_DOMAIN` 過濾；沒設就不過濾領域。

**全新可認領（ready + 未指派）**
```bash
gh issue list --state open \
  --search "no:assignee label:ready${DEV_DOMAIN:+ label:$DEV_DOMAIN}" \
  --json number,title --jq '.[] | "#\(.number) \(.title)"'
```

**待接手（交接中：in-progress 但無人指派）**
```bash
gh issue list --state open \
  --search "no:assignee label:in-progress${DEV_DOMAIN:+ label:$DEV_DOMAIN}" \
  --json number,title --jq '.[] | "#\(.number) \(.title)"'
```

整理成兩段清單回報；兩段都空就說明目前沒有可接的卡。可接的卡提示用 `/specflow:claim <n>` 認領。
