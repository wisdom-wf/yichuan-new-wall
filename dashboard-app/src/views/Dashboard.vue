<template>
  <div class="dashboard-container">
    <!-- 顶部标题栏 -->
    <div class="header">
      <div class="header-content">
        <div class="header-left">
          <div class="date-weather">
            <div class="current-date">{{ currentDate }}</div>
            <div class="current-weather">
              <span class="weather-icon">☀️</span>
              <span class="weather-text">晴 15°C</span>
            </div>
          </div>
        </div>
        <div class="header-center">
          <div class="main-title-container">
            <div class="title-decoration-left"></div>
            <h1 class="main-title">宜川县域监测体系整合平台</h1>
            <div class="title-decoration-right"></div>
            <div class="title-glow-effect"></div>
          </div>
        </div>
        <div class="header-right">
          <div class="refresh-button-container">
            <button class="refresh-button" @click="refreshPage">
              <span class="refresh-icon">🔄</span>
              <span class="refresh-text">刷新</span>
            </button>
          </div>
        </div>
      </div>
      <div class="header-bottom-line"></div>
      <div class="header-corner-decoration tl"></div>
      <div class="header-corner-decoration tr"></div>
      <div class="header-corner-decoration bl"></div>
      <div class="header-corner-decoration br"></div>
    </div>
    
    <!-- 四个核心模块区域 -->
    <div class="modules-wrapper">
      <div class="modules-container" ref="modulesContainer">
        <!-- 视频墙模块 -->
        <div class="module video-wall-module">
          <h2>视频监控墙</h2>
          <div class="video-iframe-container">
            <iframe
              src="https://mapvideo.cnhqd.net:8100/#/screen?id=e875cc12c7d80e9fa6fd01f3d4a094d3"
              class="video-iframe"
              frameborder="0"
              allow="fullscreen"
            ></iframe>
          </div>
        </div>
        
        <!-- 视频会议模块 -->
        <div class="module video-conference-module">
          <h2>视频会议</h2>
          <div class="conference-content">
            <div class="main-video">
              <img :src="`${publicPath}images/hy.png`" alt="视频会议" class="conference-image">
            </div>
            <!-- 参会单位滚动展示区 -->
            <div class="participants-marquee-container">
              <div class="participants-marquee-content">
                <div class="participant-row" v-for="(row, rowIndex) in participantRows" :key="rowIndex">
                  <div class="participant-item" v-for="(participant, colIndex) in row" :key="colIndex">
                    <div class="participant-status" :class="participant.status"></div>
                    <span class="participant-name">{{ participant.name }}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- 气象与水利监测模块 -->
        <div class="module weather-hydrology-module">
          <div class="module-header">
            <h2>气象与水利监测</h2>
          </div>
          <div class="weather-hydrology-content">
            <!-- 左侧区域 - 气象监测 -->
            <div class="monitoring-section left-section">
              <div class="section-header">
                <h3>气象监测</h3>
                <button class="section-settings-btn" @click="showWeatherSettings">⚙️</button>
              </div>
              <div class="chart-container">
                <div class="chart-iframe-container">
                  <iframe 
                    src="" 
                    class="chart-iframe" 
                    frameborder="0"
                    sandbox="allow-same-origin allow-scripts allow-forms allow-popups allow-popups-to-escape-sandbox"
                    allow="fullscreen"
                  ></iframe>
                </div>
              </div>
            </div>
            
            <!-- 右侧区域 - 水利监测 -->
            <div class="monitoring-section right-section">
              <div class="section-header">
                <h3>水利监测</h3>
                <button class="section-settings-btn" @click="showHydrologySettings">⚙️</button>
              </div>
              <div class="chart-container">
                <div v-if="hydrologyChartUrl" class="chart-iframe-container">
                  <iframe 
                    :src="hydrologyChartUrl" 
                    class="chart-iframe" 
                    frameborder="0"
                    sandbox="allow-same-origin allow-scripts allow-forms allow-popups allow-popups-to-escape-sandbox"
                    allow="fullscreen"
                  ></iframe>
                </div>
                <div v-else class="chart-placeholder">水利图表展示区域</div>
              </div>
            </div>
          </div>
        </div>
        
        <!-- 土壤墒情监测模块 -->
        <div class="module soil-monitoring-module">
          <div class="module-header">
            <h2>土壤墒情监测</h2>
            <div class="header-controls">
              <div class="sensor-icon">
                <img :src="`${publicPath}images/cgq.png`" alt="传感器" class="sensor-image">
              </div>
              <div class="location-selector">
                <select v-model="selectedLocation" class="location-dropdown">
                  <option value="云岩镇阁楼社区白窑科村">云岩镇阁楼社区白窑科村</option>
                  <option value="壶口镇高柏新村">壶口镇高柏新村</option>
                  <option value="壶口镇高柏社区曹家庄">壶口镇高柏社区曹家庄</option>
                  <option value="壶口镇桥楼村">壶口镇桥楼村</option>
                  <option value="壶口镇高柏社区郭下村">壶口镇高柏社区郭下村</option>
                  <option value="云岩镇阁楼社区汾川村">云岩镇阁楼社区汾川村</option>
                </select>
              </div>
            </div>
          </div>
          <div class="location-display">
            <div class="current-location">当前监测点：{{ selectedLocation }}</div>
            <div class="sensor-id">传感器ID：{{ locationSensorMap[selectedLocation] }}</div>
          </div>
          <div class="monitoring-grid">
            <div class="metric-card">
              <div class="metric-label">氮</div>
              <div class="metric-value">{{ formatNumber(animatedValues.nitrogen || soilData.nitrogen?.value || '18.00') }}<span class="unit">{{ soilData.nitrogen?.unit || 'mg/kg' }}</span></div>
            </div>
            <div class="metric-card">
              <div class="metric-label">钾</div>
              <div class="metric-value">{{ formatNumber(animatedValues.potassium || soilData.potassium?.value || '27.00') }}<span class="unit">{{ soilData.potassium?.unit || 'mg/kg' }}</span></div>
            </div>
            <div class="metric-card">
              <div class="metric-label">磷</div>
              <div class="metric-value">{{ formatNumber(animatedValues.phosphorus || soilData.phosphorus?.value || '21.00') }}<span class="unit">{{ soilData.phosphorus?.unit || 'mg/kg' }}</span></div>
            </div>
            <div class="metric-card">
              <div class="metric-label">土壤pH</div>
              <div class="metric-value">{{ formatNumber(animatedValues.ph || soilData.ph?.value || '8.00') }}<span class="unit">{{ soilData.ph?.unit || '' }}</span></div>
            </div>
            <div class="metric-card">
              <div class="metric-label">土壤电导率</div>
              <div class="metric-value">{{ formatNumber(animatedValues.conductivity || soilData.conductivity?.value || '76.00') }}<span class="unit">{{ soilData.conductivity?.unit || 'μS/cm' }}</span></div>
            </div>
            <div class="metric-card">
              <div class="metric-label">土壤水分10cm</div>
              <div class="metric-value">{{ formatNumber(animatedValues.moisture || soilData.moisture?.value || '20.40') }}<span class="unit">{{ soilData.moisture?.unit || '%' }}</span></div>
            </div>
            <div class="metric-card">
              <div class="metric-label">土壤温度10cm</div>
              <div class="metric-value">{{ formatNumber(animatedValues.temperature || soilData.temperature?.value || '15.60') }}<span class="unit">{{ soilData.temperature?.unit || '°C' }}</span></div>
            </div>
            <!-- 传感器图片占位 -->
            <div class="sensor-placeholder">
              <img :src="`${publicPath}images/cgq.png`" alt="传感器" class="placeholder-sensor-image">
            </div>
          </div>
          <div class="monitoring-footer">
            <div class="timestamp">更新时间：{{ currentTime }}</div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- 图片弹窗 -->
    <div v-if="showImageModal" class="image-modal" @click="closeImageModal">
      <div class="modal-content" @click.stop>
        <span class="close-button" @click="closeImageModal">&times;</span>
        <img :src="modalImageSrc" alt="详情图片" class="modal-image">
        <div class="image-caption">{{ modalImageCaption }}</div>
      </div>
    </div>
    
    <!-- 气象设置弹窗 -->
    <div v-if="isWeatherSettingsVisible" class="settings-modal" @click="closeWeatherSettings">
      <div class="settings-modal-content" @click.stop>
        <span class="close-button" @click="closeWeatherSettings">&times;</span>
        <h3>设置气象监测URL</h3>
        <div class="input-group">
          <label for="weatherChartUrl">请输入有效的URL:</label>
          <input 
            type="url" 
            id="weatherChartUrl" 
            v-model="weatherInputUrl" 
            placeholder=""
            class="url-input"
          >
        </div>
        <div class="modal-actions">
          <button class="cancel-btn" @click="closeWeatherSettings">取消</button>
          <button class="confirm-btn" @click="confirmWeatherUrl">确认</button>
          <button v-if="showWeatherSaveButton" class="save-btn" @click="saveWeatherUrl">保存</button>
        </div>
      </div>
    </div>
    
    <!-- 水利设置弹窗 -->
    <div v-if="isHydrologySettingsVisible" class="settings-modal" @click="closeHydrologySettings">
      <div class="settings-modal-content" @click.stop>
        <span class="close-button" @click="closeHydrologySettings">&times;</span>
        <h3>设置水利监测URL</h3>
        <div class="input-group">
          <label for="hydrologyChartUrl">请输入有效的URL:</label>
          <input 
            type="url" 
            id="hydrologyChartUrl" 
            v-model="hydrologyInputUrl" 
            placeholder=""
            class="url-input"
          >
        </div>
        <div class="modal-actions">
          <button class="cancel-btn" @click="closeHydrologySettings">取消</button>
          <button class="confirm-btn" @click="confirmHydrologyUrl">确认</button>
          <button v-if="showHydrologySaveButton" class="save-btn" @click="saveHydrologyUrl">保存</button>
        </div>
      </div>
    </div>
    
    <!-- 设置弹窗 -->
    <div v-if="isSettingsModalVisible" class="settings-modal" @click="closeSettingsModal">
      <div class="settings-modal-content" @click.stop>
        <span class="close-button" @click="closeSettingsModal">&times;</span>
        <h3>设置气象云图URL</h3>
        <div class="input-group">
          <label for="chartUrl">请输入有效的URL:</label>
          <input 
            type="url" 
            id="chartUrl" 
            v-model="inputUrl" 
            placeholder="https://example.com/chart"
            class="url-input"
          >
        </div>
        <div class="modal-actions">
          <button class="cancel-btn" @click="closeSettingsModal">取消</button>
          <button class="confirm-btn" @click="confirmUrl">确认</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Dashboard',
  data() {
    return {
      // 公共路径前缀，用于处理子路径部署
      publicPath: process.env.BASE_URL,
      videoList: [
        { id: 1, name: '河道监控-01', location: '南关河段', image: 'river.png', caption: '南关河段实时监控画面' },
        { id: 2, name: '水库监控-01', location: '东风水库', image: 'shuiku.png', caption: '东风水库实时监控画面' },
        { id: 3, name: '果园监控-01', location: '堡定村果园', image: 'river.png', caption: '堡定村果园实时监控画面' },
        { id: 4, name: '城区监控-01', location: '中心广场', image: 'river.png', caption: '中心广场实时监控画面' }
      ],
      // 宜川县乡镇和单位列表
      allParticipants: [
        { id: 1, name: '城关镇', status: 'online' },
        { id: 2, name: '英旺乡', status: 'online' },
        { id: 3, name: '云岩镇', status: 'offline' },
        { id: 4, name: '交里乡', status: 'online' },
        { id: 5, name: '秋林镇', status: 'online' },
        { id: 6, name: '壶口镇', status: 'offline' },
        { id: 7, name: '甘草镇', status: 'online' },
        { id: 8, name: '阁楼镇', status: 'online' },
        { id: 9, name: '高柏乡', status: 'offline' },
        { id: 10, name: '牛家细乡', status: 'online' },
        { id: 11, name: '宜川县人民政府', status: 'online' },
        { id: 12, name: '应急管理局', status: 'online' },
        { id: 13, name: '水利局', status: 'offline' },
        { id: 14, name: '气象局', status: 'online' },
        { id: 15, name: '农业农村局', status: 'online' },
        { id: 16, name: '公安局', status: 'online' },
        { id: 17, name: '消防大队', status: 'offline' },
        { id: 18, name: '卫健局', status: 'online' },
        { id: 19, name: '交通局', status: 'online' },
        { id: 20, name: '住建局', status: 'offline' }
      ],
      weatherData: [
        { type: 'temperature', label: '当前温度', value: '15°C' },
        { type: 'humidity', label: '相对湿度', value: '68%' },
        { type: 'wind', label: '风力', value: '3级' },
        { type: 'rainfall', label: '今日降雨', value: '0mm' },
        { type: 'warning', label: '预警信息', value: '无' }
      ],
      // 土壤监测数据
      selectedLocation: '壶口镇桥楼村',
      locationSensorMap: {
        '云岩镇阁楼社区白窑科村': '35FFDA055248373439661451',
        '壶口镇高柏新村': '34FFD8055046393810750543',
        '壶口镇高柏社区曹家庄': '35FFD9054156333311831557',
        '壶口镇桥楼村': '35FFD7055248373441651551',
        '壶口镇高柏社区郭下村': '36FFD1054247373517810157',
        '云岩镇阁楼社区汾川村': '38FFD6055243323034690951'
      },
      baseSoilData: {
        nitrogen: { value: '18.00', unit: 'mg/kg' },
        potassium: { value: '27.00', unit: 'mg/kg' },
        phosphorus: { value: '21.00', unit: 'mg/kg' },
        ph: { value: '8.00', unit: '' },
        conductivity: { value: '76.00', unit: 'μS/cm' },
        moisture: { value: '20.40', unit: '%' },
        temperature: { value: '15.60', unit: '°C' }
      },
      soilData: {},
      // 定时器相关
      dataUpdateTimer: null,
      // 动画相关
      animatedValues: {},
      videoMap: null,
      showImageModal: false,
      modalImageSrc: '',
      modalImageCaption: '',
      currentDate: '',
      currentTime: '',
      isSettingsModalVisible: false,
      inputUrl: '',
      weatherChartUrl: '',
      hydrologyChartUrl: 'https://www.wisdomdance.cn/ycsl/', // 水利监测图表 URL
      isWeatherSettingsVisible: false, // 气象设置弹窗
      isHydrologySettingsVisible: false, // 水利设置弹窗
      weatherInputUrl: '', // 气象URL输入
      hydrologyInputUrl: '', // 水利URL输入
      // 本地存储的键名
      STORAGE_KEYS: {
        WEATHER_URL: 'weatherChartUrl',
        HYDROLOGY_URL: 'hydrologyChartUrl'
      },
      // 用于跟踪用户是否修改了输入内容
      originalWeatherInput: '',
      originalHydrologyInput: ''
    }
  },
  computed: {
    // 将参与者列表转换为3行2列的格式
    participantRows() {
      const rows = [];
      // 每行显示6个参与者（2列×3行）
      for (let i = 0; i < this.allParticipants.length; i += 6) {
        const row = [];
        // 每行2列，每列3个参与者
        for (let j = 0; j < 6 && i + j < this.allParticipants.length; j++) {
          row.push(this.allParticipants[i + j]);
        }
        rows.push(row);
      }
      return rows;
    },
    
    // 判断是否显示气象保存按钮
    showWeatherSaveButton() {
      return this.weatherInputUrl !== this.originalWeatherInput && this.weatherInputUrl.trim() !== '';
    },
    
    // 判断是否显示水利保存按钮
    showHydrologySaveButton() {
      return this.hydrologyInputUrl !== this.originalHydrologyInput && this.hydrologyInputUrl.trim() !== '';
    }
  },
  watch: {
    selectedLocation: {
      handler(newVal, oldVal) {
        if (oldVal) { // 避免初始化时触发
          this.triggerLocationChangeEffect();
        }
        this.updateSoilData();
      },
      immediate: true // 组件初始化时也执行一次
    }
  },
  mounted() {
    // 从本地存储加载保存的地址，如果没有则使用默认地址
    this.weatherChartUrl = this.getFromLocalStorage(this.STORAGE_KEYS.WEATHER_URL, '') || '';
    this.hydrologyChartUrl = this.getFromLocalStorage(this.STORAGE_KEYS.HYDROLOGY_URL, 'https://www.wisdomdance.cn/ycsl/') || 'https://www.wisdomdance.cn/ycsl/';
    
    // 初始化模块容器的宽度，确保可以横向滚动
    this.initModulesWidth();
    // 初始化地图
    this.initMaps();
    // 初始化时间显示
    this.updateDateTime();
    this.dateTimeInterval = setInterval(() => {
      this.updateDateTime();
    }, 1000);
    // 启动数据自动更新定时器
    this.startDataAutoUpdate();
  },
  methods: {
    // 显示视频缩略图对应图片
    showVideoImage(video) {
      this.showImageModalFunc(video.image, video.caption);
    },
    
    initModulesWidth() {
      // 根据生产环境分辨率6720px重新计算
      // 总宽度：6720px
      // 模块间距：30px × 3 = 90px
      // 可用模块宽度：6720 - 90 = 6630px
      // 第4模块宽度：1096px (原1661px的66%)
      // 前3个模块平分剩余空间：(6630 - 1096) / 3 = 1845px
      this.$refs.modulesContainer.style.width = '6720px';
    },
    
    initMaps() {
      // 初始化视频监控地图
      this.initVideoMap();
    },
    
    initVideoMap() {
      // 创建视频监控地图实例，中心点设置在延安市宜川县城区
      this.videoMap = new AMap.Map('video-map-container', {
        zoom: 12,
        center: [110.1764, 36.0485], // 宜川县人民政府位置
        mapStyle: 'amap://styles/normal', // 使用标准主题作为基础
        features: ['bg', 'point', 'road', 'building']
      });
      
      // 应用自定义配色方案
      this.applyCustomMapStyles();
      
      // 添加县域轮廓边界
      this.addCountyBoundary(this.videoMap);
      
      // 添加视频监控点标记
      const videoMarkers = [
        {
          position: [110.1653, 36.0514],
          title: '河道监控-01 (南关河段)',
          type: 'river',
          image: 'river.png',
          caption: '南关河段实时监控画面'
        },
        {
          position: [110.1821, 36.0123],
          title: '水库监控-01 (东风水库)',
          type: 'reservoir',
          image: 'shuiku.png',
          caption: '东风水库实时监控画面'
        },
        {
          position: [110.1234, 35.9876],
          title: '果园监控-01 (堡定村果园)',
          type: 'orchard',
          image: 'river.png',
          caption: '堡定村果园实时监控画面'
        },
        {
          position: [110.1756, 36.0445],
          title: '城区监控-01 (中心广场)',
          type: 'urban',
          image: 'river.png',
          caption: '中心广场实时监控画面'
        }
      ];
      
      videoMarkers.forEach((marker, index) => {
        this.createCustomMarker(marker, index);
      });
      
      // 添加点位添加功能
      this.enablePointAddition();
      
      // 添加缩放级别监听（修复缩放错误）
      if (this.videoMap) {
        this.videoMap.on('zoomchange', () => {
          try {
            // 添加额外的安全检查
            if (this.videoMap && typeof this.videoMap.getZoom === 'function') {
              this.handleZoomChange();
            }
          } catch (error) {
            console.error('缩放处理错误:', error);
            // 防止错误冒泡到全局
            if (typeof event !== 'undefined' && event?.preventDefault) {
              event.preventDefault();
            }
          }
        });
                  
        // 添加额外的地图事件监听器错误处理
        this.videoMap.on('error', (error) => {
          console.error('地图错误:', error);
        });
      } else {
        console.warn('地图实例未正确初始化，跳过缩放监听器绑定');
      }
      
      // 添加地图移动监听
      this.videoMap.on('moveend', () => {
        console.log('地图移动结束');
      });
      

    },
    
    // 应用自定义地图配色方案
    applyCustomMapStyles() {
      const mapContainer = document.getElementById('video-map-container');
      if (mapContainer) {
        const style = document.createElement('style');
        style.textContent = `
          #video-map-container {
            background: rgb(245, 240, 230) !important; /* 淡米色陆地背景 */
          }
          
          /* 道路样式 */
          .amap-road {
            stroke: rgb(80, 80, 80) !important; /* 主要道路深灰色 */
            stroke-width: 2px !important;
          }
          
          .amap-road-secondary {
            stroke: rgb(120, 120, 120) !important; /* 次要道路浅灰色 */
            stroke-width: 1px !important;
          }
          
          /* 水域样式 */
          .amap-water {
            fill: rgb(173, 216, 230) !important; /* 浅蓝色海洋 */
            stroke: rgb(135, 206, 235) !important;
            stroke-width: 1px !important;
          }
          
          /* 城市区域 */
          .amap-city {
            fill: rgb(255, 250, 205) !important; /* 浅黄色城市区域 */
            stroke: rgb(255, 228, 181) !important;
            stroke-width: 1px !important;
          }
          
          /* 宜川县人民政府特殊标记 */
          .government-marker {
            filter: drop-shadow(0 0 8px gold) !important;
          }
          
          /* 地图文字标签 */
          .amap-lnglat-label {
            color: rgb(50, 50, 50) !important;
            font-weight: bold !important;
            text-shadow: 1px 1px 1px white, -1px -1px 1px white !important;
            background: rgba(255, 255, 255, 0.8) !important;
            padding: 2px 6px !important;
            border-radius: 3px !important;
            font-family: Arial, sans-serif !important;
          }
        `;
        document.head.appendChild(style);
      }
    },
    
    // 处理缩放级别变化（增强错误处理）
    handleZoomChange() {
      try {
        // 更严格的安全检查
        if (!this.videoMap) {
          console.warn('地图实例不存在，无法处理缩放');
          return;
        }
        
        // 检查地图对象是否有效
        if (typeof this.videoMap.getZoom !== 'function') {
          console.warn('地图对象缺少getZoom方法');
          return;
        }
        
        const zoomLevel = this.videoMap.getZoom();
        console.log('当前缩放级别:', zoomLevel);
        
        // 验证缩放级别有效性
        if (typeof zoomLevel !== 'number' || zoomLevel < 1 || zoomLevel > 20) {
          console.warn('无效的缩放级别:', zoomLevel);
          return;
        }
        
        // 根据缩放级别调整显示内容
        if (zoomLevel < 10) {
          // 低缩放级别 - 宏观视角
          this.showMacroView();
        } else if (zoomLevel >= 10 && zoomLevel < 15) {
          // 中等缩放级别
          this.showMediumView();
        } else {
          // 高缩放级别 - 微观视角
          this.showMicroView();
        }
      } catch (error) {
        console.error('缩放级别处理出错:', error);
        // 不抛出错误，防止影响其他功能
      }
    },
    
    // 宏观视角显示
    showMacroView() {
      try {
        // 显示主要城市、主要道路、大型地理特征
        console.log('切换到宏观视角');
        // 这里可以添加具体的显示逻辑
      } catch (error) {
        console.error('宏观视角处理出错:', error);
      }
    },
    
    // 中等视角显示
    showMediumView() {
      try {
        // 显示更多细节信息
        console.log('切换到中等视角');
        // 这里可以添加具体的显示逻辑
      } catch (error) {
        console.error('中等视角处理出错:', error);
      }
    },
    
    // 微观视角显示
    showMicroView() {
      try {
        // 显示详细街道、建筑等信息
        console.log('切换到微观视角');
        // 这里可以添加具体的显示逻辑
      } catch (error) {
        console.error('微观视角处理出错:', error);
      }
    },
    
    // 启用点位添加功能
    enablePointAddition() {
      // 点位类型配置
      this.pointTypes = {
        restaurant: { name: '餐厅', color: 'rgb(255, 165, 0)', icon: '🍴' },
        hotel: { name: '酒店', color: 'rgb(0, 0, 128)', icon: '🏨' },
        attraction: { name: '景点', color: 'rgb(0, 128, 0)', icon: '📷' },
        bus: { name: '公交站', color: 'rgb(255, 0, 0)', icon: '🚌' },
        hospital: { name: '医院', color: 'rgb(128, 0, 128)', icon: '🏥' },
        school: { name: '学校', color: 'rgb(0, 191, 255)', icon: '📚' }
      };
      
      // 监听地图点击事件
      this.videoMap.on('click', (e) => {
        this.showPointAdditionDialog(e.lnglat);
      });
    },
    
    // 显示点位添加对话框
    showPointAdditionDialog(position) {
      // 创建输入框和选择器
      const dialog = document.createElement('div');
      dialog.className = 'point-addition-dialog';
      dialog.innerHTML = `
        <div style="background: white; padding: 15px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.3); min-width: 250px;">
          <h3 style="margin: 0 0 15px 0; color: #333;">添加新点位</h3>
          <div style="margin-bottom: 15px;">
            <label style="display: block; margin-bottom: 5px; font-weight: bold;">点位类型：</label>
            <select id="pointType" style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px;">
              <option value="restaurant">餐厅 🍴</option>
              <option value="hotel">酒店 🏨</option>
              <option value="attraction">景点 📷</option>
              <option value="bus">公交站 🚌</option>
              <option value="hospital">医院 🏥</option>
              <option value="school">学校 📚</option>
            </select>
          </div>
          <div style="margin-bottom: 15px;">
            <label style="display: block; margin-bottom: 5px; font-weight: bold;">点位名称：</label>
            <input type="text" id="pointName" placeholder="请输入点位名称" 
                   style="width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; color: #333;">
          </div>
          <div style="display: flex; gap: 10px;">
            <button id="confirmBtn" style="flex: 1; padding: 10px; background: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer;">确定</button>
            <button id="cancelBtn" style="flex: 1; padding: 10px; background: #f44336; color: white; border: none; border-radius: 4px; cursor: pointer;">取消</button>
          </div>
        </div>
      `;
      
      // 添加到地图容器
      const mapContainer = document.getElementById('video-map-container');
      mapContainer.appendChild(dialog);
      
      // 定位对话框
      const pixel = this.videoMap.lngLatToContainer(position);
      dialog.style.position = 'absolute';
      dialog.style.left = (pixel.getX() - 125) + 'px';
      dialog.style.top = (pixel.getY() - 150) + 'px';
      dialog.style.zIndex = '1000';
      
      // 绑定事件
      dialog.querySelector('#confirmBtn').onclick = () => {
        const type = dialog.querySelector('#pointType').value;
        const name = dialog.querySelector('#pointName').value || '未命名点位';
        this.createCustomPoint(position, type, name);
        mapContainer.removeChild(dialog);
      };
      
      dialog.querySelector('#cancelBtn').onclick = () => {
        mapContainer.removeChild(dialog);
      };
    },
    
    // 创建自定义点位
    createCustomPoint(position, type, name) {
      const pointConfig = this.pointTypes[type];
      if (!pointConfig) return;
      
      // 创建SVG图标
      const iconSvg = this.createPointIcon(pointConfig.color, pointConfig.icon);
      
      const marker = new AMap.Marker({
        position: position,
        title: name,
        icon: new AMap.Icon({
          size: new AMap.Size(32, 32),
          image: iconSvg,
          imageSize: new AMap.Size(32, 32)
        }),
        offset: new AMap.Pixel(-16, -32),
        label: {
          content: `<div style="
            background: ${pointConfig.color};
            color: #1976D2;  /* 改为蓝色 */
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
            white-space: nowrap;
            box-shadow: 0 2px 6px rgba(0,0,0,0.3);
            text-shadow: 1px 1px 1px rgba(255,255,255,0.5);  /* 添加文字阴影提高可读性 */
          ">${name}</div>`,
          offset: new AMap.Pixel(0, 0),
          direction: 'bottom'
        }
      });
      
      this.videoMap.add(marker);
      
      // 添加点击事件
      marker.on('click', () => {
        alert(`点位信息：\n名称：${name}\n类型：${pointConfig.name}`);
      });
    },
    
    // 创建点位图标
    createPointIcon(color, symbol) {
      return `data:image/svg+xml;base64,${btoa(`
        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 32 32">
          <circle cx="16" cy="16" r="14" fill="${color}" stroke="white" stroke-width="2"/>
          <text x="16" y="21" text-anchor="middle" font-family="Arial" font-size="16" fill="white">${symbol}</text>
        </svg>
      `)}`;
    },
    
    // 原有的地图样式方法（保持兼容性）
    customizeMapStyle() {
      // 保持向后兼容
      this.applyCustomMapStyles();
    },
    
    // 创建自定义标记点
    createCustomMarker(markerData, index) {
      // 根据不同类型创建不同的SVG图标
      const iconSvg = this.getMarkerIcon(markerData.type);
      
      const marker = new AMap.Marker({
        position: markerData.position,
        title: markerData.title,
        icon: new AMap.Icon({
          size: new AMap.Size(32, 32),
          image: iconSvg,
          imageSize: new AMap.Size(32, 32)
        }),
        offset: new AMap.Pixel(-16, -32),
        animation: 'AMAP_ANIMATION_DROP', // 添加掉落动画
        label: {
          content: `<div style="
            background: rgba(255, 255, 255, 0.9);
            color: #1976D2;
            padding: 6px 10px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: bold;
            white-space: nowrap;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
            border: 2px solid ${this.getMarkerTypeColor(markerData.type)};
            text-shadow: 1px 1px 1px rgba(255,255,255,0.8);
          ">${markerData.title}</div>`,
          offset: new AMap.Pixel(0, 0),
          direction: 'bottom'
        }
      });
      
      // 添加鼠标悬停效果
      marker.on('mouseover', () => {
        marker.setAnimation('AMAP_ANIMATION_BOUNCE');
        this.showMarkerInfo(markerData);
      });
      
      marker.on('mouseout', () => {
        marker.setAnimation('AMAP_ANIMATION_NONE');
        this.hideMarkerInfo();
      });
      
      // 添加点击事件
      marker.on('click', () => {
        this.showImageModalFunc(markerData.image, markerData.caption);
      });
      
      this.videoMap.add(marker);
    },
    
    // 获取标记点类型对应的颜色
    getMarkerTypeColor(type) {
      const colorMap = {
        'river': '#4CAF50',      // 河道 - 绿色
        'reservoir': '#2196F3',  // 水库 - 蓝色
        'orchard': '#FF9800',    // 果园 - 橙色
        'urban': '#9C27B0'       // 城区 - 紫色
      };
      return colorMap[type] || '#607D8B'; // 默认灰色
    },
    
    // 获取标记点SVG图标
    getMarkerIcon(type) {
      const colors = {
        river: '#4CAF50',      // 绿色 - 河流监控
        reservoir: '#2196F3',  // 蓝色 - 水库监控
        orchard: '#FF9800',    // 橙色 - 果园监控
        urban: '#9C27B0'       // 紫色 - 城区监控
      };
      
      const color = colors[type] || '#607D8B';
      
      // 创建简化版SVG图标，避免复杂滤镜导致的问题
      return `data:image/svg+xml;base64,${btoa(`
        <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 32 32">
          <circle cx="16" cy="16" r="14" fill="${color}" stroke="white" stroke-width="2"/>
          <circle cx="16" cy="16" r="10" fill="white"/>
          <text x="16" y="20" text-anchor="middle" font-family="Arial, sans-serif" font-size="14" font-weight="bold" fill="${color}">${type.charAt(0).toUpperCase()}</text>
        </svg>
      `)}`;
    },
    
    // 显示标记点信息
    showMarkerInfo(markerData) {
      // 这里可以添加信息窗口的显示逻辑
      console.log('显示标记信息:', markerData.title);
    },
    
    // 隐藏标记点信息
    hideMarkerInfo() {
      // 这里可以添加信息窗口的隐藏逻辑
    },
    
    // 触发地点切换动效
    triggerLocationChangeEffect() {
      // 给所有卡片添加切换类
      this.$nextTick(() => {
        const cards = document.querySelectorAll('.metric-card');
        cards.forEach(card => {
          card.classList.add('location-changing');
        });
        
        // 500ms后移除动效类
        setTimeout(() => {
          cards.forEach(card => {
            card.classList.remove('location-changing');
          });
        }, 500);
      });
    },
    
    // 数字格式化方法
    formatNumber(value) {
      if (value === undefined || value === null) {
        return '0.00';
      }
      
      // 如果是字符串，先转换为数字
      const num = typeof value === 'string' ? parseFloat(value) : value;
      
      // 确保是有效数字
      if (isNaN(num)) {
        return '0.00';
      }
      
      return num.toFixed(2);
    },
    
    // 启动定时数据更新
    startDataAutoUpdate() {
      this.dataUpdateTimer = setInterval(() => {
        this.updateSoilDataWithAnimation();
      }, 10000); // 10秒更新一次
    },
    
    // 带动画的数据更新
    updateSoilDataWithAnimation() {
      const variation = 0.02; // 2%的变化范围
      
      for (const [key, value] of Object.entries(this.soilData)) {
        const currentValue = parseFloat(value.value);
        // 生成-2%到+2%之间的随机变化
        const changeFactor = 1 + (Math.random() * variation * 2 - variation);
        const newValue = (currentValue * changeFactor);
        
        // 启动动画效果
        this.animateValueChange(key, currentValue, newValue);
      }
    },
    
    // 数值变化动画
    animateValueChange(key, fromValue, toValue) {
      const duration = 1000; // 1秒动画时间
      const startTime = Date.now();
      const difference = toValue - fromValue;
      
      // 初始化动画值
      if (!this.animatedValues[key]) {
        this.animatedValues[key] = fromValue;
      }
      
      const animate = () => {
        const elapsed = Date.now() - startTime;
        const progress = Math.min(elapsed / duration, 1);
        
        // 使用缓动函数使动画更自然
        const easeProgress = 1 - Math.pow(1 - progress, 3);
        this.animatedValues[key] = fromValue + (difference * easeProgress);
        
        if (progress < 1) {
          requestAnimationFrame(animate);
        } else {
          // 动画结束，更新实际数据
          this.soilData[key].value = toValue.toFixed(2);
          this.animatedValues[key] = parseFloat(this.soilData[key].value);
        }
      };
      
      animate();
    },
    
    // 位置切换时更新数据
    updateSoilData() {
      // 为每个镇生成略微不同的数据（±2%浮动）
      const variation = 0.02; // 2%的变化范围
      
      this.soilData = {};
      for (const [key, value] of Object.entries(this.baseSoilData)) {
        const baseValue = parseFloat(value.value);
        // 生成-2%到+2%之间的随机变化
        const changeFactor = 1 + (Math.random() * variation * 2 - variation);
        const newValue = (baseValue * changeFactor).toFixed(2);
        
        this.soilData[key] = {
          value: newValue,
          unit: value.unit
        };
      }
    },
    
    // 添加县域轮廓边界
    addCountyBoundary(map) {
      // 宜川县县域轮廓坐标点（简化示例）
      const countyPath = [
        [110.05, 35.95],
        [110.08, 36.12],
        [110.25, 36.15],
        [110.30, 36.05],
        [110.28, 35.92],
        [110.15, 35.90],
        [110.05, 35.95]
      ];
      
      // 创建县域轮廓多边形
      const countyPolygon = new AMap.Polygon({
        path: countyPath,
        strokeColor: "#FFA500", // 橙色轮廓线
        strokeWeight: 3,
        fillColor: "transparent",
        zIndex: 10
      });
      
      map.add(countyPolygon);
      
      // 添加主要河流（示例）
      const riverPath = [
        [110.10, 36.05],
        [110.15, 36.03],
        [110.20, 36.02],
        [110.25, 36.00]
      ];
      
      const riverPolyline = new AMap.Polyline({
        path: riverPath,
        strokeColor: "#00BFFF", // 蓝色河流
        strokeWeight: 4,
        zIndex: 20
      });
      
      map.add(riverPolyline);
      
      // 添加水库标记（示例）
      const reservoirMarker = new AMap.Marker({
        position: [110.18, 36.01],
        title: "东风水库",
        label: {
          content: "东风水库",
          offset: new AMap.Pixel(-15, 15)
        }
      });
      
      map.add(reservoirMarker);
      
      // 添加乡镇名称标记（示例）
      const townNames = [
        { position: [110.12, 36.08], name: "城关镇" },
        { position: [110.20, 36.10], name: "英旺乡" },
        { position: [110.15, 35.95], name: "云岩镇" }
      ];
      
      townNames.forEach(town => {
        const townLabel = new AMap.Text({
          text: town.name,
          position: town.position,
          style: {
            'padding': '.25rem .5rem',
            'background-color': 'rgba(255, 165, 0, 0.8)',
            'color': '#fff',
            'font-size': '12px',
            'border-radius': '4px'
          }
        });
        
        map.add(townLabel);
      });
    },
    
    // 显示图像弹窗
    showImageModalFunc(imageSrc, caption) {
      // 拼接公共路径前缀 - 确保路径格式正确
      this.modalImageSrc = this.publicPath + 'images/' + imageSrc;
      this.modalImageCaption = caption;
      this.showImageModal = true;
    },
    
    // 关闭图像弹窗
    closeImageModal() {
      this.showImageModal = false;
      this.modalImageSrc = '';
      this.modalImageCaption = '';
    },
    
    // 更新日期时间显示
    updateDateTime() {
      const now = new Date();
      this.currentDate = now.toLocaleDateString('zh-CN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        weekday: 'narrow'
      });
      this.currentTime = now.toLocaleTimeString('zh-CN', {
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
      });
    },
    
    // 本地存储相关方法
    saveToLocalStorage(key, value) {
      try {
        localStorage.setItem(key, value);
      } catch (e) {
        console.error('保存到本地存储失败:', e);
      }
    },
    
    getFromLocalStorage(key, defaultValue) {
      try {
        return localStorage.getItem(key) || defaultValue;
      } catch (e) {
        console.error('从本地存储读取失败:', e);
        return defaultValue;
      }
    },
    
    // 显示气象设置弹窗
    showWeatherSettings() {
      this.isWeatherSettingsVisible = true;
      this.weatherInputUrl = this.weatherChartUrl || '';
      this.originalWeatherInput = this.weatherChartUrl || ''; // 记录原始值
    },
    
    // 显示水利设置弹窗
    showHydrologySettings() {
      this.isHydrologySettingsVisible = true;
      this.hydrologyInputUrl = this.hydrologyChartUrl || '';
      this.originalHydrologyInput = this.hydrologyChartUrl || ''; // 记录原始值
    },
    
    // 关闭气象设置弹窗
    closeWeatherSettings() {
      this.isWeatherSettingsVisible = false;
      this.weatherInputUrl = '';
    },
    
    // 关闭水利设置弹窗
    closeHydrologySettings() {
      this.isHydrologySettingsVisible = false;
      this.hydrologyInputUrl = '';
    },
    
    // 确认气象URL设置
    confirmWeatherUrl() {
      if (this.weatherInputUrl && this.isValidUrl(this.weatherInputUrl)) {
        this.weatherChartUrl = this.weatherInputUrl;
        this.closeWeatherSettings();
      } else {
        alert('请输入有效的URL地址');
      }
    },
    
    // 保存气象URL设置
    saveWeatherUrl() {
      if (this.weatherInputUrl && this.isValidUrl(this.weatherInputUrl)) {
        this.weatherChartUrl = this.weatherInputUrl;
        this.saveToLocalStorage(this.STORAGE_KEYS.WEATHER_URL, this.weatherInputUrl);
        this.closeWeatherSettings();
        alert('气象监测地址已保存！');
      } else {
        alert('请输入有效的URL地址');
      }
    },
    
    // 确认水利URL设置
    confirmHydrologyUrl() {
      if (this.hydrologyInputUrl && this.isValidUrl(this.hydrologyInputUrl)) {
        this.hydrologyChartUrl = this.hydrologyInputUrl;
        this.closeHydrologySettings();
      } else {
        alert('请输入有效的URL地址');
      }
    },
    
    // 保存水利URL设置
    saveHydrologyUrl() {
      if (this.hydrologyInputUrl && this.isValidUrl(this.hydrologyInputUrl)) {
        this.hydrologyChartUrl = this.hydrologyInputUrl;
        this.saveToLocalStorage(this.STORAGE_KEYS.HYDROLOGY_URL, this.hydrologyInputUrl);
        this.closeHydrologySettings();
        alert('水利监测地址已保存！');
      } else {
        alert('请输入有效的URL地址');
      }
    },
    
    // 显示设置弹窗（保留原有的）
    showSettingsModal() {
      this.isSettingsModalVisible = true;
      this.inputUrl = this.weatherChartUrl || '';
    },
    
    // 关闭设置弹窗
    closeSettingsModal() {
      this.isSettingsModalVisible = false;
      this.inputUrl = '';
    },
    
    // 确认URL设置
    confirmUrl() {
      if (this.inputUrl && this.isValidUrl(this.inputUrl)) {
        this.weatherChartUrl = this.inputUrl;
        this.closeSettingsModal();
      } else {
        alert('请输入有效的URL地址');
      }
    },
    
    // 验证URL有效性
    isValidUrl(string) {
      try {
        new URL(string);
        return true;
      } catch (_) {
        return false;
      }
    },
    
    // 刷新页面方法
    refreshPage() {
      // 显示刷新提示
      console.log('正在刷新页面...');
      // 重新加载当前页面
      window.location.reload();
    }
  },
  
  beforeUnmount() {
    // 清理定时器
    if (this.dateTimeInterval) {
      clearInterval(this.dateTimeInterval);
    }
    if (this.dataUpdateTimer) {
      clearInterval(this.dataUpdateTimer);
    }
    // 组件销毁前清理地图实例
    if (this.videoMap) {
      this.videoMap.destroy();
    }
  }
}
</script>

