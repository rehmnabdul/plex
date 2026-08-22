import React from 'react';

const CSS = `
.ilp-wz{display:flex;background:var(--surface-card);border:1px solid var(--border-subtle);border-radius:var(--radius-lg);box-shadow:var(--shadow-sm);font-family:var(--font-sans);color:var(--text-primary);overflow:hidden}
.ilp-wz *{box-sizing:border-box}
.ilp-wz--h{flex-direction:column}

/* ---------- step rail ---------- */
.ilp-wz__rail{display:flex;flex:none}
.ilp-wz--v .ilp-wz__rail{flex-direction:column;gap:2px;width:300px;padding:28px 20px;background:var(--il-grayblue-50);border-right:1px solid var(--border-subtle)}
.ilp-wz--h .ilp-wz__rail{align-items:flex-start;gap:0;padding:24px 28px 22px;background:var(--il-grayblue-50);border-bottom:1px solid var(--border-subtle);overflow-x:auto}

.ilp-wz__step{position:relative;display:flex;align-items:flex-start;gap:14px;padding:12px;background:transparent;border:0;border-radius:var(--radius-md);font:inherit;text-align:left;color:inherit;cursor:default}
.ilp-wz__step--clickable{cursor:pointer}
.ilp-wz__step--clickable:hover{background:var(--il-grayblue-100)}
.ilp-wz__step:focus-visible{outline:none;box-shadow:var(--ring)}
.ilp-wz--h .ilp-wz__step{flex:1 1 0;min-width:170px;align-items:center;padding:8px 12px}
.ilp-wz--v .ilp-wz__step--current{background:var(--surface-card);box-shadow:var(--shadow-xs)}

/* connector */
.ilp-wz--v .ilp-wz__step::after{content:"";position:absolute;left:29px;top:52px;bottom:-2px;width:2px;background:var(--il-grayblue-200)}
.ilp-wz--v .ilp-wz__step:last-child::after{display:none}
.ilp-wz--v .ilp-wz__step--done::after{background:var(--brand-primary)}
.ilp-wz__link{flex:1 1 auto;height:2px;margin-top:19px;background:var(--il-grayblue-200);min-width:16px}
.ilp-wz__link--done{background:var(--brand-primary)}

.ilp-wz__badge{position:relative;z-index:1;display:grid;place-items:center;width:34px;height:34px;flex:none;border-radius:50%;font-size:var(--fs-sm);font-weight:var(--weight-bold);font-variant-numeric:tabular-nums;background:var(--surface-card);border:2px solid var(--il-grayblue-200);color:var(--text-muted);transition:background var(--dur-normal) var(--ease-standard),border-color var(--dur-normal) var(--ease-standard),color var(--dur-normal) var(--ease-standard)}
.ilp-wz__badge svg{width:16px;height:16px}
.ilp-wz__step--current .ilp-wz__badge{background:var(--brand-primary);border-color:var(--brand-primary);color:#fff;box-shadow:0 0 0 4px color-mix(in srgb,var(--il-blue-500) 18%,transparent)}
.ilp-wz__step--done .ilp-wz__badge{background:var(--il-blue-100);border-color:var(--brand-primary);color:var(--il-blue-700)}
.ilp-wz__step--error .ilp-wz__badge{background:var(--il-red-soft);border-color:var(--status-danger);color:var(--il-red-ink)}

.ilp-wz__txt{min-width:0;padding-top:1px}
.ilp-wz__ttl{display:block;font-size:var(--fs-sm);font-weight:var(--weight-bold);line-height:1.3;color:var(--text-secondary)}
.ilp-wz__step--current .ilp-wz__ttl{color:var(--text-primary)}
.ilp-wz__step--done .ilp-wz__ttl{color:var(--text-secondary)}
.ilp-wz__sub{display:block;margin-top:2px;font-size:var(--fs-xs);line-height:1.4;color:var(--text-muted)}
.ilp-wz__opt{margin-left:6px;font-size:10px;font-weight:var(--weight-semibold);color:var(--text-disabled);text-transform:uppercase;letter-spacing:.05em}

/* ---------- body ---------- */
.ilp-wz__main{display:flex;flex-direction:column;flex:1 1 auto;min-width:0;min-height:0}
.ilp-wz__body{flex:1 1 auto;padding:32px 36px;min-height:0;overflow-y:auto}
.ilp-wz--h .ilp-wz__body{padding:30px 32px}
.ilp-wz__foot{display:flex;align-items:center;gap:var(--space-3);padding:16px 32px;border-top:1px solid var(--border-subtle);background:var(--surface-card)}
.ilp-wz__count{font-size:var(--fs-xs);color:var(--text-muted);font-variant-numeric:tabular-nums}
.ilp-wz__grow{margin-left:auto}
.ilp-wz__btn{display:inline-flex;align-items:center;justify-content:center;gap:8px;height:40px;padding:0 20px;font:inherit;font-size:var(--fs-base);font-weight:var(--weight-bold);line-height:1;border:1px solid transparent;border-radius:var(--radius-md);cursor:pointer;white-space:nowrap;transition:background var(--dur-fast) var(--ease-standard),color var(--dur-fast) var(--ease-standard),border-color var(--dur-fast) var(--ease-standard)}
.ilp-wz__btn:active{transform:scale(.975)}
.ilp-wz__btn:focus-visible{outline:none;box-shadow:var(--ring)}
.ilp-wz__btn[disabled]{opacity:.5;cursor:not-allowed;transform:none}
.ilp-wz__btn svg{width:16px;height:16px}
.ilp-wz__btn--primary{background:var(--brand-primary);color:#fff}
.ilp-wz__btn--primary:hover:not([disabled]){background:var(--brand-primary-hover);box-shadow:var(--shadow-brand)}
.ilp-wz__btn--secondary{background:var(--surface-card);color:var(--text-secondary);border-color:var(--border-default)}
.ilp-wz__btn--secondary:hover:not([disabled]){background:var(--surface-hover);color:var(--text-primary);border-color:var(--border-strong)}
.ilp-wz__btn--ghost{background:transparent;color:var(--text-secondary)}
.ilp-wz__btn--ghost:hover:not([disabled]){background:var(--surface-hover);color:var(--text-primary)}

/* ---------- step header ---------- */
.ilp-wzh{margin-bottom:24px}
.ilp-wzh h3{margin:0;font-size:var(--fs-2xl);font-weight:var(--weight-black);letter-spacing:-0.02em;line-height:1.2}
.ilp-wzh p{margin:6px 0 0;font-size:var(--fs-sm);color:var(--text-secondary);text-wrap:pretty}
.ilp-wzh a{color:var(--text-link);font-weight:var(--weight-semibold);text-decoration:none}
.ilp-wzh a:hover{color:var(--il-blue-800);text-decoration:underline}

/* ---------- option cards ---------- */
.ilp-wzo{display:grid;gap:14px}
.ilp-wzo--2{grid-template-columns:repeat(auto-fit,minmax(240px,1fr))}
.ilp-wzo--list{grid-template-columns:1fr}
.ilp-wzc{position:relative;display:flex;align-items:flex-start;gap:14px;width:100%;padding:18px;font:inherit;text-align:left;color:inherit;background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-lg);cursor:pointer;transition:border-color var(--dur-fast) var(--ease-standard),background var(--dur-fast) var(--ease-standard),box-shadow var(--dur-fast) var(--ease-standard)}
.ilp-wzc:hover{border-color:var(--il-blue-300);box-shadow:var(--shadow-xs)}
.ilp-wzc:focus-visible{outline:none;box-shadow:var(--ring)}
.ilp-wzc--on{border-color:var(--brand-primary);background:var(--il-blue-50);box-shadow:0 0 0 1px var(--brand-primary) inset}
.ilp-wzc__ic{display:grid;place-items:center;width:44px;height:44px;flex:none;border-radius:var(--radius-md);background:var(--il-blue-100);color:var(--il-blue-700)}
.ilp-wzc--on .ilp-wzc__ic{background:var(--brand-primary);color:#fff}
.ilp-wzc__ic svg{width:21px;height:21px}
.ilp-wzc__t{min-width:0;flex:1}
.ilp-wzc__t b{display:block;font-size:var(--fs-base);font-weight:var(--weight-bold);line-height:1.3}
.ilp-wzc__t span{display:block;margin-top:3px;font-size:var(--fs-sm);line-height:1.5;color:var(--text-secondary);text-wrap:pretty}
.ilp-wzc__tick{display:grid;place-items:center;width:20px;height:20px;flex:none;border-radius:50%;border:1.5px solid var(--border-strong);color:transparent}
.ilp-wzc--on .ilp-wzc__tick{background:var(--brand-primary);border-color:var(--brand-primary);color:#fff}
.ilp-wzc__tick svg{width:12px;height:12px}

/* ---------- misc step furniture ---------- */
.ilp-wzseg{display:flex;gap:8px;flex-wrap:wrap}
.ilp-wzseg button{min-width:64px;height:44px;padding:0 18px;font:inherit;font-size:var(--fs-base);font-weight:var(--weight-bold);color:var(--text-secondary);background:var(--surface-card);border:1px solid var(--border-default);border-radius:var(--radius-md);cursor:pointer;transition:background var(--dur-fast) var(--ease-standard)}
.ilp-wzseg button:hover{border-color:var(--border-strong);color:var(--text-primary)}
.ilp-wzseg button[aria-pressed="true"]{background:var(--il-blue-50);border-color:var(--brand-primary);color:var(--il-blue-800)}
.ilp-wzseg button:focus-visible{outline:none;box-shadow:var(--ring)}

.ilp-wzdone{display:flex;flex-direction:column;align-items:center;padding:44px 24px 16px;text-align:center}
.ilp-wzdone__mark{display:grid;place-items:center;width:72px;height:72px;margin-bottom:22px;border-radius:50%;background:var(--il-earth-soft);color:var(--il-earth-ink)}
.ilp-wzdone__mark svg{width:34px;height:34px}
.ilp-wzdone h3{margin:0;font-size:var(--fs-2xl);font-weight:var(--weight-black);letter-spacing:-0.02em}
.ilp-wzdone p{margin:10px 0 0;max-width:52ch;font-size:var(--fs-base);line-height:1.6;color:var(--text-secondary);text-wrap:pretty}
.ilp-wzdone__extra{width:100%;margin-top:32px}

@media (max-width:900px){
  .ilp-wz--v{flex-direction:column}
  .ilp-wz--v .ilp-wz__rail{flex-direction:row;width:auto;overflow-x:auto;padding:18px 20px;border-right:0;border-bottom:1px solid var(--border-subtle)}
  .ilp-wz--v .ilp-wz__step::after{display:none}
  .ilp-wz__body{padding:24px 20px}
  .ilp-wz__foot{padding:14px 20px}
}
`;

