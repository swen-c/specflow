---
name: next
description: Use when the user asks what to pick up next or what's claimable right now — 下一張做什麼 / 接下來做什麼 / 今天做什麼 / 有什麼卡可接 / 有什麼待接手 / what's next / what's available / what can I pick up. Lists claimable (ready, unassigned) and hand-off (in-progress, unassigned) GitHub issues, filtered by DEV_DOMAIN. No date filter — it's the current pickup queue, not a daily digest.
---

回報「現在可接什麼」（純列當前可動的卡，不分日期）。跑下面兩段查詢，整理成清單回報。若本機有設 `DEV_DOMAIN`（領域名，如 frontend/backend），加上對應 `label:$DEV_DOMAIN` 過濾；沒設就不過濾領域。

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
