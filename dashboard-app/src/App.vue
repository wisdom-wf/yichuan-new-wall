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
/* 科技蓝主题样式 */
:root {
  --primary-color: #0078d7; /* 科技蓝 */
  --background-color: #0a192f; /* 深色背景 */
  --text-color: #e6f1ff; /* 文字颜色 */
  --border-color: #233554; /* 边框颜色 */
  --card-bg: rgba(17, 34, 64, 0.7); /* 卡片背景 */
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background-color: var(--background-color);
  color: var(--text-color);
  height: 100vh;
  overflow: hidden;
}

#app {
  height: 100%;
}
</style>