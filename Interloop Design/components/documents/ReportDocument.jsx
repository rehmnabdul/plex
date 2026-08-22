import React from 'react';

const CSS = `
.ilp-doc__wrap{display:flex;flex-direction:column;align-items:center;gap:var(--space-5);padding:var(--space-6) var(--space-4);background:var(--surface-page);font-family:var(--font-sans)}
.ilp-doc__wrap *{box-sizing:border-box}

/* screen-only action bar */
.ilp-doc__bar{display:flex;align-items:center;gap:var(--space-2);width:100%;max-width:var(--doc-w,820px)}
.ilp-doc__bar h1{margin:0 auto 0 0;font-size:var(--fs-lg);font-weight:var(--weight-bold);letter-spacing:-0.01em;color:var(--text-primary)}
.ilp-doc__btn{display:inline-flex;align-items:center;gap:7px;height:36px;padding:0 15px;font:inherit;font-size:var(--fs-sm);font-weight:var(--weight-bold);color:var(--text-secondary);background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-md);cursor:pointer;transition:background var(--dur-fast) var(--ease-standard),color var(--dur-fast) var(--ease-standard)}
.ilp-doc__btn:hover{background:var(--surface-hover);color:var(--text-primary);border-color:var(--border-strong)}
.ilp-doc__btn:focus-visible{outline:none;box-shadow:var(--ring)}
.ilp-doc__btn--primary{color:#fff;background:var(--brand-primary);border-color:var(--brand-primary)}
.ilp-doc__btn--primary:hover{background:var(--brand-primary-hover);color:#fff;border-color:var(--brand-primary-hover)}
.ilp-doc__btn svg{width:15px;height:15px}

/* the sheet */
.ilp-doc{--doc-w:820px;width:100%;max-width:var(--doc-w);background:var(--surface-card);border:1px solid var(--border-subtle);border-radius:var(--radius-lg);box-shadow:var(--shadow-md);overflow:hidden;color:var(--text-primary)}
.ilp-doc--a4{--doc-w:794px}
.ilp-doc--letter{--doc-w:816px}
.ilp-doc--fluid{--doc-w:100%}
.ilp-doc__pad{padding:44px 48px}

/* masthead */
.ilp-doc__top{display:flex;align-items:flex-start;gap:var(--space-6);padding-bottom:28px;border-bottom:2px solid var(--il-grayblue-700)}
.ilp-doc__brand{display:flex;flex-direction:column;gap:10px;margin-right:auto;min-width:0}
.ilp-doc__logo img,.ilp-doc__logo svg{height:34px;width:auto;display:block}
.ilp-doc__issuer{font-size:var(--fs-xs);line-height:1.6;color:var(--text-muted)}
.ilp-doc__issuer b{display:block;font-size:var(--fs-sm);font-weight:var(--weight-bold);color:var(--text-primary)}
.ilp-doc__idblock{text-align:right;flex:none}
.ilp-doc__kind{font-size:var(--fs-xs);font-weight:var(--weight-bold);letter-spacing:.14em;text-transform:uppercase;color:var(--text-muted)}
.ilp-doc__no{margin:4px 0 0;font-size:var(--fs-2xl);font-weight:var(--weight-black);letter-spacing:-0.02em;line-height:1.1;font-variant-numeric:tabular-nums}
.ilp-doc__stamp{display:inline-flex;align-items:center;gap:6px;margin-top:10px;height:26px;padding:0 12px;font-size:var(--fs-xs);font-weight:var(--weight-bold);letter-spacing:.06em;text-transform:uppercase;border-radius:var(--radius-pill);background:var(--il-grayblue-100);color:var(--text-secondary)}
.ilp-doc__stamp--success{background:var(--il-earth-soft);color:var(--il-earth-ink)}
.ilp-doc__stamp--warning{background:var(--il-sun-soft);color:var(--il-sun-ink)}
.ilp-doc__stamp--danger{background:var(--il-red-soft);color:var(--il-red-ink)}
.ilp-doc__stamp--info{background:var(--il-blue-100);color:var(--il-blue-800)}
.ilp-doc__stamp::before{content:"";width:6px;height:6px;border-radius:50%;background:currentColor}

/* meta strip */
.ilp-doc__meta{display:grid;grid-template-columns:repeat(auto-fit,minmax(120px,1fr));gap:var(--space-5);padding:20px 0;border-bottom:1px solid var(--border-subtle)}
.ilp-doc__meta div{min-width:0}
.ilp-doc__lbl{display:block;font-size:10px;font-weight:var(--weight-bold);letter-spacing:.08em;text-transform:uppercase;color:var(--text-muted);margin-bottom:4px}
.ilp-doc__val{font-size:var(--fs-sm);font-weight:var(--weight-bold);font-variant-numeric:tabular-nums}
.ilp-doc__hint{display:block;margin-top:2px;font-size:var(--fs-xs);font-weight:var(--weight-regular);color:var(--text-muted)}

/* parties */
.ilp-doc__parties{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:var(--space-6);padding:24px 0}
.ilp-doc__party b{display:block;margin-bottom:3px;font-size:var(--fs-base);font-weight:var(--weight-bold)}
.ilp-doc__party p{margin:0;font-size:var(--fs-sm);line-height:1.65;color:var(--text-secondary);white-space:pre-line}
.ilp-doc__party dl{display:grid;grid-template-columns:auto 1fr;gap:3px 12px;margin:9px 0 0;font-size:var(--fs-xs)}
.ilp-doc__party dt{color:var(--text-muted)}
.ilp-doc__party dd{margin:0;font-weight:var(--weight-semibold);color:var(--text-secondary)}

/* line items */
.ilp-doc__table{width:100%;border-collapse:collapse;margin-top:4px}
.ilp-doc__table thead th{padding:9px 12px;font-size:10px;font-weight:var(--weight-bold);letter-spacing:.08em;text-transform:uppercase;color:var(--text-inverse);background:var(--il-grayblue-700);text-align:left;white-space:nowrap}
.ilp-doc__table thead th:first-child{border-radius:var(--radius-sm) 0 0 var(--radius-sm)}
.ilp-doc__table thead th:last-child{border-radius:0 var(--radius-sm) var(--radius-sm) 0}
.ilp-doc__table td{padding:12px;font-size:var(--fs-sm);line-height:1.45;border-bottom:1px solid var(--border-subtle);vertical-align:top}
.ilp-doc__table tbody tr:last-child td{border-bottom:1px solid var(--border-default)}
.ilp-doc__num{text-align:right;font-variant-numeric:tabular-nums;white-space:nowrap}
.ilp-doc__ctr{text-align:center}
.ilp-doc__desc b{display:block;font-weight:var(--weight-bold)}
.ilp-doc__desc span{display:block;margin-top:2px;font-size:var(--fs-xs);color:var(--text-muted);text-wrap:pretty}
.ilp-doc__grouprow td{padding:14px 12px 6px;font-size:10px;font-weight:var(--weight-bold);letter-spacing:.08em;text-transform:uppercase;color:var(--text-muted);border-bottom:0}

/* summary */
.ilp-doc__foot{display:grid;grid-template-columns:minmax(0,1fr) 300px;gap:var(--space-7);padding-top:24px}
.ilp-doc__notes h4{margin:0 0 7px;font-size:10px;font-weight:var(--weight-bold);letter-spacing:.08em;text-transform:uppercase;color:var(--text-muted)}
.ilp-doc__notes p{margin:0 0 16px;font-size:var(--fs-xs);line-height:1.65;color:var(--text-secondary);text-wrap:pretty}
.ilp-doc__sum{display:flex;flex-direction:column;gap:9px}
.ilp-doc__sumline{display:flex;justify-content:space-between;gap:var(--space-4);font-size:var(--fs-sm);color:var(--text-secondary)}
.ilp-doc__sumline b{font-weight:var(--weight-semibold);color:var(--text-primary);font-variant-numeric:tabular-nums}
.ilp-doc__sumline--rule{padding-top:9px;border-top:1px solid var(--border-subtle)}
.ilp-doc__total{display:flex;align-items:baseline;justify-content:space-between;gap:var(--space-4);margin-top:5px;padding:15px 18px;background:var(--il-grayblue-700);border-radius:var(--radius-md);color:#fff}
.ilp-doc__total span{font-size:var(--fs-xs);font-weight:var(--weight-bold);letter-spacing:.1em;text-transform:uppercase;opacity:.75}
.ilp-doc__total b{font-size:var(--fs-2xl);font-weight:var(--weight-black);letter-spacing:-0.02em;font-variant-numeric:tabular-nums}
.ilp-doc__totalnote{margin-top:7px;font-size:var(--fs-xs);color:var(--text-muted);text-align:right}

/* fact blocks */
.ilp-doc__blocks{display:grid;grid-template-columns:repeat(auto-fit,minmax(210px,1fr));gap:var(--space-5);margin-top:32px;padding-top:24px;border-top:1px solid var(--border-subtle)}
.ilp-doc__block h4{margin:0 0 9px;font-size:10px;font-weight:var(--weight-bold);letter-spacing:.08em;text-transform:uppercase;color:var(--text-muted)}
.ilp-doc__block dl{display:flex;flex-direction:column;gap:6px;margin:0}
.ilp-doc__block .r{display:flex;justify-content:space-between;gap:var(--space-3);font-size:var(--fs-xs);line-height:1.5}
.ilp-doc__block dt{color:var(--text-muted);white-space:nowrap}
.ilp-doc__block dd{margin:0;font-weight:var(--weight-semibold);text-align:right;word-break:break-word}

/* signatures */
.ilp-doc__sigs{display:grid;grid-template-columns:repeat(auto-fit,minmax(170px,1fr));gap:var(--space-6);margin-top:38px}
.ilp-doc__sig{padding-top:9px;border-top:1px solid var(--il-grayblue-300)}
.ilp-doc__sig b{display:block;font-size:var(--fs-sm);font-weight:var(--weight-bold)}
.ilp-doc__sig span{display:block;margin-top:1px;font-size:var(--fs-xs);color:var(--text-muted)}
.ilp-doc__sigmark{height:34px;margin-bottom:4px;font-family:var(--font-serif);font-size:var(--fs-xl);font-style:italic;color:var(--il-grayblue-600);display:flex;align-items:flex-end}

/* sheet footer */
.ilp-doc__end{display:flex;align-items:center;justify-content:space-between;gap:var(--space-4);padding:16px 48px;font-size:10px;line-height:1.6;color:var(--text-muted);background:var(--il-grayblue-50);border-top:1px solid var(--border-subtle)}
.ilp-doc__end b{font-weight:var(--weight-bold);color:var(--text-secondary)}

@media print{
  @page{margin:12mm}
  .ilp-doc__wrap{padding:0;background:#fff;display:block}
  .ilp-doc__bar{display:none !important}
  .ilp-doc{max-width:none;width:auto;border:0;border-radius:0;box-shadow:none}
  .ilp-doc__pad{padding:0}
  .ilp-doc__end{padding:16px 0;background:transparent}
  .ilp-doc__table thead th{-webkit-print-color-adjust:exact;print-color-adjust:exact}
  .ilp-doc__total,.ilp-doc__stamp{-webkit-print-color-adjust:exact;print-color-adjust:exact}
  .ilp-doc__table tr,.ilp-doc__block,.ilp-doc__sig{break-inside:avoid}
  .ilp-doc__foot,.ilp-doc__blocks,.ilp-doc__sigs{break-inside:avoid}
}
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-doc-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-doc-css';
    s.textContent = CSS;
    document.head.appendChild(s);
  }, []);
}

const IcPrint = (p) => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true" {...p}>
    <path d="M7 9V3h10v6" /><path d="M7 18H4v-6a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v6h-3" /><path d="M7 15h10v6H7z" />
  </svg>
);

const alignCls = (c) => (c.align === 'right' || c.type === 'number' ? 'ilp-doc__num' : c.align === 'center' ? 'ilp-doc__ctr' : '');

/** Printable business document — invoice, inspection report, packing list, credit note. */
export function ReportDocument({
  kind = 'Invoice',
  number,
  status,
  logo = null,
  issuer,
  parties = [],
  meta = [],
  columns = [],
  items = [],
  groupBy = null,
  summary = [],
  total,
  notes = [],
  blocks = [],
  signatures = [],
  footerNote,
  footerRight,
  paper = 'a4',
  toolbarTitle,
  actions = null,
  showPrint = true,
  className = '',
  ...rest
}) {
  useCSS();

  const grouped = React.useMemo(() => {
    if (!groupBy) return [{ key: null, items }];
    const m = new Map();
    for (const it of items) {
      const k = it[groupBy] ?? '—';
      if (!m.has(k)) m.set(k, []);
      m.get(k).push(it);
    }
    return [...m.entries()].map(([key, list]) => ({ key, items: list }));
  }, [items, groupBy]);

  return (
    <div className="ilp-doc__wrap">
      {(showPrint || actions || toolbarTitle) && (
        <div className="ilp-doc__bar">
          {toolbarTitle && <h1>{toolbarTitle}</h1>}
          {actions}
          {showPrint && (
            <button type="button" className="ilp-doc__btn ilp-doc__btn--primary" onClick={() => window.print()}>
              <IcPrint />Print / PDF
            </button>
          )}
        </div>
      )}

      <article className={'ilp-doc ilp-doc--' + paper + (className ? ' ' + className : '')} {...rest}>
        <div className="ilp-doc__pad">
          <header className="ilp-doc__top">
            <div className="ilp-doc__brand">
              {logo && <div className="ilp-doc__logo">{logo}</div>}
              {issuer && (
                <address className="ilp-doc__issuer" style={{ fontStyle: 'normal' }}>
                  <b>{issuer.name}</b>
                  {issuer.lines && issuer.lines.map((l) => <div key={l}>{l}</div>)}
                </address>
              )}
            </div>
            <div className="ilp-doc__idblock">
              <div className="ilp-doc__kind">{kind}</div>
              {number && <p className="ilp-doc__no">{number}</p>}
              {status && <span className={'ilp-doc__stamp' + (status.tone ? ' ilp-doc__stamp--' + status.tone : '')}>{status.label}</span>}
            </div>
          </header>

          {meta.length > 0 && (
            <div className="ilp-doc__meta">
              {meta.map((m) => (
                <div key={m.label}>
                  <span className="ilp-doc__lbl">{m.label}</span>
                  <span className="ilp-doc__val">{m.value}{m.hint && <span className="ilp-doc__hint">{m.hint}</span>}</span>
                </div>
              ))}
            </div>
          )}

          {parties.length > 0 && (
            <div className="ilp-doc__parties">
              {parties.map((p) => (
                <div className="ilp-doc__party" key={p.label}>
                  <span className="ilp-doc__lbl">{p.label}</span>
                  <b>{p.name}</b>
                  {p.address && <p>{p.address}</p>}
                  {p.rows && (
                    <dl>
                      {p.rows.map((r) => <React.Fragment key={r.label}><dt>{r.label}</dt><dd>{r.value}</dd></React.Fragment>)}
                    </dl>
                  )}
                </div>
              ))}
            </div>
          )}

          {columns.length > 0 && (
            <table className="ilp-doc__table">
              <thead>
                <tr>{columns.map((c) => <th key={c.key} className={alignCls(c)} style={c.width ? { width: c.width } : undefined}>{c.header}</th>)}</tr>
              </thead>
              <tbody>
                {grouped.map((g) => (
                  <React.Fragment key={g.key ?? 'all'}>
                    {g.key && <tr className="ilp-doc__grouprow"><td colSpan={columns.length}>{g.key}</td></tr>}
                    {g.items.map((row, i) => (
                      <tr key={row.id ?? i}>
                        {columns.map((c) => {
                          const v = row[c.key];
                          return (
                            <td key={c.key} className={alignCls(c) + (c.key === columns[0].key && row.note ? ' ilp-doc__desc' : '')}>
                              {c.render ? c.render(v, row) : c.format ? c.format(v, row) : v}
                              {c.key === columns[0].key && row.note && <span>{row.note}</span>}
                            </td>
                          );
                        })}
                      </tr>
                    ))}
                  </React.Fragment>
                ))}
              </tbody>
            </table>
          )}

          {(summary.length > 0 || total || notes.length > 0) && (
            <div className="ilp-doc__foot">
              <div className="ilp-doc__notes">
                {notes.map((n) => (
                  <React.Fragment key={n.title}>
                    <h4>{n.title}</h4>
                    <p>{n.body}</p>
                  </React.Fragment>
                ))}
              </div>
              <div>
                <div className="ilp-doc__sum">
                  {summary.map((s) => (
                    <div key={s.label} className={'ilp-doc__sumline' + (s.rule ? ' ilp-doc__sumline--rule' : '')}>
                      <span>{s.label}</span><b>{s.value}</b>
                    </div>
                  ))}
                </div>
                {total && (
                  <>
                    <div className="ilp-doc__total"><span>{total.label || 'Total'}</span><b>{total.value}</b></div>
                    {total.note && <div className="ilp-doc__totalnote">{total.note}</div>}
                  </>
                )}
              </div>
            </div>
          )}

          {blocks.length > 0 && (
            <div className="ilp-doc__blocks">
              {blocks.map((b) => (
                <section className="ilp-doc__block" key={b.title}>
                  <h4>{b.title}</h4>
                  <dl>
                    {b.rows.map((r) => (
                      <div className="r" key={r.label}><dt>{r.label}</dt><dd>{r.value}</dd></div>
                    ))}
                  </dl>
                </section>
              ))}
            </div>
          )}

          {signatures.length > 0 && (
            <div className="ilp-doc__sigs">
              {signatures.map((s) => (
                <div key={s.role}>
                  <div className="ilp-doc__sigmark">{s.mark || ''}</div>
                  <div className="ilp-doc__sig"><b>{s.name || '\u00a0'}</b><span>{s.role}{s.date ? ' · ' + s.date : ''}</span></div>
                </div>
              ))}
            </div>
          )}
        </div>

        {(footerNote || footerRight) && (
          <footer className="ilp-doc__end">
            <span>{footerNote}</span>
            <span>{footerRight}</span>
          </footer>
        )}
      </article>
    </div>
  );
}
