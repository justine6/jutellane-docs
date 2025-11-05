// /assets/theme-toggle.js
(function () {
  var KEY = "theme"; // 'light' | 'dark'
  var root = document.documentElement;

  function systemPrefersDark() {
    return window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches;
  }

  function apply(theme) {
    root.setAttribute("data-theme", theme);
    btn.textContent = theme === "dark" ? "☀️" : "🌙";
    try { localStorage.setItem(KEY, theme); } catch (_) {}
  }

  function initTheme() {
    var saved = null;
    try { saved = localStorage.getItem(KEY); } catch (_) {}
    if (saved === "light" || saved === "dark") return saved;
    return systemPrefersDark() ? "dark" : "light";
  }

  // Floating button
  var btn = document.createElement("button");
  btn.id = "themeToggle";
  btn.setAttribute(
    "style",
    "position:fixed;bottom:2rem;left:2rem;width:2.5rem;height:2.5rem;border:none;border-radius:50%;font-size:1.2rem;line-height:1.2rem;cursor:pointer;background:#111;color:#fff;opacity:.9;box-shadow:0 2px 8px rgba(0,0,0,.25);z-index:999"
  );

  document.addEventListener("DOMContentLoaded", function () {
    document.body.appendChild(btn);
    apply(initTheme());
  });

  btn.addEventListener("click", function () {
    var next = (root.getAttribute("data-theme") === "dark") ? "light" : "dark";
    apply(next);
  });
})();