<style scoped>
/* ===== Dashboard Container ===== */
.dashboard-container {
  height: 100vh;
  display: flex;
  flex-direction: column;
  /* Layered gradient background for depth */
  background:
    radial-gradient(ellipse at 20% 20%, rgba(100, 181, 246, 0.08) 0%, transparent 50%),
    radial-gradient(ellipse at 80% 80%, rgba(100, 181, 246, 0.05) 0%, transparent 50%),
    radial-gradient(ellipse at 50% 50%, rgba(30, 60, 100, 0.3) 0%, transparent 70%),
    linear-gradient(135deg, #0a192f 0%, #0d2137 50%, #102a43 100%);
  padding: 12px;
  overflow: hidden;
  position: relative;
}

/* ===== Header ===== */
.header {
  background: linear-gradient(135deg, rgba(10, 25, 47, 0.95) 0%, rgba(12, 45, 72, 0.95) 100%);
  border-radius: var(--radius-md);
  margin-bottom: 12px;
  min-height: 160px;
  position: relative;
  overflow: hidden;
  box-shadow:
    0 4px 24px rgba(0, 0, 0, 0.4),
    0 0 40px rgba(100, 181, 246, 0.15),
    inset 0 1px 0 rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(100, 181, 246, 0.25);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  padding: 0;
}

/* Simplified corner decorations */
.header-corner-decoration {
  position: absolute;
  width: 24px;
  height: 24px;
  border: 2px solid rgba(100, 181, 246, 0.5);
  pointer-events: none;
}

.header-corner-decoration.tl {
  top: 8px;
  left: 8px;
  border-right: none;
  border-bottom: none;
  border-top-left-radius: var(--radius-sm);
}

.header-corner-decoration.tr {
  top: 8px;
  right: 8px;
  border-left: none;
  border-bottom: none;
  border-top-right-radius: var(--radius-sm);
}

.header-corner-decoration.bl {
  bottom: 8px;
  left: 8px;
  border-right: none;
  border-top: none;
  border-bottom-left-radius: var(--radius-sm);
}

.header-corner-decoration.br {
  bottom: 8px;
  right: 8px;
  border-left: none;
  border-top: none;
  border-bottom-right-radius: var(--radius-sm);
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--space-xl);
  height: 160px;
  position: relative;
  z-index: 2;
}

