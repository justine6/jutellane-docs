// /scripts/theme-toggle.js
(function () {
  var KEY = "theme";
  var root = document.documentElement;

  function prefersDark() {
    return window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches;
  }
  function current() { return root.getAttribute("data-theme"); }
  function apply(theme) {
    root.setAttribute("data-theme", theme);
    var b = document.getElementById("themeToggle");
    if (b) b.textContent = theme === "dark" ? "☀️" : "🌙";
    try { localStorage.setItem(KEY, theme); } catch (_) {}
  }
  function initial() {
    try {
      var saved = localStorage.getItem(KEY);
      if (saved === "light" || saved === "dark") return saved;
    } catch (_) {}
    return prefersDark() ? "dark" : "light";
  }

  function ensureButton() {
    var btn = document.getElementById("themeToggle");
    if (btn) return btn;
    var nav = document.querySelector(".nav");
    if (!nav) return null;

    btn = document.createElement("button");
    btn.id = "themeToggle";
    btn.title = "Toggle theme";
    btn.setAttribute("style",
      "margin-left:.25rem;background:transparent;border:none;font-size:1.1rem;cursor:pointer;color:var(--link)");
    nav.appendChild(btn);
    return btn;
  }

  function wire() {
    var btn = ensureButton();
    if (!btn) return;
    btn.addEventListener("click", function () {
      apply(current() === "dark" ? "light" : "dark");
    });
    apply(initial());
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", wire);
  } else {
    wire();
  }
})();