function useCSS() {
  React.useEffect(() => {
    if (document.getElementById('ilp-wz-css')) return;
    const s = document.createElement('style');
    s.id = 'ilp-wz-css';
    s.textContent = CSS;
    document.head.appendChild(s);
  }, []);
}

const Ic = (d) => (p) => (
  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true" {...p}>
    {d.map((x, i) => <path key={i} d={x} />)}
  </svg>
);
const IcCheck = Ic(['m4 12.5 5 5L20 6.5']);
const IcBack = Ic(['M19 12H5', 'm11 6-6 6 6 6']);
const IcNext = Ic(['M5 12h14', 'm13 6 6 6-6 6']);
const IcBang = Ic(['M12 7v6', 'M12 16.5v.2']);

/** Section heading inside a wizard step, with the optional help line. */
export function WizardStepHeader({ title, description, helpLabel, helpHref = '#help' }) {
  useCSS();
  return (
    <header className="ilp-wzh">
      <h3>{title}</h3>
      {(description || helpLabel) && (
        <p>
          {description}{description && helpLabel ? ' ' : ''}
          {helpLabel && <a href={helpHref}>{helpLabel}</a>}
        </p>
      )}
    </header>
  );
}

/** Large selectable card — the wizard's primary choice control. */
export function WizardOptionCard({ selected = false, icon = null, title, description, as = 'button', ...rest }) {
  useCSS();
  const Tag = as;
  return (
    <Tag
      type={Tag === 'button' ? 'button' : undefined}
      className={'ilp-wzc' + (selected ? ' ilp-wzc--on' : '')}
      aria-pressed={Tag === 'button' ? selected : undefined}
      {...rest}
    >
      {icon && <span className="ilp-wzc__ic">{icon}</span>}
      <span className="ilp-wzc__t">
        <b>{title}</b>
        {description && <span>{description}</span>}
      </span>
      <span className="ilp-wzc__tick"><IcCheck /></span>
    </Tag>
  );
}