.header-left {
  display: flex;
  align-items: center;
  flex: 1;
}

.date-weather {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: var(--space-xs);
}

.current-date {
  font-size: 15px;
  color: var(--text-secondary);
  font-weight: 500;
  letter-spacing: 0.5px;
}

.current-weather {
  display: flex;
  align-items: center;
  gap: var(--space-xs);
  font-size: 14px;
  color: var(--primary-light);
  font-weight: 500;
}

.weather-icon {
  font-size: 18px;
}

.weather-text {
  color: var(--primary);
}

.header-center {
  display: flex;
  justify-content: center;
  align-items: center;
  flex: 1;
}

.main-title-container {
  padding: var(--space-xl) var(--space-xl);
  background: transparent;
  position: relative;
  overflow: visible;
}

.main-title {
  font-size: 48px;
  margin: 0;
  font-weight: 900;
  letter-spacing: 4px;
  font-family: 'Microsoft YaHei', 'SimHei', Arial, sans-serif;
  text-align: center;
  line-height: 1.2;

  /* Enhanced gold gradient */
  background: linear-gradient(
    180deg,
    #fffbe6 0%,
    #ffd700 10%,
    #ffec8b 25%,
    #daa520 40%,
    #ffd700 55%,
    #b8860b 70%,
    #ffd700 85%,
    #fffbe6 100%
  );
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  background-size: 100% 200%;

  /* Glow effect */
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.6))
          drop-shadow(0 0 30px rgba(255, 215, 0, 0.4));
  animation: goldShine 4s ease-in-out infinite;
}

