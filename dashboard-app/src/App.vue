<template>
  <div id="app">
    <router-view />
  </div>
</template>

<script>
export default {
  name: 'App'
}
</script>

<style>
/* 科技蓝主题样式 - 设计系统 */
:root {
  /* Primary colors */
  --primary: #64b5f6;
  --primary-light: #bbdefb;
  --primary-dark: #2286c3;
  --accent-gold: #ffd700;

  /* Background colors */
  --bg-primary: #0a192f;
  --bg-secondary: #102a43;
  --bg-card: rgba(17, 34, 64, 0.85);
  --bg-card-hover: rgba(26, 52, 96, 0.9);

  /* Text colors */
  --text-primary: #e6f1ff;
  --text-secondary: #bbdefb;
  --text-muted: #90caf9;

  /* Border colors */
  --border-color: rgba(100, 181, 246, 0.3);
  --border-hover: rgba(100, 181, 246, 0.5);

  /* Spacing scale (8px base) */
  --space-xs: 4px;
  --space-sm: 8px;
  --space-md: 16px;
  --space-lg: 24px;
  --space-xl: 32px;

  /* Border radius */
  --radius-sm: 6px;
  --radius-md: 12px;
  --radius-lg: 16px;
  --radius-full: 9999px;

  /* Shadows */
  --shadow-sm: 0 2px 8px rgba(0, 0, 0, 0.2);
  --shadow-md: 0 4px 16px rgba(0, 0, 0, 0.25);
  --shadow-lg: 0 8px 32px rgba(0, 0, 0, 0.3);
  --shadow-glow: 0 0 30px rgba(100, 181, 246, 0.15);
  --shadow-glow-strong: 0 0 40px rgba(100, 181, 246, 0.25);

  /* Transitions */
  --transition-fast: 0.15s cubic-bezier(0.4, 0, 0.2, 1);
  --transition-normal: 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  --transition-slow: 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background-color: var(--bg-primary);
  color: var(--text-primary);
  height: 100vh;
  overflow: hidden;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#app {
  height: 100%;
}

/* Accessibility: Reduced motion support */
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}

/* Focus visible states */
:focus-visible {
  outline: 2px solid var(--primary);
  outline-offset: 2px;
}

/* Selection styling */
::selection {
  background: rgba(100, 181, 246, 0.3);
  color: var(--text-primary);
}

/* Scrollbar styling */
::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  background: rgba(17, 34, 64, 0.3);
  border-radius: 4px;
}

::-webkit-scrollbar-thumb {
  background: var(--primary);
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: var(--primary-light);
}
</style>