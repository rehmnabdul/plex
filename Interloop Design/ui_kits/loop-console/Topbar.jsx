// Loop Console — Topbar. Reads DS components from the bundle namespace.
function Topbar({ title, onMenu }) {
  const { IconButton, Avatar } = window.ILPDesignSystem_7d03df;
  return (
    <header className="lc-topbar">
      <div className="lc-topbar__left">
        <h1 className="lc-topbar__title">{title}</h1>
      </div>
      <div className="lc-search">
        <i data-lucide="search" className="lc-search__icon"></i>
        <input className="lc-search__input" placeholder="Search orders, clients, people…" />
        <span className="lc-search__kbd">⌘K</span>
      </div>
      <div className="lc-topbar__right">
        <IconButton label="Help"><i data-lucide="life-buoy"></i></IconButton>
        <span className="lc-bell">
          <IconButton label="Notifications"><i data-lucide="bell"></i></IconButton>
          <span className="lc-bell__dot"></span>
        </span>
        <IconButton label="Settings"><i data-lucide="settings"></i></IconButton>
        <div className="lc-topbar__divider"></div>
        <div className="lc-topbar__user">
          <Avatar name={window.LC_DATA.user.name} size={36} status="online" />
        </div>
      </div>
    </header>
  );
}

window.Topbar = Topbar;