@keyframes goldShine {
  0%, 100% { background-position: 0% 0%; }
  50% { background-position: 0% 100%; }
}

.main-title-container::after {
  content: '';
  position: absolute;
  bottom: 8px;
  left: 50%;
  transform: translateX(-50%);
  width: 70%;
  height: 2px;
  background: linear-gradient(
    90deg,
    transparent 0%,
    rgba(255, 215, 0, 0.2) 20%,
    rgba(255, 215, 0, 0.7) 50%,
    rgba(255, 215, 0, 0.2) 80%,
    transparent 100%
  );
  border-radius: 2px;
}

.title-decoration-left,
.title-decoration-right,
.title-glow-effect {
  display: none;
}

.header-right {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  flex: 1;
}

/* ===== Refresh Button ===== */
.refresh-button-container {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  height: 100%;
}

.refresh-button {
  display: flex;
  align-items: center;
  gap: var(--space-sm);
  padding: 10px 18px;
  background: linear-gradient(135deg, rgba(100, 181, 246, 0.15) 0%, rgba(68, 138, 255, 0.25) 100%);
  border: 1px solid rgba(100, 181, 246, 0.35);
  border-radius: var(--radius-full);
  color: var(--text-secondary);
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: transform var(--transition-fast), box-shadow var(--transition-fast), border-color var(--transition-fast);
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
}

