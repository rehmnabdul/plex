Dashboard KPI tile — the metric cards across the top of a dashboard.

```jsx
<StatCard label="Earnings" value="$3,000.00" delta="+$1,210.50" trend="up"
          note="vs last month" icon={<i data-lucide="wallet" />} iconTone="blue" />
<StatCard label="Balance" value="$2,940.00" delta="-$1,210.50" trend="down"
          icon={<i data-lucide="credit-card" />} iconTone="sun" />
```

- `value` is pre-formatted. `delta` + `trend` (`up｜down`) color the change green/red.
- `icon` (Lucide) tinted by `iconTone`: `blue｜earth｜air｜sun｜ink`.
