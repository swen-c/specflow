---
name: adr
description: Use when recording an architecture or technical decision — 記錄架構決策 / 為什麼選這個技術 / 開一張 ADR / 留個決策紀錄 / why did we choose X / record this decision. Creates a numbered ADR under docs/adr/ from the template. ADRs capture the "why" (decisions + trade-offs, append-only history); specs capture the "what" (current behavior, a rewritable snapshot).
---

把一個架構 / 技術選型決策記成 ADR，放 `docs/adr/`。**ADR 記「為什麼」與權衡，是 append-only 歷史**（不改舊檔、被取代就開新號）—— 跟 `specs/`（as-built 的「做什麼」、會改寫）分工，別混。

1. **找下一個編號**：看 `docs/adr/` 既有的 `ADR-NNNN-*.md`，取最大號 +1（沒有就從 `0001` 開始；沒有 `docs/adr/` 就建）。
2. **從樣板建檔**：把 `${CLAUDE_PLUGIN_ROOT}/templates/adr-template.md` 複製成 `docs/adr/ADR-<NNNN>-<slug>.md`，`<slug>` 取決策標題的簡短英文 kebab。
3. **填內容**（依使用者描述）：背景、決策、理由與權衡、後果；日期填今天；狀態預設「已採納」（還在討論就「提議中」）。
4. **連結**：若有對應 issue / PR，補到「相關」。
5. **取代舊決策時**：把被取代的舊 ADR 狀態改成「被取代（→ ADR-<新號>）」，但**不刪舊檔**（保留歷史）。
6. **更新索引**：在 `docs/adr/README.md` 補一行（沒有就建一個，列出各 ADR 編號 / 標題 / 狀態）。
7. 回報 ADR 路徑與編號。

> 注意：ADR 放 `docs/`，**不受 specs CI 守門影響**（那只擋 `specs/`）。