.refresh-button:hover {
  background: linear-gradient(135deg, rgba(100, 181, 246, 0.25) 0%, rgba(68, 138, 255, 0.35) 100%);
  transform: translateY(-2px);
  box-shadow: 0 4px 20px rgba(100, 181, 246, 0.3);
  border-color: rgba(100, 181, 246, 0.5);
}

.refresh-button:active {
  transform: translateY(0) scale(0.98);
}

.refresh-button:focus-visible {
  outline: 2px solid var(--primary);
  outline-offset: 3px;
}

.refresh-icon {
  font-size: 16px;
}

.refresh-button:hover .refresh-icon {
  animation: spin 0.6s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.refresh-text {
  font-weight: 500;
}

/* ===== Status Indicator ===== */
.status-indicator {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  background-color: #4caf50;
  box-shadow: 0 0 12px rgba(76, 175, 80, 0.8);
  position: relative;
  animation: pulse 2s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% { transform: scale(1); opacity: 1; }
  50% { transform: scale(1.15); opacity: 0.8; }
}

.status-indicator.online::after {
  content: '';
  position: absolute;
  inset: -3px;
  border-radius: 50%;
  border: 1px solid rgba(76, 175, 80, 0.4);
  animation: ripple 2s ease-out infinite;
}

@keyframes ripple {
  0% { transform: scale(1); opacity: 1; }
  100% { transform: scale(2); opacity: 0; }
}

/* ===== Header Bottom Line ===== */
.header-bottom-line {
  height: 3px;
  background: linear-gradient(90deg,
    transparent 0%,
    var(--primary) 20%,
    #448aff 50%,
    var(--primary) 80%,
    transparent 100%);
  width: 100%;
  position: absolute;
  bottom: 0;
  box-shadow: 0 0 20px rgba(100, 181, 246, 0.6);
  animation: lineGlow 3s ease-in-out infinite alternate;
}

@keyframes lineGlow {
  0% { opacity: 0.7; box-shadow: 0 0 15px rgba(100, 181, 246, 0.4); }
  100% { opacity: 1; box-shadow: 0 0 25px rgba(100, 181, 246, 0.8); }
}

/* ===== Modules Wrapper ===== */
.modules-wrapper {
  flex: 1;
  overflow-x: auto;
  overflow-y: hidden;
  padding: var(--space-xs) 0;
}

.modules-container {
  display: flex;
  gap: var(--space-lg);
  height: calc(100vh - 180px);
  position: relative;
}

/* ===== Module Card ===== */
.module {
  width: 1845px;
  height: 100%;
  background: rgba(17, 34, 64, 0.75);
  border-radius: var(--radius-md);
  padding: var(--space-md);
  display: flex;
  flex-direction: column;
  box-shadow:
    0 4px 20px rgba(0, 0, 0, 0.35),
    0 0 40px rgba(100, 181, 246, 0.08),
    inset 0 1px 0 rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(100, 181, 246, 0.2);
  flex-shrink: 0;
  position: relative;
  overflow: hidden;
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  transition: border-color var(--transition-normal);
}

/* Elegant border glow animation */
.module::before {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: inherit;
  padding: 1px;
  background: linear-gradient(
    135deg,
    transparent 0%,
    rgba(100, 181, 246, 0.3) 25%,
    rgba(100, 181, 246, 0.6) 50%,
    rgba(100, 181, 246, 0.3) 75%,
    transparent 100%
  );
  background-size: 300% 300%;
  -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  -webkit-mask-composite: xor;
  mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  mask-composite: exclude;
  animation: borderGlow 6s ease-in-out infinite;
  pointer-events: none;
  opacity: 0.7;
}

@keyframes borderGlow {
  0%, 100% { background-position: 0% 0%; }
  50% { background-position: 100% 100%; }
}

/* Single corner accent (top-left only) */
.module::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 50px;
  height: 50px;
  border-left: 2px solid rgba(100, 181, 246, 0.5);
  border-top: 2px solid rgba(100, 181, 246, 0.5);
  border-top-left-radius: var(--radius-md);
  pointer-events: none;
}

