# Issue 規範（輕量 TODO）

> issue = 一張 TODO：說清楚「要做什麼、目標是什麼、怎樣算完成」。
> **不放規格全文、不鏡像任務清單**——系統「做什麼」的權威記憶在 `specs/`，issue 只描述這次要交付的需求。
> 誰認領、什麼狀態的權威來源是 issue 的 **assignee + label**，內文不重複寫。

## 標題格式

```
[功能] <一句話描述>
```

- 領域 label（依專案分工，選填）：如 `frontend` / `backend`（標主領域，供開工前過濾）
- 狀態 label：`needs-design` / `ready` / `in-progress` / `in-review`（同時只掛一個）

## 內文模板

```md
## 目標
<為什麼要做這件事、做完帶來什麼價值。1–2 句。>

## 要做什麼
<具體範圍：要加/改什麼。例：補後端 GET /api/x 接口並與前端 useX 串接。>

## 驗收條件
- [ ] <可驗證的條件 1>
- [ ] <可驗證的條件 2>
- [ ] 相關行為已整理進 specs/
```

## 規則

1. **記憶與 TODO 分離**：「系統做什麼」寫在 `specs/`（現行真實規格）；issue 只寫「這次要做什麼」。開發完**必須**把行為變更整理回 `specs/`（CI 守門）。
2. **一卡一 branch**：一張 issue 對應一條 `feat/<n>-<slug>` branch。
3. **狀態互斥**：`needs-design` / `ready` / `in-progress` / `in-review` 任一時刻只掛一個；流轉由對應動作負責。
4. **交接**：`in-progress` 時用 `report` 移除自己 assignee（保留 `in-progress`）→「in-progress + 無 assignee = 待接手」。
5. **關閉勾稽**：PR body 必含 `Closes #<n>`，merge 時自動關卡。
