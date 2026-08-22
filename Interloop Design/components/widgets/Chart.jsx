import React from 'react';

const CSS = `
.ilp-ch{position:relative;width:100%;font-family:var(--font-sans)}
.ilp-ch__row{display:flex;align-items:flex-start;gap:20px}
.ilp-ch__plot{position:relative;flex:1 1 auto;min-width:0}
.ilp-ch svg{display:block}

/* axes — data-ink first: horizontal rules only, emphasised zero line */
.ilp-ch__grid line{stroke:var(--il-grayblue-100);stroke-width:1;shape-rendering:crispEdges}
.ilp-ch__axis{stroke:var(--il-grayblue-300);stroke-width:1;shape-rendering:crispEdges}
.ilp-ch__zero{stroke:var(--il-grayblue-400);stroke-width:1;shape-rendering:crispEdges}
.ilp-ch__tick{font-size:10.5px;font-weight:var(--weight-semibold);fill:var(--text-muted)}
.ilp-ch__tick--x{text-anchor:middle}
.ilp-ch__tick--y{text-anchor:end}
.ilp-ch__atitle{font-size:10px;font-weight:var(--weight-bold);letter-spacing:.07em;text-transform:uppercase;fill:var(--text-disabled)}

/* marks */
.ilp-ch__line{fill:none;stroke-width:2;stroke-linecap:round;stroke-linejoin:round}
.ilp-ch__mark{transition:opacity var(--dur-fast) var(--ease-standard)}
.ilp-ch__mark--dim{opacity:.22}
.ilp-ch__dot{stroke:var(--surface-card);stroke-width:1.5}
.ilp-ch__label{font-size:10px;font-weight:var(--weight-bold);fill:var(--text-secondary)}
.ilp-ch__label--on{fill:#fff}
.ilp-ch__hit{fill:transparent;cursor:crosshair}
.ilp-ch__cross{stroke:var(--il-grayblue-400);stroke-width:1;stroke-dasharray:2 3}

/* reference lines & bands */
.ilp-ch__ref{stroke-width:1.5;stroke-dasharray:5 4}
.ilp-ch__refband{opacity:.09}
.ilp-ch__reflbl{font-size:9.5px;font-weight:var(--weight-bold);letter-spacing:.04em;text-transform:uppercase;paint-order:stroke;stroke:var(--surface-card);stroke-width:3.5px;stroke-linejoin:round}

/* tooltip — a light data card, not a dark pill */
.ilp-ch__tip{position:absolute;z-index:6;min-width:158px;padding:9px 11px;background:var(--surface-card);color:var(--text-primary);border:1px solid var(--border-default);border-radius:var(--radius-md);box-shadow:var(--shadow-lg);pointer-events:none;transform:translate(-50%,-100%);font-size:var(--fs-xs);line-height:1.55}
.ilp-ch__tip b{display:block;padding-bottom:6px;margin-bottom:6px;border-bottom:1px solid var(--border-subtle);font-size:10px;font-weight:var(--weight-bold);letter-spacing:.06em;text-transform:uppercase;color:var(--text-muted)}
.ilp-ch__tiprow{display:flex;align-items:center;gap:8px;white-space:nowrap}
.ilp-ch__tiprow+.ilp-ch__tiprow{margin-top:3px}
.ilp-ch__tiprow i{width:9px;height:9px;border-radius:2px;flex:none}
.ilp-ch__tiprow span{color:var(--text-secondary)}
.ilp-ch__tiprow em{margin-left:auto;padding-left:16px;font-style:normal;font-weight:var(--weight-bold);font-variant-numeric:tabular-nums}

/* legend */
.ilp-ch__legend{display:flex;flex-wrap:wrap;gap:7px 18px;margin-top:14px}
.ilp-ch__legend--right{flex-direction:column;flex-wrap:nowrap;width:152px;margin-top:2px;gap:9px;flex:none}
.ilp-ch__lgttl{font-size:10px;font-weight:var(--weight-bold);letter-spacing:.07em;text-transform:uppercase;color:var(--text-disabled)}
.ilp-ch__lg{display:inline-flex;align-items:center;gap:8px;width:100%;font-size:var(--fs-xs);font-weight:var(--weight-semibold);color:var(--text-secondary);background:none;border:0;padding:0;cursor:pointer;text-align:left}
.ilp-ch__lg i{width:9px;height:9px;border-radius:2px;flex:none}
.ilp-ch__lg span{overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.ilp-ch__lg em{margin-left:auto;font-style:normal;font-weight:var(--weight-bold);color:var(--text-primary);font-variant-numeric:tabular-nums}
.ilp-ch__lg:focus-visible{outline:none;box-shadow:var(--ring);border-radius:var(--radius-sm)}
.ilp-ch__lg--off{opacity:.35}
.ilp-ch__lg--off em{color:var(--text-muted)}

/* donut centre */
.ilp-ch__center{position:absolute;inset:0;display:flex;flex-direction:column;align-items:center;justify-content:center;pointer-events:none;text-align:center}
.ilp-ch__center b{font-size:var(--fs-3xl);font-weight:var(--weight-black);letter-spacing:-0.025em;line-height:1;font-variant-numeric:tabular-nums}
.ilp-ch__center span{margin-top:5px;font-size:10px;font-weight:var(--weight-bold);letter-spacing:.07em;text-transform:uppercase;color:var(--text-muted)}
.ilp-ch__arc{transition:opacity var(--dur-fast) var(--ease-standard)}

/* heatmap + trellis */
.ilp-ch__cellv{font-size:10px;font-weight:var(--weight-bold);text-anchor:middle}
.ilp-ch__panel{font-size:10.5px;font-weight:var(--weight-bold);fill:var(--text-secondary)}
.ilp-ch__scale{display:flex;align-items:center;gap:8px;margin-top:12px;font-size:10px;color:var(--text-muted)}
.ilp-ch__scale i{flex:1;height:8px;border-radius:2px;max-width:180px}
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-ch-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-ch-css';
    s.textContent = CSS;
    document.head.appendChild(s);
  }, []);
}

/** Categorical palette — brand-first, ordered for maximum separation. */
export const CHART_COLORS = [
  'var(--il-blue-500)', 'var(--il-earth)', 'var(--il-air)', 'var(--il-sun)',
  'var(--il-grayblue-400)', 'var(--il-blue-300)', 'var(--il-red)', 'var(--il-blue-800)',
];

/** Sequential ramp for heatmaps and any continuous encoding. */
export const CHART_RAMP = [
  '#f3fafd', '#e4f4fb', '#bfe6f7', '#8fd2f0', '#5fbee9', '#30a8e0', '#2492c8', '#1c7db0', '#15689a',
];

function useWidth(ref) {
  const [w, setW] = React.useState(560);
  React.useEffect(() => {
    const el = ref.current;
    if (!el || typeof ResizeObserver === 'undefined') return;
    const ro = new ResizeObserver(() => setW(el.clientWidth || 560));
    ro.observe(el);
    setW(el.clientWidth || 560);
    return () => ro.disconnect();
  }, [ref]);
  return w;
}

const NUM = new Intl.NumberFormat('en-US', { maximumFractionDigits: 1 });
const fmt = (v, f) => (f ? f(v) : NUM.format(v));

function niceNum(range, round) {
  const exp = Math.floor(Math.log10(Math.abs(range) || 1));
  const f = Math.abs(range) / Math.pow(10, exp);
  const nf = round ? (f < 1.5 ? 1 : f < 3 ? 2 : f < 7 ? 5 : 10) : (f <= 1 ? 1 : f <= 2 ? 2 : f <= 5 ? 5 : 10);
  return nf * Math.pow(10, exp);
}

/** Round axis bounds with evenly-spaced ticks — the BI convention. */
function niceScale(min, max, count = 4) {
  if (min === max) { min = Math.min(0, min); max = max || 1; }
  const step = niceNum(niceNum(max - min, false) / count, true);
  const lo = Math.floor(min / step) * step;
  const hi = Math.ceil(max / step) * step;
  const ticks = [];
  for (let v = lo; v <= hi + step / 2; v += step) ticks.push(Math.round(v * 1e6) / 1e6);
  return { min: lo, max: hi, ticks };
}

function smoothPath(pts) {
  if (pts.length < 2) return '';
  let d = `M${pts[0][0]},${pts[0][1]}`;
  for (let i = 0; i < pts.length - 1; i++) {
    const p0 = pts[i - 1] || pts[i];
    const p1 = pts[i];
    const p2 = pts[i + 1];
    const p3 = pts[i + 2] || p2;
    d += `C${p1[0] + (p2[0] - p0[0]) / 6},${p1[1] + (p2[1] - p0[1]) / 6} ${p2[0] - (p3[0] - p1[0]) / 6},${p2[1] - (p3[1] - p1[1]) / 6} ${p2[0]},${p2[1]}`;
  }
  return d;
}

const polar = (cx, cy, r, deg) => {
  const a = ((deg - 90) * Math.PI) / 180;
  return [cx + r * Math.cos(a), cy + r * Math.sin(a)];
};
const arcPath = (cx, cy, r, from, to) => {
  const [x1, y1] = polar(cx, cy, r, from);
  const [x2, y2] = polar(cx, cy, r, to);
  return `M${x1},${y1}A${r},${r} 0 ${to - from > 180 ? 1 : 0} 1 ${x2},${y2}`;
};

/* ================= cartesian: line · area · bar · stacked · scatter · combo ================= */
function Cartesian({
  type, series, categories, width, height, showGrid, showAxis, valueFormat, rightFormat,
  stacked, percentStack, smooth, maxValue, minValue, onHover, hover, barRadius,
  xTitle, yTitle, y2Title, reference, showLabels, tickCount, focus,
}) {
  const hasRight = series.some((s) => s.axis === 'right');
  const padL = showAxis ? (yTitle ? 56 : 46) : 4;
  const padR = hasRight ? 48 : 8;
  const padB = showAxis ? (xTitle ? 40 : 26) : 4;
  const padT = showLabels ? 20 : 12;
  const w = Math.max(60, width - padL - padR);
  const h = Math.max(50, height - padT - padB);

  const left = series.filter((s) => s.axis !== 'right');
  const right = series.filter((s) => s.axis === 'right');

  const stackTotals = categories.map((_, i) => left.reduce((s, sr) => s + (sr.data[i] ?? 0), 0));
  const flat = (list) => list.flatMap((s) => s.data).filter((v) => v != null);
  const rawMax = percentStack ? 100 : stacked ? Math.max(...stackTotals, 0) : Math.max(...flat(left), 0);
  const rawMin = Math.min(0, ...flat(left));
  const scale = niceScale(minValue ?? rawMin, maxValue ?? rawMax, tickCount);
  const rScale = hasRight ? niceScale(0, Math.max(...flat(right), 0), tickCount) : null;

  const bandW = w / Math.max(1, categories.length);
  const xAt = (i) => padL + bandW * (i + 0.5);
  const yOf = (v, sc) => padT + h - ((v - sc.min) / (sc.max - sc.min || 1)) * h;
  const yAt = (v) => yOf(v, scale);
  const yR = (v) => yOf(v, rScale || scale);

  const barSeries = type === 'combo' ? left.filter((s) => s.mark !== 'line') : type === 'bar' ? left : [];
  const lineSeries = type === 'combo' ? series.filter((s) => s.mark === 'line') : type === 'bar' ? [] : left;
  const groupCount = stacked || percentStack ? 1 : Math.max(1, barSeries.length);
  const barW = Math.min(52, (bandW * 0.66) / groupCount);
  const dim = (s) => focus && focus !== s.name;

  const valueOf = (sr, i) => {
    const v = sr.data[i] ?? 0;
    return percentStack ? (stackTotals[i] ? (v / stackTotals[i]) * 100 : 0) : v;
  };
  const belowOf = (si, i) => (stacked || percentStack
    ? barSeries.slice(0, si).reduce((s, o) => s + valueOf(o, i), 0)
    : 0);

  const xStep = Math.ceil(categories.length / Math.max(1, Math.floor(w / 54)));

  return (
    <svg width={width} height={height} viewBox={`0 0 ${width} ${height}`} style={{ width: '100%' }} role="img">
      {showGrid && (
        <g className="ilp-ch__grid">
          {scale.ticks.map((t) => <line key={t} x1={padL} y1={yAt(t)} x2={padL + w} y2={yAt(t)} />)}
        </g>
      )}

      {reference?.filter((r) => r.to != null).map((r, i) => (
        <rect
          key={'b' + i} className="ilp-ch__refband"
          x={padL} y={yAt(Math.max(r.value, r.to))} width={w}
          height={Math.abs(yAt(r.to) - yAt(r.value))} fill={r.color || 'var(--il-sun)'}
        />
      ))}

      {scale.min < 0 && <line className="ilp-ch__zero" x1={padL} y1={yAt(0)} x2={padL + w} y2={yAt(0)} />}

      {showAxis && (
        <>
          <g className="ilp-ch__tick ilp-ch__tick--y">
            {scale.ticks.map((t) => <text key={t} x={padL - 9} y={yAt(t) + 3.5}>{fmt(t, valueFormat)}</text>)}
          </g>
          <line className="ilp-ch__axis" x1={padL} y1={padT} x2={padL} y2={padT + h} />
          {yTitle && <text className="ilp-ch__atitle" transform={`rotate(-90 12 ${padT + h / 2})`} x={12} y={padT + h / 2} textAnchor="middle">{yTitle}</text>}
          {rScale && (
            <g className="ilp-ch__tick" textAnchor="start">
              {rScale.ticks.map((t) => <text key={t} x={padL + w + 9} y={yR(t) + 3.5}>{fmt(t, rightFormat || valueFormat)}</text>)}
            </g>
          )}
          {y2Title && <text className="ilp-ch__atitle" transform={`rotate(90 ${width - 8} ${padT + h / 2})`} x={width - 8} y={padT + h / 2} textAnchor="middle">{y2Title}</text>}
        </>
      )}

      {/* bars */}
      {barSeries.map((sr, si) => (
        <g key={sr.name} className={'ilp-ch__mark' + (dim(sr) ? ' ilp-ch__mark--dim' : '')}>
          {categories.map((_, i) => {
            const v = valueOf(sr, i);
            const below = belowOf(si, i);
            const y = yAt(below + v);
            const barH = Math.max(0, yAt(below) - y);
            const x = stacked || percentStack
              ? xAt(i) - barW / 2
              : xAt(i) - (barW * barSeries.length) / 2 + barW * si;
            const cap = (stacked || percentStack) && si < barSeries.length - 1 ? 0 : barRadius;
            return (
              <g key={i}>
                <rect
                  x={x} y={y} width={Math.max(1, barW - 2)} height={barH}
                  rx={Math.min(cap, barW / 2)} fill={sr.color}
                  onMouseEnter={() => onHover({ i, x: xAt(i), y })}
                  onMouseLeave={() => onHover(null)}
                />
                {showLabels && barH > 14 && (
                  <text className={'ilp-ch__label' + (barH > 22 && (stacked || percentStack) ? ' ilp-ch__label--on' : '')}
                    x={x + (barW - 2) / 2} y={stacked || percentStack ? y + barH / 2 + 4 : y - 5} textAnchor="middle">
                    {fmt(v, valueFormat)}
                  </text>
                )}
              </g>
            );
          })}
        </g>
      ))}

      {/* lines & areas */}
      {lineSeries.map((sr) => {
        const scaleFor = sr.axis === 'right' ? yR : yAt;
        const pts = sr.data.map((v, i) => [xAt(i), scaleFor(v ?? 0)]);
        const d = smooth ? smoothPath(pts) : `M${pts.map((p) => p.join(',')).join('L')}`;
        return (
          <g key={sr.name} className={'ilp-ch__mark' + (dim(sr) ? ' ilp-ch__mark--dim' : '')}>
            {type === 'area' && (
              <path d={`${d}L${pts[pts.length - 1][0]},${yAt(Math.max(0, scale.min))}L${pts[0][0]},${yAt(Math.max(0, scale.min))}Z`} fill={sr.color} opacity="0.12" />
            )}
            {type !== 'scatter' && <path className="ilp-ch__line" d={d} stroke={sr.color} strokeDasharray={sr.dashed ? '6 4' : undefined} />}
            {pts.map((p, i) => (
              <circle
                key={i} className="ilp-ch__dot" cx={p[0]} cy={p[1]}
                r={type === 'scatter' ? (sr.sizes ? 4 + (sr.sizes[i] || 0) * 6 : 4.5) : hover?.i === i ? 4.5 : 0}
                fill={sr.color}
                onMouseEnter={type === 'scatter' ? () => onHover({ i, x: p[0], y: p[1] }) : undefined}
                onMouseLeave={type === 'scatter' ? () => onHover(null) : undefined}
              />
            ))}
            {showLabels && type !== 'scatter' && pts.map((p, i) => (
              <text key={'l' + i} className="ilp-ch__label" x={p[0]} y={p[1] - 9} textAnchor="middle">{fmt(sr.data[i], valueFormat)}</text>
            ))}
          </g>
        );
      })}

      {/* reference lines on top of marks */}
      {reference?.map((r, i) => (
        <g key={'r' + i}>
          <line className="ilp-ch__ref" x1={padL} y1={yAt(r.value)} x2={padL + w} y2={yAt(r.value)} stroke={r.color || 'var(--il-red)'} />
          {r.label && (
            <text className="ilp-ch__reflbl" x={padL + w - 3} y={yAt(r.value) - 5} textAnchor="end" fill={r.color || 'var(--il-red)'}>{r.label}</text>
          )}
        </g>
      ))}

      {showAxis && (
        <>
          <line className="ilp-ch__axis" x1={padL} y1={padT + h} x2={padL + w} y2={padT + h} />
          <g className="ilp-ch__tick ilp-ch__tick--x">
            {categories.map((c, i) => (i % xStep === 0 ? <text key={c + i} x={xAt(i)} y={padT + h + 16}>{c}</text> : null))}
          </g>
          {xTitle && <text className="ilp-ch__atitle" x={padL + w / 2} y={height - 4} textAnchor="middle">{xTitle}</text>}
        </>
      )}

      {hover && type !== 'scatter' && <line className="ilp-ch__cross" x1={xAt(hover.i)} y1={padT} x2={xAt(hover.i)} y2={padT + h} />}

      {type !== 'scatter' && categories.map((_, i) => (
        <rect
          key={i} className="ilp-ch__hit"
          x={padL + bandW * i} y={padT} width={bandW} height={h}
          onMouseEnter={() => onHover({ i, x: xAt(i), y: yAt(Math.max(...series.map((s) => s.data[i] ?? 0))) })}
          onMouseLeave={() => onHover(null)}
        />
      ))}
    </svg>
  );
}

/* ================= horizontal bars (sorted) ================= */
function HBars({ series, categories, width, height, valueFormat, maxValue, reference, showLabels }) {
  const sr = series[0];
  const padL = Math.min(150, Math.max(80, ...categories.map((c) => c.length * 6.6)));
  const w = Math.max(50, width - padL - 54);
  const scale = niceScale(0, maxValue ?? Math.max(...sr.data, 1), 4);
  const padT = reference?.length ? 18 : 4;
  const plotH = Math.max(30, height - padT - 14);
  const rowH = plotH / categories.length;
  const barH = Math.min(20, rowH * 0.56);
  const xAt = (v) => (v / scale.max) * w;
  return (
    <svg width={width} height={height} viewBox={`0 0 ${width} ${height}`} style={{ width: '100%' }} role="img">
      <g className="ilp-ch__grid">
        {scale.ticks.map((t) => <line key={t} x1={padL + xAt(t)} y1={padT} x2={padL + xAt(t)} y2={padT + plotH} />)}
      </g>
      {categories.map((c, i) => {
        const v = sr.data[i] ?? 0;
        const y = padT + rowH * i + rowH / 2;
        return (
          <g key={c}>
            <text className="ilp-ch__tick ilp-ch__tick--y" x={padL - 12} y={y + 4}>{c}</text>
            <rect className="ilp-ch__mark" x={padL} y={y - barH / 2} width={Math.max(2, xAt(v))} height={barH}
              rx={2} fill={sr.colors?.[i] || sr.color} />
            {showLabels !== false && <text className="ilp-ch__label" x={padL + xAt(v) + 8} y={y + 4}>{fmt(v, valueFormat)}</text>}
          </g>
        );
      })}
      {reference?.map((r, i) => (
        <g key={i}>
          <line className="ilp-ch__ref" x1={padL + xAt(r.value)} y1={padT} x2={padL + xAt(r.value)} y2={padT + plotH} stroke={r.color || 'var(--il-red)'} />
          {r.label && <text className="ilp-ch__reflbl" x={padL + xAt(r.value)} y={11} textAnchor="middle" fill={r.color || 'var(--il-red)'}>{r.label}</text>}
        </g>
      ))}
      <g className="ilp-ch__tick ilp-ch__tick--x">
        {scale.ticks.map((t) => <text key={t} x={padL + xAt(t)} y={height - 2}>{fmt(t, valueFormat)}</text>)}
      </g>
    </svg>
  );
}

/* ================= bullet graph — actual vs target vs qualitative bands ================= */
function Bullet({ series, categories, width, height, valueFormat, reference }) {
  const rows = categories.length;
  const rowH = height / rows;
  const padL = Math.min(160, Math.max(90, ...categories.map((c) => c.length * 6.6)));
  const w = Math.max(60, width - padL - 60);
  const max = Math.max(...series[0].data, ...(series[1]?.data || [0]), ...(reference?.map((r) => r.value) || [0])) * 1.1;
  const xAt = (v) => (v / max) * w;
  const bands = [0.6, 0.85, 1];
  return (
    <svg width={width} height={height} viewBox={`0 0 ${width} ${height}`} style={{ width: '100%' }} role="img">
      {categories.map((c, i) => {
        const y = rowH * i + rowH / 2;
        const actual = series[0].data[i] ?? 0;
        const target = series[1]?.data[i];
        const good = target != null && actual >= target;
        return (
          <g key={c}>
            <text className="ilp-ch__tick ilp-ch__tick--y" x={padL - 12} y={y + 4}>{c}</text>
            {/* widest/lightest first so the narrow dark bands land on top */}
            {[...bands].reverse().map((b, bi) => (
              <rect key={bi} x={padL} y={y - 11} width={xAt(max * b)} height={22}
                fill={['var(--il-grayblue-50)', 'var(--il-grayblue-100)', 'var(--il-grayblue-200)'][bi]} />
            ))}
            <rect x={padL} y={y - 5} width={Math.max(2, xAt(actual))} height={10} rx={1}
              fill={good ? 'var(--il-earth)' : 'var(--il-blue-500)'} />
            {target != null && (
              <line x1={padL + xAt(target)} y1={y - 12} x2={padL + xAt(target)} y2={y + 12}
                stroke="var(--il-grayblue-800)" strokeWidth="2.5" />
            )}
            <text className="ilp-ch__label" x={padL + w + 8} y={y + 4}>{fmt(actual, valueFormat)}</text>
          </g>
        );
      })}
    </svg>
  );
}

/* ================= heatmap / highlight table ================= */
function Heatmap({ series, categories, rowLabels, width, height, valueFormat, onHover }) {
  const matrix = series[0].matrix || [];
  const padL = Math.min(150, Math.max(70, ...(rowLabels || []).map((c) => c.length * 6.6)));
  const padB = 22;
  const cw = (width - padL - 4) / Math.max(1, categories.length);
  const chh = (height - padB) / Math.max(1, matrix.length);
  const all = matrix.flat().filter((v) => v != null);
  const min = Math.min(...all);
  const max = Math.max(...all);
  const tint = (v) => CHART_RAMP[Math.max(0, Math.min(CHART_RAMP.length - 1, Math.round(((v - min) / (max - min || 1)) * (CHART_RAMP.length - 1))))];
  return (
    <svg width={width} height={height} viewBox={`0 0 ${width} ${height}`} style={{ width: '100%' }} role="img">
      {matrix.map((row, r) => (
        <g key={r}>
          <text className="ilp-ch__tick ilp-ch__tick--y" x={padL - 10} y={chh * r + chh / 2 + 4}>{rowLabels?.[r]}</text>
          {row.map((v, c) => (
            <g key={c}>
              <rect
                x={padL + cw * c + 1} y={chh * r + 1} width={cw - 2} height={chh - 2} rx={2}
                fill={tint(v)}
                onMouseEnter={() => onHover({ label: `${rowLabels?.[r]} · ${categories[c]}`, value: v, color: tint(v), x: padL + cw * c + cw / 2, y: chh * r })}
                onMouseLeave={() => onHover(null)}
              />
              {cw > 42 && (
                <text className="ilp-ch__cellv" x={padL + cw * c + cw / 2} y={chh * r + chh / 2 + 4}
                  fill={(v - min) / (max - min || 1) > 0.55 ? '#fff' : 'var(--text-secondary)'}>
                  {fmt(v, valueFormat)}
                </text>
              )}
            </g>
          ))}
        </g>
      ))}
      <g className="ilp-ch__tick ilp-ch__tick--x">
        {categories.map((c, i) => <text key={c} x={padL + cw * i + cw / 2} y={height - 6}>{c}</text>)}
      </g>
    </svg>
  );
}

/* ================= small multiples ================= */
function Trellis({ panels, categories, width, height, colors, valueFormat, columns }) {
  const cols = columns || Math.min(panels.length, Math.max(2, Math.floor(width / 220)));
  const rows = Math.ceil(panels.length / cols);
  const pw = width / cols;
  const ph = height / rows;
  const flatVals = panels.flatMap((p) => p.data);
  // Anchor on the data range, not zero — small multiples exist to show shape.
  const scale = niceScale(Math.min(...flatVals), Math.max(...flatVals), 2);
  return (
    <svg width={width} height={height} viewBox={`0 0 ${width} ${height}`} style={{ width: '100%' }} role="img">
      {panels.map((p, i) => {
        const ox = (i % cols) * pw;
        const oy = Math.floor(i / cols) * ph;
        const w = pw - 18;
        const h = ph - 34;
        const pts = p.data.map((v, j) => [
          ox + 10 + (j / Math.max(1, p.data.length - 1)) * w,
          oy + 26 + h - ((v - scale.min) / (scale.max - scale.min || 1)) * h,
        ]);
        const color = p.color || colors[i % colors.length];
        return (
          <g key={p.title}>
            <text className="ilp-ch__panel" x={ox + 10} y={oy + 14}>{p.title}</text>
            <text className="ilp-ch__tick" x={ox + pw - 12} y={oy + 14} textAnchor="end">{fmt(p.data[p.data.length - 1], valueFormat)}</text>
            <line className="ilp-ch__grid" x1={ox + 10} y1={oy + 26 + h} x2={ox + 10 + w} y2={oy + 26 + h} stroke="var(--il-grayblue-100)" />
            <path d={`M${pts.map((q) => q.join(',')).join('L')}L${pts[pts.length - 1][0]},${oy + 26 + h}L${pts[0][0]},${oy + 26 + h}Z`} fill={color} opacity="0.12" />
            <path className="ilp-ch__line" d={`M${pts.map((q) => q.join(',')).join('L')}`} stroke={color} strokeWidth="1.8" />
            <circle cx={pts[pts.length - 1][0]} cy={pts[pts.length - 1][1]} r="2.6" fill={color} />
          </g>
        );
      })}
      {categories?.length ? (
        <g className="ilp-ch__tick ilp-ch__tick--x">
          <text x={10} y={height - 2} textAnchor="start">{categories[0]}</text>
          <text x={pw - 18} y={height - 2} textAnchor="end">{categories[categories.length - 1]}</text>
        </g>
      ) : null}
    </svg>
  );
}

/* ================= donut / pie / radial / spark ================= */
function Donut({ series, categories, size, thickness, pie, centerValue, centerLabel, valueFormat, onHover, colors }) {
  const data = series[0].data;
  const total = data.reduce((a, b) => a + b, 0) || 1;
  const r = pie ? size / 4 : size / 2 - thickness / 2 - 2;
  const stroke = pie ? size / 2 : thickness;
  const c = 2 * Math.PI * r;
  let offset = 0;
  return (
    <svg width={size} height={size} role="img">
      <g transform={`rotate(-90 ${size / 2} ${size / 2})`}>
        {data.map((v, i) => {
          const dash = c * (v / total);
          const el = (
            <circle
              key={i} className="ilp-ch__arc" cx={size / 2} cy={size / 2} r={r} fill="none"
              stroke={series[0].colors?.[i] || colors[i % colors.length]} strokeWidth={stroke}
              strokeDasharray={`${dash} ${c - dash}`} strokeDashoffset={-offset}
              onMouseEnter={() => onHover && onHover({ i, label: categories[i], value: v, pct: (v / total) * 100 })}
              onMouseLeave={() => onHover && onHover(null)}
            />
          );
          offset += dash;
          return el;
        })}
      </g>
      {!pie && (centerValue != null || centerLabel) && (
        <foreignObject x="0" y="0" width={size} height={size}>
          <div className="ilp-ch__center">
            {centerValue != null && <b>{typeof centerValue === 'number' ? fmt(centerValue, valueFormat) : centerValue}</b>}
            {centerLabel && <span>{centerLabel}</span>}
          </div>
        </foreignObject>
      )}
    </svg>
  );
}

function Radial({ value, max, size, thickness, color, label, valueFormat, reference }) {
  const span = 260;
  const start = -130;
  const pct = Math.max(0, Math.min(1, value / max));
  const r = size / 2 - thickness / 2 - 2;
  return (
    <svg width={size} height={size} role="img">
      <path d={arcPath(size / 2, size / 2, r, start, start + span)} fill="none" stroke="var(--il-grayblue-100)" strokeWidth={thickness} strokeLinecap="round" />
      <path d={arcPath(size / 2, size / 2, r, start, start + span * (pct || 0.0001))} fill="none" stroke={color} strokeWidth={thickness} strokeLinecap="round" />
      {reference?.map((rf, i) => {
        const a = start + span * Math.max(0, Math.min(1, rf.value / max));
        const [x1, y1] = polar(size / 2, size / 2, r - thickness / 2 - 2, a);
        const [x2, y2] = polar(size / 2, size / 2, r + thickness / 2 + 2, a);
        return <line key={i} x1={x1} y1={y1} x2={x2} y2={y2} stroke={rf.color || 'var(--il-grayblue-800)'} strokeWidth="2.5" />;
      })}
      <foreignObject x="0" y="0" width={size} height={size}>
        <div className="ilp-ch__center">
          <b>{fmt(value, valueFormat)}</b>
          {label && <span>{label}</span>}
        </div>
      </foreignObject>
    </svg>
  );
}

function Spark({ series, width, height, smooth }) {
  const data = series[0].data;
  const max = Math.max(...data);
  const min = Math.min(...data);
  const span = max - min || 1;
  const pts = data.map((v, i) => [(i / (data.length - 1)) * (width - 4) + 2, height - 3 - ((v - min) / span) * (height - 8)]);
  const d = smooth ? smoothPath(pts) : `M${pts.map((p) => p.join(',')).join('L')}`;
  return (
    <svg width={width} height={height} viewBox={`0 0 ${width} ${height}`} style={{ width: '100%' }} role="img">
      <path d={`${d}L${pts[pts.length - 1][0]},${height}L${pts[0][0]},${height}Z`} fill={series[0].color} opacity="0.14" />
      <path className="ilp-ch__line" d={d} stroke={series[0].color} strokeWidth="1.8" />
      <circle cx={pts[pts.length - 1][0]} cy={pts[pts.length - 1][1]} r="2.8" fill={series[0].color} />
    </svg>
  );
}

/**
 * Analytics chart in the enterprise-BI idiom: round axis scales, restrained
 * grids, reference lines and bands, mark labels, a light tooltip card, and a
 * legend that filters. Thirteen marks, no charting dependency.
 */
export function Chart({
  type = 'line',
  series = [],
  categories = [],
  rowLabels = [],
  panels = [],
  height = 240,
  colors = CHART_COLORS,
  showGrid = true,
  showAxis = true,
  showLegend = false,
  legendPosition = 'bottom',
  legendTitle,
  showTooltip = true,
  showLabels = false,
  smooth = false,
  stacked = false,
  percentStack = false,
  sort,
  barRadius = 2,
  thickness = 22,
  tickCount = 4,
  max: maxValue,
  min: minValue,
  value = 0,
  centerValue,
  centerLabel,
  label,
  xTitle,
  yTitle,
  y2Title,
  reference,
  valueFormat,
  rightFormat,
  trellisColumns,
  className = '',
  ...rest
}) {
  useCSS();
  const ref = React.useRef(null);
  const plotRef = React.useRef(null);
  const full = useWidth(ref);
  const plotW = useWidth(plotRef);
  const [hidden, setHidden] = React.useState(() => new Set());
  const [focus, setFocus] = React.useState(null);
  const [hover, setHover] = React.useState(null);
  const [slice, setSlice] = React.useState(null);
  const [cell, setCell] = React.useState(null);

  const rightLegend = showLegend && legendPosition === 'right';
  // Measure the plot slot flexbox actually gave us — never derive it from the
  // outer box, or the SVG ends up wider than its slot and clips.
  const width = Math.max(120, plotW || (rightLegend ? full - 172 : full));

  const painted = React.useMemo(
    () => series.map((s, i) => ({ ...s, color: s.color || colors[i % colors.length] })),
    [series, colors],
  );

  /* sorting is a first-class analytic act, not a data-prep step */
  const sorted = React.useMemo(() => {
    if (!sort || !painted[0]?.data) return { series: painted, categories };
    const order = categories
      .map((c, i) => ({ c, i, v: painted[0].data[i] ?? 0 }))
      .sort((a, b) => (sort === 'asc' ? a.v - b.v : b.v - a.v));
    return {
      categories: order.map((o) => o.c),
      series: painted.map((s) => ({ ...s, data: order.map((o) => s.data[o.i]), colors: s.colors ? order.map((o) => s.colors[o.i]) : undefined })),
    };
  }, [painted, categories, sort]);

  const active = sorted.series.filter((s) => !hidden.has(s.name));
  const round = type === 'donut' || type === 'pie';
  const radial = type === 'radial';
  const size = Math.min(height, width || height);

  const toggle = (name) => setHidden((h) => {
    const n = new Set(h);
    n.has(name) ? n.delete(name) : n.add(name);
    return n;
  });

  const legendItems = round
    ? sorted.categories.map((c, i) => ({ name: c, color: painted[0]?.colors?.[i] || colors[i % colors.length], value: series[0].data[i] }))
    : painted.map((s) => ({ name: s.name, color: s.color }));

  const legend = showLegend && (
    <div className={'ilp-ch__legend' + (rightLegend ? ' ilp-ch__legend--right' : '')}>
      {legendTitle && rightLegend && <span className="ilp-ch__lgttl">{legendTitle}</span>}
      {legendItems.map((li) => (
        <button
          type="button" key={li.name}
          className={'ilp-ch__lg' + (hidden.has(li.name) ? ' ilp-ch__lg--off' : '')}
          onClick={() => !round && toggle(li.name)}
          onMouseEnter={() => !round && setFocus(li.name)}
          onMouseLeave={() => setFocus(null)}
        >
          <i style={{ background: li.color }} />
          <span>{li.name}</span>
          {li.value != null && <em>{fmt(li.value, valueFormat)}</em>}
        </button>
      ))}
    </div>
  );

  const plot = (
    <div className="ilp-ch__plot" ref={plotRef} style={round || radial ? { display: 'flex', justifyContent: 'center' } : undefined}>
      {type === 'spark' ? (
        <Spark series={painted} width={width} height={height} smooth={smooth} />
      ) : radial ? (
        <Radial value={value} max={maxValue ?? 100} size={size} thickness={thickness}
          color={painted[0]?.color || colors[0]} label={label} valueFormat={valueFormat} reference={reference} />
      ) : round ? (
        <Donut series={painted} categories={sorted.categories} size={size} thickness={thickness}
          pie={type === 'pie'} centerValue={centerValue} centerLabel={centerLabel}
          valueFormat={valueFormat} onHover={setSlice} colors={colors} />
      ) : type === 'hbar' ? (
        <HBars series={sorted.series} categories={sorted.categories} width={width} height={height}
          valueFormat={valueFormat} maxValue={maxValue} reference={reference} showLabels={showLabels !== false} />
      ) : type === 'bullet' ? (
        <Bullet series={painted} categories={categories} width={width} height={height} valueFormat={valueFormat} reference={reference} />
      ) : type === 'heatmap' ? (
        <Heatmap series={painted} categories={categories} rowLabels={rowLabels} width={width} height={height}
          valueFormat={valueFormat} onHover={setCell} />
      ) : type === 'trellis' ? (
        <Trellis panels={panels} categories={categories} width={width} height={height}
          colors={colors} valueFormat={valueFormat} columns={trellisColumns} />
      ) : (
        <Cartesian
          type={type} series={active} categories={sorted.categories} width={width} height={height}
          showGrid={showGrid} showAxis={showAxis} valueFormat={valueFormat} rightFormat={rightFormat}
          stacked={stacked} percentStack={percentStack} smooth={smooth}
          maxValue={maxValue} minValue={minValue} barRadius={barRadius} tickCount={tickCount}
          xTitle={xTitle} yTitle={yTitle} y2Title={y2Title} reference={reference}
          showLabels={showLabels} focus={focus} onHover={setHover} hover={hover}
        />
      )}

      {showTooltip && hover && active.length > 0 && (
        <div className="ilp-ch__tip" style={{ left: hover.x, top: Math.max(34, hover.y - 14) }}>
          <b>{sorted.categories[hover.i]}</b>
          {active.map((s) => (
            <div className="ilp-ch__tiprow" key={s.name}>
              <i style={{ background: s.color }} />
              <span>{s.name}</span>
              <em>{fmt(s.data[hover.i] ?? 0, s.axis === 'right' ? (rightFormat || valueFormat) : valueFormat)}</em>
            </div>
          ))}
        </div>
      )}
      {showTooltip && slice && (
        <div className="ilp-ch__tip" style={{ left: '50%', top: 26 }}>
          <b>{slice.label}</b>
          <div className="ilp-ch__tiprow">
            <i style={{ background: painted[0].colors?.[slice.i] || colors[slice.i % colors.length] }} />
            <span>Value</span><em>{fmt(slice.value, valueFormat)}</em>
          </div>
          <div className="ilp-ch__tiprow"><i style={{ background: 'transparent' }} /><span>Share</span><em>{slice.pct.toFixed(1)}%</em></div>
        </div>
      )}
      {showTooltip && cell && (
        <div className="ilp-ch__tip" style={{ left: cell.x, top: Math.max(30, cell.y) }}>
          <b>{cell.label}</b>
          <div className="ilp-ch__tiprow"><i style={{ background: cell.color }} /><span>Value</span><em>{fmt(cell.value, valueFormat)}</em></div>
        </div>
      )}
    </div>
  );

  return (
    <div className={'ilp-ch' + (className ? ' ' + className : '')} ref={ref} {...rest}>
      {rightLegend ? <div className="ilp-ch__row">{plot}{legend}</div> : <>{plot}{legend}</>}
      {type === 'heatmap' && (
        <div className="ilp-ch__scale">
          Low<i style={{ background: `linear-gradient(90deg, ${CHART_RAMP.join(',')})` }} />High
        </div>
      )}
    </div>
  );
}