.soil-monitoring-module {
  width: 1096px !important;
}

/* ===== Module Header ===== */
.module h2 {
  font-size: 18px;
  color: var(--primary);
  margin-bottom: var(--space-md);
  padding-bottom: var(--space-sm);
  border-bottom: 1px solid transparent;
  border-image: linear-gradient(
    90deg,
    transparent 0%,
    rgba(100, 181, 246, 0.6) 20%,
    rgba(100, 181, 246, 0.6) 80%,
    transparent 100%
  ) 1;
  font-weight: 600;
  letter-spacing: 2px;
  text-shadow: 0 0 15px rgba(100, 181, 246, 0.4);
  position: relative;
}

.module h2::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 3px;
  height: 18px;
  background: linear-gradient(
    180deg,
    rgba(100, 181, 246, 0.3) 0%,
    var(--primary) 50%,
    rgba(100, 181, 246, 0.3) 100%
  );
  border-radius: 2px;
  margin-left: -16px;
}

/* ===== Video Wall Module ===== */
.video-wall-module {
  display: flex;
  flex-direction: column;
}

.video-iframe-container {
  flex: 1;
  border-radius: var(--radius-sm);
  overflow: hidden;
  border: 1px solid rgba(100, 181, 246, 0.15);
}

.video-iframe {
  width: 100%;
  height: 100%;
  border: none;
}