/** Grid wrapper for WizardOptionCards. */
export function WizardOptions({ layout = 'grid', children }) {
  useCSS();
  return <div className={'ilp-wzo ilp-wzo--' + (layout === 'list' ? 'list' : '2')}>{children}</div>;
}

/** Terminal success panel for the final step. */
export function WizardDone({ title, description, children }) {
  useCSS();
  return (
    <div className="ilp-wzdone">
      <span className="ilp-wzdone__mark"><IcCheck /></span>
      <h3>{title}</h3>
      {description && <p>{description}</p>}
      {children && <div className="ilp-wzdone__extra">{children}</div>}
    </div>
  );
}

/**
 * Multi-step form shell. Horizontal rail across the top or a vertical rail
 * down the left; the step panels are supplied as children, one per step.
 */
export function Wizard({
  steps = [],
  orientation = 'horizontal',
  current,
  defaultStep = 0,
  onStepChange,
  onFinish,
  errorSteps = [],
  linear = true,
  backLabel = 'Back',
  nextLabel = 'Next',
  finishLabel = 'Finish',
  showCount = true,
  canAdvance = true,
  footerStart = null,
  height,
  className = '',
  children,
  ...rest
}) {
  useCSS();
  const controlled = current != null;
  const [internal, setInternal] = React.useState(defaultStep);
  const index = controlled ? current : internal;
  const last = steps.length - 1;

  const go = (next) => {
    if (next < 0 || next > last) return;
    if (!controlled) setInternal(next);
    onStepChange && onStepChange(next);
  };

  const panels = React.Children.toArray(children);
  const panel = typeof children === 'function' ? children(steps[index], index) : panels[index];
  const errors = new Set(errorSteps);

  const stepState = (i) => (errors.has(i) ? 'error' : i === index ? 'current' : i < index ? 'done' : 'todo');

  const renderStep = (step, i) => {
    const state = stepState(i);
    const reachable = !linear || i <= index;
    return (
      <button
        key={step.key || i}
        type="button"
        className={'ilp-wz__step ilp-wz__step--' + state + (reachable && i !== index ? ' ilp-wz__step--clickable' : '')}
        aria-current={i === index ? 'step' : undefined}
        disabled={!reachable}
        onClick={() => reachable && go(i)}
      >
        <span className="ilp-wz__badge">
          {state === 'done' ? <IcCheck /> : state === 'error' ? <IcBang /> : i + 1}
        </span>
        <span className="ilp-wz__txt">
          <span className="ilp-wz__ttl">{step.title}{step.optional && <span className="ilp-wz__opt">Optional</span>}</span>
          {step.subtitle && <span className="ilp-wz__sub">{step.subtitle}</span>}
        </span>
      </button>
    );
  };

  return (
    <section
      className={'ilp-wz ilp-wz--' + (orientation === 'vertical' ? 'v' : 'h') + (className ? ' ' + className : '')}
      {...rest}
      style={{ ...(height ? { height } : null), ...(rest.style || {}) }}
    >
      <div className="ilp-wz__rail" role="tablist" aria-orientation={orientation}>
        {orientation === 'vertical'
          ? steps.map(renderStep)
          : steps.map((step, i) => (
            <React.Fragment key={step.key || i}>
              {i > 0 && <span className={'ilp-wz__link' + (i <= index ? ' ilp-wz__link--done' : '')} />}
              {renderStep(step, i)}
            </React.Fragment>
          ))}
      </div>

      <div className="ilp-wz__main">
        <div className="ilp-wz__body">{panel}</div>
        <footer className="ilp-wz__foot">
          <button type="button" className="ilp-wz__btn ilp-wz__btn--secondary" disabled={index === 0} onClick={() => go(index - 1)}>
            <IcBack />{backLabel}
          </button>
          {footerStart}
          {showCount && <span className="ilp-wz__count ilp-wz__grow">Step {index + 1} of {steps.length}</span>}
          <button
            type="button"
            className={'ilp-wz__btn ilp-wz__btn--primary' + (showCount ? '' : ' ilp-wz__grow')}
            disabled={!canAdvance}
            onClick={() => (index === last ? onFinish && onFinish() : go(index + 1))}
          >
            {index === last ? finishLabel : nextLabel}
            {index === last ? <IcCheck /> : <IcNext />}
          </button>
        </footer>
      </div>
    </section>
  );
}
