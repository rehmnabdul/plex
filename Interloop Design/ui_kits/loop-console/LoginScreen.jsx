// Loop Console — Login screen. Brand split layout with the loop pattern.
function LoginScreen({ onSignIn }) {
  const { Button, Input, Checkbox, Logo } = window.ILPDesignSystem_7d03df;
  const [email, setEmail] = React.useState('ayesha.khan@interloop.com.pk');
  const [pw, setPw] = React.useState('••••••••••');
  return (
    <div className="lc-login">
      <div className="lc-login__brandside">
        <div className="lc-login__brandtop"><Logo size={30} tone="inverse" /></div>
        <div className="lc-login__brandcopy">
          <div className="lc-eyebrow lc-eyebrow--inv">Loop Console</div>
          <h2 className="lc-login__headline">Run the floor with strength and dynamism.</h2>
          <p className="lc-login__sub">Orders, production, traceability and people — one console for the whole value chain.</p>
        </div>
        <div className="lc-login__brandfoot">Interloop Limited · Together we succeed</div>
      </div>

      <div className="lc-login__formside">
        <div className="lc-login__form">
          <div className="lc-login__formhead">
            <Logo size={28} />
          </div>
          <h3 className="lc-login__title">Sign in to your console</h3>
          <p className="lc-login__hint">Use your Interloop corporate account.</p>

          <form className="lc-login__fields" onSubmit={(e) => { e.preventDefault(); onSignIn(); }}>
            <Input label="Work email" type="email" value={email} onChange={(e) => setEmail(e.target.value)}
                   leadingIcon={<i data-lucide="mail"></i>} />
            <Input label="Password" type="password" value={pw} onChange={(e) => setPw(e.target.value)}
                   leadingIcon={<i data-lucide="lock"></i>} />
            <div className="lc-login__row">
              <Checkbox label="Keep me signed in" defaultChecked />
              <a href="#" className="lc-link">Forgot password?</a>
            </div>
            <Button type="submit" block size="lg" trailingIcon={<i data-lucide="arrow-right"></i>}>Sign in</Button>
          </form>

          <div className="lc-login__sso">
            <span>or continue with</span>
          </div>
          <Button variant="secondary" block leadingIcon={<i data-lucide="building-2"></i>}>Interloop SSO</Button>
        </div>
      </div>
    </div>
  );
}

window.LoginScreen = LoginScreen;