/* ===== Video Conference Module ===== */
.video-conference-module {
  display: flex;
  flex-direction: column;
}

.conference-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: var(--space-md);
}

.main-video {
  flex: 1;
  background: rgba(0, 0, 0, 0.25);
  border-radius: var(--radius-sm);
  margin-bottom: var(--space-md);
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  border: 1px solid rgba(100, 181, 246, 0.15);
}

.conference-image {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

/* ===== Participants Marquee ===== */
.participants-marquee-container {
  height: 80px;
  overflow: hidden;
  background: rgba(0, 0, 0, 0.2);
  border-radius: var(--radius-sm);
  padding: var(--space-sm);
  border: 1px solid rgba(100, 181, 246, 0.15);
}

.participants-marquee-content {
  animation: participants-scroll 25s linear infinite;
}

.participant-row {
  display: flex;
  justify-content: space-around;
  padding: 4px 0;
}

.participant-item {
  display: flex;
  align-items: center;
  width: 45%;
  padding: var(--space-sm);
  background: linear-gradient(135deg, rgba(17, 34, 64, 0.85) 0%, rgba(26, 52, 96, 0.9) 100%);
  border-radius: var(--radius-sm);
  margin: 2px 0;
  border: 1px solid rgba(100, 181, 246, 0.2);
  box-shadow: var(--shadow-sm);
  transition: transform var(--transition-fast), border-color var(--transition-fast);
}

.participant-item:hover {
  background: linear-gradient(135deg, rgba(26, 52, 96, 0.95) 0%, rgba(34, 68, 128, 1) 100%);
  border-color: rgba(100, 181, 246, 0.4);
  transform: translateX(3px);
}

.participant-status {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  margin-right: var(--space-sm);
}

.participant-status.online {
  background-color: #8bc34a;
  box-shadow: 0 0 8px rgba(139, 195, 74, 0.6);
}

.participant-status.offline {
  background-color: #f44336;
  box-shadow: 0 0 8px rgba(244, 67, 54, 0.6);
}

.participant-name {
  font-size: 12px;
  color: var(--text-secondary);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

@keyframes participants-scroll {
  0% { transform: translateY(0); }
  100% { transform: translateY(-33.33%); }
}

/* ===== Weather & Hydrology Module ===== */
.weather-hydrology-module {
  display: flex;
  flex-direction: column;
}

.weather-hydrology-content {
  flex: 1;
  display: flex;
  gap: var(--space-md);
  margin-bottom: var(--space-md);
}

.monitoring-section {
  flex: 1;
  display: flex;
  flex-direction: column;
  background: linear-gradient(135deg, rgba(17, 34, 64, 0.8) 0%, rgba(26, 52, 96, 0.85) 100%);
  border-radius: var(--radius-sm);
  padding: var(--space-md);
  border: 1px solid rgba(100, 181, 246, 0.3);
  box-shadow: var(--shadow-md);
  position: relative;
  overflow: hidden;
}

.monitoring-section::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: linear-gradient(90deg, transparent 0%, var(--primary) 50%, transparent 100%);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: var(--space-md);
  padding-bottom: var(--space-sm);
  border-bottom: 1px solid rgba(100, 181, 246, 0.2);
}

.section-header h3 {
  margin: 0;
  color: var(--primary);
  font-size: 15px;
  font-weight: 600;
}

.section-settings-btn {
  background: rgba(100, 181, 246, 0.15);
  border: 1px solid rgba(100, 181, 246, 0.25);
  color: var(--text-secondary);
  border-radius: 50%;
  width: 26px;
  height: 26px;
  cursor: pointer;
  font-size: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: transform var(--transition-fast), background var(--transition-fast);
}

.section-settings-btn:hover {
  background: rgba(100, 181, 246, 0.25);
  transform: rotate(90deg);
}

.section-settings-btn:focus-visible {
  outline: 2px solid var(--primary);
  outline-offset: 2px;
}

.chart-container {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  min-height: 200px;
}

.left-section {
  border-left: 3px solid #4caf50;
}

.right-section {
  border-left: 3px solid #2196f3;
}

.weather-map-module {
  display: flex;
  flex-direction: column;
}

.module-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: var(--space-md);
}

.module-header h2 {
  margin: 0;
}

.settings-btn {
  background: rgba(100, 181, 246, 0.15);
  border: 1px solid rgba(100, 181, 246, 0.25);
  color: var(--text-secondary);
  border-radius: 50%;
  width: 28px;
  height: 28px;
  cursor: pointer;
  font-size: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: transform var(--transition-fast), background var(--transition-fast);
}

.settings-btn:hover {
  background: rgba(100, 181, 246, 0.25);
  transform: rotate(90deg);
}

.weather-chart-container {
  flex: 1;
  background: rgba(0, 0, 0, 0.2);
  border-radius: var(--radius-sm);
  margin-bottom: var(--space-md);
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

.chart-placeholder {
  color: var(--text-muted);
  font-size: 14px;
}

.chart-iframe-container {
  width: 100%;
  height: 100%;
}

.chart-iframe {
  width: 100%;
  height: 100%;
  border: none;
}

.weather-data {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--space-sm);
}

.data-item {
  padding: var(--space-sm);
  background: rgba(0, 0, 0, 0.25);
  border-radius: var(--radius-sm);
  font-size: 12px;
}

.data-label {
  color: var(--text-muted);
}

.data-value {
  color: var(--text-secondary);
  float: right;
}

/* ===== Soil Monitoring Module ===== */
.soil-monitoring-module {
  display: flex;
  flex-direction: column;
  background: linear-gradient(135deg, rgba(17, 34, 64, 0.75) 0%, rgba(26, 52, 96, 0.8) 100%);
}

.soil-monitoring-module .module-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: var(--space-md);
  padding-bottom: var(--space-sm);
  border-bottom: 1px solid rgba(100, 181, 246, 0.25);
}

.header-controls {
  display: flex;
  align-items: center;
  gap: var(--space-md);
}

.sensor-icon {
  display: flex;
  align-items: center;
}

.sensor-image {
  height: 28px;
  width: auto;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.3))
          brightness(0.9)
          sepia(0.3)
          hue-rotate(180deg)
          saturate(1.5);
  transition: transform var(--transition-fast), filter var(--transition-fast);
  mix-blend-mode: screen;
}

.sensor-image:hover {
  transform: scale(1.1);
  filter: drop-shadow(0 2px 6px rgba(100, 181, 246, 0.5))
          brightness(1)
          sepia(0.2)
          hue-rotate(180deg)
          saturate(1.8);
}

.location-selector {
  position: relative;
}

.location-dropdown {
  background: linear-gradient(135deg, rgba(10, 25, 47, 0.9) 0%, rgba(17, 34, 64, 0.95) 100%);
  border: 1px solid rgba(100, 181, 246, 0.35);
  color: var(--text-secondary);
  border-radius: var(--radius-sm);
  padding: var(--space-sm) 32px var(--space-sm) var(--space-sm);
  font-size: 11px;
  cursor: pointer;
  appearance: none;
  -webkit-appearance: none;
  -moz-appearance: none;
  background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%2364b5f6' stroke-width='2'%3e%3cpolyline points='6,9 12,15 18,9'%3e%3c/polyline%3e%3c/svg%3e");
  background-repeat: no-repeat;
  background-position: right 8px center;
  background-size: 12px;
  box-shadow: var(--shadow-sm);
  transition: border-color var(--transition-fast), box-shadow var(--transition-fast);
}

.location-dropdown:focus {
  outline: none;
  border-color: var(--primary);
  box-shadow: 0 0 12px rgba(100, 181, 246, 0.4);
}

.location-dropdown option {
  background: var(--bg-primary);
  color: var(--text-secondary);
}

.location-display {
  background: linear-gradient(135deg, rgba(26, 52, 96, 0.6) 0%, rgba(34, 68, 128, 0.7) 100%);
  border-radius: var(--radius-sm);
  padding: var(--space-md);
  margin-bottom: var(--space-md);
  text-align: center;
  border: 1px solid rgba(100, 181, 246, 0.25);
  box-shadow: var(--shadow-sm);
}

.current-location {
  color: var(--primary);
  font-size: 14px;
  font-weight: 600;
  margin-bottom: 4px;
}

.sensor-id {
  color: var(--text-muted);
  font-size: 12px;
  font-family: 'SF Mono', 'Consolas', monospace;
  letter-spacing: 0.5px;
}

.monitoring-grid {
  flex: 1;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--space-sm);
  margin-bottom: var(--space-md);
  padding: 4px;
}

/* ===== Metric Cards ===== */
.metric-card {
  background: linear-gradient(135deg, rgba(17, 34, 64, 0.85) 0%, rgba(26, 52, 96, 0.9) 100%);
  border-radius: var(--radius-sm);
  padding: var(--space-md);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  box-shadow: var(--shadow-md);
  border: 1px solid rgba(100, 181, 246, 0.3);
  transition: transform var(--transition-fast), box-shadow var(--transition-fast), border-color var(--transition-fast);
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
  position: relative;
  overflow: hidden;
}

.metric-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: linear-gradient(90deg, transparent 0%, var(--primary) 50%, transparent 100%);
  opacity: 0.6;
}

.metric-card::after {
  content: '';
  position: absolute;
  top: -100%;
  left: -100%;
  width: 300%;
  height: 300%;
  background: radial-gradient(circle, rgba(100, 181, 246, 0.1) 0%, transparent 60%);
  opacity: 0;
  transition: opacity var(--transition-slow);
}

.metric-card:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow-glow), var(--shadow-md);
  border-color: rgba(100, 181, 246, 0.5);
}

.metric-card:hover::after {
  opacity: 1;
}

.metric-card:focus-visible {
  outline: 2px solid var(--primary);
  outline-offset: 3px;
}

.metric-label {
  font-size: 18px;
  font-weight: 600;
  color: var(--text-secondary);
  margin-bottom: var(--space-sm);
  text-align: center;
  letter-spacing: 1px;
}

.metric-value {
  font-size: 24px;
  font-weight: 700;
  background: linear-gradient(180deg, #90caf9 0%, var(--primary) 50%, #2286c3 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  text-align: center;
  transition: transform var(--transition-fast);
}

.metric-value.changing {
  animation: valueChange 0.3s ease-out;
}

@keyframes valueChange {
  0% { transform: scale(1.05); }
  100% { transform: scale(1); }
}

.unit {
  font-size: 12px;
  color: var(--text-muted);
  margin-left: 3px;
  font-weight: 500;
}

/* ===== Sensor Placeholder ===== */
.sensor-placeholder {
  background: linear-gradient(135deg, rgba(17, 34, 64, 0.85) 0%, rgba(26, 52, 96, 0.9) 100%);
  border-radius: var(--radius-sm);
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: var(--shadow-md);
  border: 1px solid rgba(100, 181, 246, 0.3);
  transition: transform var(--transition-fast), box-shadow var(--transition-fast);
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
  position: relative;
  overflow: hidden;
}

.sensor-placeholder::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: linear-gradient(90deg, transparent 0%, var(--primary) 50%, transparent 100%);
  opacity: 0.6;
}

.placeholder-sensor-image {
  max-width: 75%;
  max-height: 75%;
  width: auto;
  height: auto;
  filter: drop-shadow(0 2px 8px rgba(0, 0, 0, 0.4))
          brightness(0.85)
          sepia(0.25)
          hue-rotate(180deg)
          saturate(1.4);
  transition: transform var(--transition-fast), filter var(--transition-fast);
  mix-blend-mode: screen;
}

.sensor-placeholder:hover .placeholder-sensor-image {
  transform: scale(1.05);
  filter: drop-shadow(0 4px 12px rgba(100, 181, 246, 0.4))
          brightness(0.95)
          sepia(0.15)
          hue-rotate(180deg)
          saturate(1.6);
}

.monitoring-footer {
  background: linear-gradient(135deg, rgba(10, 25, 47, 0.6) 0%, rgba(17, 34, 64, 0.7) 100%);
  border-radius: var(--radius-sm);
  padding: var(--space-md);
  text-align: center;
  border: 1px solid rgba(100, 181, 246, 0.2);
}

.timestamp {
  color: var(--text-muted);
  font-size: 11px;
}

/* ===== Modals ===== */
.image-modal,
.settings-modal {
  position: fixed;
  inset: 0;
  background-color: rgba(0, 0, 0, 0.85);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
}

.settings-modal {
  z-index: 1001;
}

.settings-modal-content {
  position: relative;
  background: linear-gradient(135deg, rgba(10, 25, 47, 0.98) 0%, rgba(17, 34, 64, 0.98) 100%);
  padding: var(--space-xl);
  border-radius: var(--radius-md);
  width: 420px;
  max-width: 90%;
  border: 1px solid rgba(100, 181, 246, 0.3);
  box-shadow: var(--shadow-lg), var(--shadow-glow);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
}

.settings-modal-content h3 {
  color: var(--primary);
  margin-top: 0;
  margin-bottom: var(--space-lg);
  text-align: center;
  font-weight: 600;
}

.input-group {
  margin-bottom: var(--space-lg);
}

.input-group label {
  display: block;
  color: var(--text-secondary);
  margin-bottom: var(--space-sm);
  font-size: 13px;
  font-weight: 500;
}

.url-input {
  width: 100%;
  padding: var(--space-md);
  background: rgba(0, 0, 0, 0.3);
  border: 1px solid rgba(100, 181, 246, 0.25);
  border-radius: var(--radius-sm);
  color: var(--text-secondary);
  font-size: 14px;
  box-sizing: border-box;
  transition: border-color var(--transition-fast), box-shadow var(--transition-fast);
}

.url-input:focus {
  outline: none;
  border-color: var(--primary);
  box-shadow: 0 0 0 3px rgba(100, 181, 246, 0.2);
}

.url-input::placeholder {
  color: rgba(144, 202, 249, 0.5);
}

.modal-actions {
  display: flex;
  justify-content: flex-end;
  gap: var(--space-md);
  padding-top: var(--space-lg);
  border-top: 1px solid rgba(100, 181, 246, 0.15);
  margin-top: var(--space-lg);
}

.cancel-btn,
.confirm-btn,
.save-btn {
  padding: 10px 20px;
  border-radius: var(--radius-sm);
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  transition: transform var(--transition-fast), box-shadow var(--transition-fast);
  border: 1px solid transparent;
}

.cancel-btn {
  background: rgba(244, 67, 54, 0.12);
  border-color: rgba(244, 67, 54, 0.25);
  color: #ef9a9a;
}

.cancel-btn:hover {
  background: rgba(244, 67, 54, 0.2);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(244, 67, 54, 0.2);
}

.confirm-btn {
  background: linear-gradient(135deg, rgba(100, 181, 246, 0.2) 0%, rgba(68, 138, 255, 0.25) 100%);
  border-color: rgba(100, 181, 246, 0.35);
  color: var(--text-secondary);
  flex: 1;
  max-width: 120px;
}

.confirm-btn:hover {
  background: linear-gradient(135deg, rgba(100, 181, 246, 0.3) 0%, rgba(68, 138, 255, 0.35) 100%);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(100, 181, 246, 0.25);
}

.save-btn {
  background: linear-gradient(135deg, rgba(76, 175, 80, 0.2) 0%, rgba(56, 142, 60, 0.25) 100%);
  border-color: rgba(76, 175, 80, 0.35);
  color: #a5d6a7;
  min-width: 90px;
}

.save-btn:hover {
  background: linear-gradient(135deg, rgba(76, 175, 80, 0.3) 0%, rgba(56, 142, 60, 0.35) 100%);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(76, 175, 80, 0.25);
}

.modal-content {
  position: relative;
  background-color: #fff;
  padding: var(--space-xl);
  border-radius: var(--radius-md);
  max-width: 80%;
  max-height: 80%;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.close-button {
  position: absolute;
  top: var(--space-md);
  right: var(--space-lg);
  font-size: 28px;
  font-weight: 300;
  color: #333;
  cursor: pointer;
  z-index: 1001;
  transition: color var(--transition-fast), transform var(--transition-fast);
}

.close-button:hover {
  color: #666;
  transform: scale(1.1);
}

.modal-image {
  max-width: 100%;
  max-height: 70vh;
  border-radius: var(--radius-sm);
}

.image-caption {
  margin-top: var(--space-md);
  font-size: 15px;
  color: #333;
  text-align: center;
}
</style>