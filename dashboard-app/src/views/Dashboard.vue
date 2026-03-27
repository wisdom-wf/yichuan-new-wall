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
          <div class="video-map-container">
            <div class="map-display">
              <div id="video-map-container" class="amap-container"></div>
            </div>
          </div>
          <div class="video-thumbnails">
            <div class="video-item" v-for="item in videoList" :key="item.id" @click="showVideoImage(item)">
              <div class="video-placeholder">{{ item.name }}</div>
              <div class="video-info">{{ item.location }}</div>
            </div>
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
      hydrologyChartUrl: '', // 水利监测图表 URL
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
    // 从本地存储加载保存的地址（使用代理地址）
    this.weatherChartUrl = this.getFromLocalStorage(this.STORAGE_KEYS.WEATHER_URL, '');
    this.hydrologyChartUrl = this.getFromLocalStorage(this.STORAGE_KEYS.HYDROLOGY_URL, '');
    
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
.dashboard-container {
  height: 100vh;
  display: flex;
  flex-direction: column;
  background: linear-gradient(135deg, #0a192f 0%, #102a43 100%);
  padding: 10px;
  overflow: hidden;
  position: relative;
}

.header {
  background: linear-gradient(135deg, #0a192f 0%, #0c2d48 100%);
  border-radius: 12px;
  margin-bottom: 10px;
  min-height: 160px; /* 高度增加一倍：80px → 160px */
  position: relative;
  overflow: hidden;
  box-shadow: 0 6px 25px rgba(0, 0, 0, 0.5), 0 0 30px rgba(100, 181, 246, 0.2);
  border: 1px solid rgba(100, 181, 246, 0.4);
  padding: 0;
}

/* 角落装饰元素 */
.header-corner-decoration {
  position: absolute;
  width: 20px;
  height: 20px;
  border: 2px solid rgba(100, 181, 246, 0.6);
}

.header-corner-decoration.tl {
  top: 10px;
  left: 10px;
  border-right: none;
  border-bottom: none;
  border-top-left-radius: 8px;
}

.header-corner-decoration.tr {
  top: 10px;
  right: 10px;
  border-left: none;
  border-bottom: none;
  border-top-right-radius: 8px;
}

.header-corner-decoration.bl {
  bottom: 10px;
  left: 10px;
  border-right: none;
  border-top: none;
  border-bottom-left-radius: 8px;
}

.header-corner-decoration.br {
  bottom: 10px;
  right: 10px;
  border-left: none;
  border-top: none;
  border-bottom-right-radius: 8px;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 30px 30px; /* 增加上下内边距 */
  height: 160px; /* 与标题栏高度一致 */
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
}

.current-date {
  font-size: 14px;
  color: #bbdefb;
  margin-bottom: 5px;
  font-weight: 500;
}

.current-weather {
  display: flex;
  align-items: center;
  gap: 5px;
  font-size: 13px;
  color: #82b1ff;
  font-weight: 500;
}

.weather-icon {
  font-size: 16px;
}

.weather-text {
  color: #64b5f6;
}

.header-center {
  display: flex;
  justify-content: center;
  align-items: center;
  flex: 1;
}

.main-title-container {
  padding: 30px 50px;
  border: none;
  border-radius: 0;
  background: transparent;
  position: relative;
  overflow: visible;
  backdrop-filter: blur(0);
  transition: all 0.3s ease;
}

.main-title-container::before {
  display: none;
}

.main-title {
  font-size: 48px;
  margin: 0;
  font-weight: 900;
  letter-spacing: 4px;
  font-family: 'Microsoft YaHei', 'SimHei', Arial, sans-serif;
  position: relative;
  z-index: 2;
  text-align: center;
  line-height: 1.2;
  
  /* 金色金属字效果 */
  background: linear-gradient(
    180deg,
    #fff8dc 0%,
    #ffd700 15%,
    #ffec8b 30%,
    #daa520 45%,
    #ffd700 55%,
    #b8860b 70%,
    #ffd700 85%,
    #fff8dc 100%
  );
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  
  /* 金属光泽文字阴影 */
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.6))
          drop-shadow(0 0 20px rgba(255, 215, 0, 0.3));
  
  /* 扫光动画 */
  background-size: 100% 200%;
  animation: goldShine 4s ease-in-out infinite;
}

/* 金色扫光动画 */
@keyframes goldShine {
  0%, 100% {
    background-position: 0% 0%;
  }
  50% {
    background-position: 0% 100%;
  }
}

/* 标题装饰线 */
.main-title-container::after {
  content: '';
  position: absolute;
  bottom: 10px;
  left: 50%;
  transform: translateX(-50%);
  width: 80%;
  height: 3px;
  background: linear-gradient(
    90deg,
    transparent 0%,
    rgba(255, 215, 0, 0.3) 20%,
    rgba(255, 215, 0, 0.8) 50%,
    rgba(255, 215, 0, 0.3) 80%,
    transparent 100%
  );
  border-radius: 2px;
}

/* 移除之前的装饰元素 */
.title-decoration-left,
.title-decoration-right {
  display: none;
}

.title-glow-effect {
  display: none;
}

.header-right {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  flex: 1;
}

/* 刷新按钮容器样式 */
.refresh-button-container {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  height: 100%;
}

.refresh-button {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 16px;
  background: linear-gradient(135deg, rgba(100, 181, 246, 0.2) 0%, rgba(68, 138, 255, 0.3) 100%);
  border: 1px solid rgba(100, 181, 246, 0.4);
  border-radius: 25px;
  color: #bbdefb;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
}

.refresh-button:hover {
  background: linear-gradient(135deg, rgba(100, 181, 246, 0.3) 0%, rgba(68, 138, 255, 0.4) 100%);
  transform: translateY(-2px);
  box-shadow: 0 4px 15px rgba(100, 181, 246, 0.3);
  border-color: rgba(100, 181, 246, 0.6);
}

.refresh-button:active {
  transform: translateY(0);
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
}

.refresh-icon {
  font-size: 16px;
  animation: spin 1s linear infinite;
}

.refresh-button:hover .refresh-icon {
  animation-duration: 0.5s;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.refresh-text {
  font-weight: 500;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
}

.system-info {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
}

.system-status {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
  padding: 6px 12px;
  background: rgba(76, 175, 80, 0.15);
  border-radius: 20px;
  border: 1px solid rgba(76, 175, 80, 0.3);
}

.status-indicator {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  margin-right: 10px;
  border: 2px solid rgba(255, 255, 255, 0.5);
  background-color: #4caf50;
  box-shadow: 0 0 10px rgba(76, 175, 80, 0.8);
  position: relative;
  animation: pulse 2s infinite;
}

.status-indicator.online::after {
  content: '';
  position: absolute;
  top: -2px;
  left: -2px;
  right: -2px;
  bottom: -2px;
  border-radius: 50%;
  border: 1px solid rgba(76, 175, 80, 0.4);
  animation: ripple 2s infinite;
}

@keyframes pulse {
  0% { transform: scale(1); }
  50% { transform: scale(1.1); }
  100% { transform: scale(1); }
}

@keyframes ripple {
  0% { transform: scale(1); opacity: 1; }
  100% { transform: scale(1.5); opacity: 0; }
}

.status-text {
  font-size: 14px;
  color: #8bc34a;
  font-weight: 500;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
}

.header-controls {
  display: flex;
  gap: 12px;
}

.control-item {
  padding: 6px 15px;
  background: linear-gradient(135deg, rgba(100, 181, 246, 0.2) 0%, rgba(68, 138, 255, 0.3) 100%);
  border-radius: 20px;
  font-size: 13px;
  color: #bbdefb;
  border: 1px solid rgba(100, 181, 246, 0.4);
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
  backdrop-filter: blur(5px);
}

.control-item:hover {
  background: linear-gradient(135deg, rgba(100, 181, 246, 0.4) 0%, rgba(68, 138, 255, 0.5) 100%);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(100, 181, 246, 0.4);
}

.control-item:hover {
  background: rgba(100, 181, 246, 0.3);
  box-shadow: 0 0 8px rgba(100, 181, 246, 0.3);
}

.header-bottom-line {
  height: 4px;
  background: linear-gradient(90deg, 
    transparent, 
    #64b5f6, 
    #448aff, 
    #2979ff,
    #448aff,
    #64b5f6, 
    transparent);
  width: 100%;
  position: absolute;
  bottom: 0;
  opacity: 0.9;
  box-shadow: 0 0 15px rgba(100, 181, 246, 0.6);
  animation: lineGlow 3s ease-in-out infinite alternate;
}

@keyframes lineGlow {
  0% { opacity: 0.7; box-shadow: 0 0 10px rgba(100, 181, 246, 0.4); }
  100% { opacity: 1; box-shadow: 0 0 20px rgba(100, 181, 246, 0.8); }
}

.system-status {
  position: absolute;
  right: 20px;
  font-size: 14px;
  color: #8bc34a;
}

.modules-wrapper {
  flex: 1;
  overflow-x: auto;
  overflow-y: hidden;
  padding: 5px 0;
}

.modules-wrapper::-webkit-scrollbar {
  height: 8px;
}

.modules-wrapper::-webkit-scrollbar-track {
  background: rgba(17, 34, 64, 0.3);
  border-radius: 4px;
}

.modules-wrapper::-webkit-scrollbar-thumb {
  background: #64b5f6;
  border-radius: 4px;
}

.modules-wrapper::-webkit-scrollbar-thumb:hover {
  background: #42a5f5;
}

.modules-container {
  display: flex;
  gap: 30px; /* 模块间距30px */
  height: calc(100vh - 160px); /* 调整为新的标题栏高度 */
  position: relative;
}

.module {
  /* 6720px屏幕布局
     间距：30px × 3 = 90px
     前3个模块宽度：1845px
     第4个模块宽度：1096px */
  width: 1845px;
  height: 100%;
  background: rgba(17, 34, 64, 0.7);
  border-radius: 8px;
  padding: 15px;
  display: flex;
  flex-direction: column;
  box-shadow: 
    0 4px 20px rgba(0, 0, 0, 0.3),
    0 0 30px rgba(100, 181, 246, 0.1),
    inset 0 0 20px rgba(100, 181, 246, 0.05);
  border: 1px solid rgba(100, 181, 246, 0.3);
  flex-shrink: 0;
  position: relative;
  overflow: hidden;
}

/* 模块流动光效边框 */
.module::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  border-radius: 8px;
  padding: 2px;
  background: linear-gradient(
    90deg,
    transparent 0%,
    rgba(100, 181, 246, 0.1) 25%,
    rgba(100, 181, 246, 0.6) 50%,
    rgba(100, 181, 246, 0.1) 75%,
    transparent 100%
  );
  background-size: 200% 100%;
  -webkit-mask: 
    linear-gradient(#fff 0 0) content-box, 
    linear-gradient(#fff 0 0);
  -webkit-mask-composite: xor;
  mask: 
    linear-gradient(#fff 0 0) content-box, 
    linear-gradient(#fff 0 0);
  mask-composite: exclude;
  animation: borderFlow 3s linear infinite;
  pointer-events: none;
}

@keyframes borderFlow {
  0% {
    background-position: 200% 0;
  }
  100% {
    background-position: -200% 0;
  }
}

/* L型边角装饰 */
.module::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  pointer-events: none;
  background: 
    /* 左上角L型 */
    linear-gradient(90deg, rgba(100, 181, 246, 0.8) 0%, rgba(100, 181, 246, 0.8) 40px, transparent 40px),
    linear-gradient(180deg, rgba(100, 181, 246, 0.8) 0%, rgba(100, 181, 246, 0.8) 40px, transparent 40px),
    /* 右上角L型 */
    linear-gradient(-90deg, rgba(100, 181, 246, 0.8) 0%, rgba(100, 181, 246, 0.8) 40px, transparent 40px),
    linear-gradient(180deg, rgba(100, 181, 246, 0.8) 0%, rgba(100, 181, 246, 0.8) 40px, transparent 40px),
    /* 左下角L型 */
    linear-gradient(90deg, rgba(100, 181, 246, 0.8) 0%, rgba(100, 181, 246, 0.8) 40px, transparent 40px),
    linear-gradient(0deg, rgba(100, 181, 246, 0.8) 0%, rgba(100, 181, 246, 0.8) 40px, transparent 40px),
    /* 右下角L型 */
    linear-gradient(-90deg, rgba(100, 181, 246, 0.8) 0%, rgba(100, 181, 246, 0.8) 40px, transparent 40px),
    linear-gradient(0deg, rgba(100, 181, 246, 0.8) 0%, rgba(100, 181, 246, 0.8) 40px, transparent 40px);
  background-size: 
    3px 3px, 3px 3px,
    3px 3px, 3px 3px,
    3px 3px, 3px 3px,
    3px 3px, 3px 3px;
  background-position: 
    0 0, 0 0,
    100% 0, 100% 0,
    0 100%, 0 100%,
    100% 100%, 100% 100%;
  background-repeat: no-repeat;
}

/* 第四个模块占66%宽度 */
.soil-monitoring-module {
  width: 1096px !important;
}

.module h2 {
  font-size: 20px;
  color: #64b5f6;
  margin-bottom: 15px;
  padding-bottom: 10px;
  border-bottom: 2px solid transparent;
  border-image: linear-gradient(
    90deg,
    transparent 0%,
    rgba(100, 181, 246, 0.8) 20%,
    rgba(100, 181, 246, 0.8) 80%,
    transparent 100%
  ) 1;
  font-weight: 700;
  letter-spacing: 2px;
  text-shadow: 0 0 10px rgba(100, 181, 246, 0.5);
  position: relative;
}

/* 模块标题左侧装饰 */
.module h2::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 4px;
  height: 20px;
  background: linear-gradient(
    180deg,
    rgba(100, 181, 246, 0.2) 0%,
    rgba(100, 181, 246, 1) 50%,
    rgba(100, 181, 246, 0.2) 100%
  );
  border-radius: 2px;
  margin-left: -15px;
}

/* 视频墙模块样式 */
.video-wall-module {
  display: flex;
  flex-direction: column;
}

.video-map-container {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.map-display {
  flex: 1;
  background: rgba(0, 0, 0, 0.3);
  border-radius: 4px;
  position: relative;
  overflow: hidden;
}

.amap-container {
  width: 100%;
  height: 100%;
}

.video-thumbnails {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 10px;
  height: 120px;
}

.video-item {
  background: linear-gradient(135deg, rgba(17, 34, 64, 0.8) 0%, rgba(26, 52, 96, 0.9) 100%);
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  border: 1px solid rgba(100, 181, 246, 0.3);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
  transition: all 0.3s ease;
  position: relative;
}

.video-item::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: linear-gradient(
    90deg,
    transparent 0%,
    rgba(100, 181, 246, 0.5) 30%,
    rgba(100, 181, 246, 0.8) 50%,
    rgba(100, 181, 246, 0.5) 70%,
    transparent 100%
  );
}

.video-item:hover {
  background: linear-gradient(135deg, rgba(26, 52, 96, 0.9) 0%, rgba(34, 68, 128, 0.95) 100%);
  transform: translateY(-3px);
  box-shadow: 0 6px 20px rgba(100, 181, 246, 0.3);
  border-color: rgba(100, 181, 246, 0.5);
}

.video-placeholder {
  height: 80px;
  background: linear-gradient(45deg, #0c2d48, #144366);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  color: #bbdefb;
}

.video-info {
  padding: 5px;
  font-size: 10px;
  color: #90caf9;
  text-align: center;
}

/* 视频会议模块样式 */
.video-conference-module {
  display: flex;
  flex-direction: column;
}

.conference-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.main-video {
  flex: 1;
  background: rgba(0, 0, 0, 0.3);
  border-radius: 4px;
  margin-bottom: 15px;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

.conference-image {
  width: 100%;
  height: 100%;
  object-fit: contain; /* 缩放适应窗口大小 */
}

/* 参会单位滚动展示区样式 */
.participants-marquee-container {
  height: 80px;
  overflow: hidden;
  background: rgba(0, 0, 0, 0.3);
  border-radius: 4px;
  padding: 10px;
}

.participants-marquee-content {
  animation: participants-scroll 20s linear infinite;
}

.participant-row {
  display: flex;
  justify-content: space-around;
  padding: 5px 0;
}

.participant-item {
  display: flex;
  align-items: center;
  width: 45%;
  padding: 8px 10px;
  background: linear-gradient(135deg, rgba(17, 34, 64, 0.8) 0%, rgba(26, 52, 96, 0.9) 100%);
  border-radius: 6px;
  margin: 2px 0;
  border: 1px solid rgba(100, 181, 246, 0.2);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
  transition: all 0.3s ease;
}

.participant-item:hover {
  background: linear-gradient(135deg, rgba(26, 52, 96, 0.9) 0%, rgba(34, 68, 128, 0.95) 100%);
  border-color: rgba(100, 181, 246, 0.4);
  transform: translateX(3px);
}

.participant-status {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  margin-right: 8px;
}

.participant-status.online {
  background-color: #8bc34a;
}

.participant-status.offline {
  background-color: #f44336;
}

.participant-name {
  font-size: 12px;
  color: #bbdefb;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

@keyframes participants-scroll {
  0% {
    transform: translateY(0);
  }
  100% {
    transform: translateY(-33.33%);
  }
}

/* 气象与水利监测模块样式 */
.weather-hydrology-module {
  display: flex;
  flex-direction: column;
}

.weather-hydrology-content {
  flex: 1;
  display: flex;
  gap: 15px;
  margin-bottom: 15px;
}

.monitoring-section {
  flex: 1;
  display: flex;
  flex-direction: column;
  background: linear-gradient(135deg, rgba(17, 34, 64, 0.8) 0%, rgba(26, 52, 96, 0.9) 100%);
  border-radius: 10px;
  padding: 15px;
  border: 1px solid rgba(100, 181, 246, 0.4);
  box-shadow: 
    0 4px 15px rgba(0, 0, 0, 0.3),
    0 0 20px rgba(100, 181, 246, 0.1),
    inset 0 1px 0 rgba(255, 255, 255, 0.1);
  position: relative;
  overflow: hidden;
}

/* 监测卡片顶部光条 */
.monitoring-section::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: linear-gradient(
    90deg,
    transparent 0%,
    rgba(100, 181, 246, 0.5) 30%,
    rgba(100, 181, 246, 0.8) 50%,
    rgba(100, 181, 246, 0.5) 70%,
    transparent 100%
  );
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
  padding-bottom: 10px;
  border-bottom: 1px solid rgba(100, 181, 246, 0.2);
}

.section-header h3 {
  margin: 0;
  color: #64b5f6;
  font-size: 16px;
  font-weight: bold;
}

.section-settings-btn {
  background: rgba(100, 181, 246, 0.2);
  border: 1px solid rgba(100, 181, 246, 0.3);
  color: #bbdefb;
  border-radius: 50%;
  width: 28px;
  height: 28px;
  cursor: pointer;
  font-size: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.section-settings-btn:hover {
  background: rgba(100, 181, 246, 0.3);
  transform: rotate(90deg);
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
  margin-left: -2px; /* 向左扩展2px修正显示异常 */
}

.right-section {
  border-left: 3px solid #2196f3;
}

/* 保持原有的气象云图模块样式以兼容性 */
.weather-map-module {
  display: flex;
  flex-direction: column;
}

.module-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.module-header h2 {
  margin: 0;
}

.settings-btn {
  background: rgba(100, 181, 246, 0.2);
  border: 1px solid rgba(100, 181, 246, 0.3);
  color: #bbdefb;
  border-radius: 50%;
  width: 30px;
  height: 30px;
  cursor: pointer;
  font-size: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.settings-btn:hover {
  background: rgba(100, 181, 246, 0.3);
  transform: rotate(90deg);
}

.weather-chart-container {
  flex: 1;
  background: rgba(0, 0, 0, 0.3);
  border-radius: 4px;
  margin-bottom: 15px;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

.chart-placeholder {
  color: #90caf9;
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
  gap: 10px;
}

.data-item {
  padding: 8px;
  background: rgba(0, 0, 0, 0.3);
  border-radius: 4px;
  font-size: 12px;
}

.data-label {
  color: #90caf9;
}

.data-value {
  color: #bbdefb;
  float: right;
}

/* 土壤墒情监测模块样式 */
.soil-monitoring-module {
  display: flex;
  flex-direction: column;
  background: linear-gradient(135deg, rgba(17, 34, 64, 0.7) 0%, rgba(26, 52, 96, 0.8) 100%);
  border: 1px solid rgba(100, 181, 246, 0.2);
}

.soil-monitoring-module .module-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
  padding-bottom: 10px;
  border-bottom: 1px solid rgba(100, 181, 246, 0.3);
}

.header-controls {
  display: flex;
  align-items: center;
  gap: 15px;
}

.sensor-icon {
  display: flex;
  align-items: center;
}

.sensor-image {
  height: 32px;
  width: auto;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.3));
  transition: transform 0.3s ease;
}

.sensor-image:hover {
  transform: scale(1.1);
}

.location-selector {
  position: relative;
}

.location-dropdown {
  background: linear-gradient(135deg, rgba(10, 25, 47, 0.8) 0%, rgba(17, 34, 64, 0.9) 100%);
  border: 1px solid rgba(100, 181, 246, 0.4);
  color: #bbdefb;
  border-radius: 6px;
  padding: 6px 12px;
  font-size: 12px;
  cursor: pointer;
  appearance: none;
  -webkit-appearance: none;
  -moz-appearance: none;
  background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%2364b5f6' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6,9 12,15 18,9'%3e%3c/polyline%3e%3c/svg%3e");
  background-repeat: no-repeat;
  background-position: right 10px center;
  background-size: 14px;
  padding-right: 35px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
}

.location-dropdown:focus {
  outline: none;
  border-color: #64b5f6;
  box-shadow: 0 0 12px rgba(100, 181, 246, 0.5);
}

.location-dropdown option {
  background: #0a192f;
  color: #bbdefb;
}

.location-display {
  background: linear-gradient(135deg, rgba(26, 52, 96, 0.6) 0%, rgba(34, 68, 128, 0.7) 100%);
  border-radius: 6px;
  padding: 12px;
  margin-bottom: 15px;
  text-align: center;
  border: 1px solid rgba(100, 181, 246, 0.3);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
}

.current-location {
  color: #64b5f6;
  font-size: 16px;
  font-weight: bold;
  text-shadow: 0 1px 3px rgba(0, 0, 0, 0.4);
  margin-bottom: 5px;
}

.sensor-id {
  color: #90caf9;
  font-size: 13px;
  font-family: 'Courier New', monospace;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
  letter-spacing: 1px;
}

.monitoring-grid {
  flex: 1;
  display: grid;
  grid-template-columns: 1fr 1fr; /* 恢复2列布局 */
  gap: 12px; /* 恢复原有间距 */
  margin-bottom: 15px;
  padding: 5px;
  transition: all 0.5s ease;
}

.metric-card {
  background: linear-gradient(135deg, rgba(17, 34, 64, 0.9) 0%, rgba(26, 52, 96, 0.95) 100%);
  border-radius: 10px;
  padding: 15px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  box-shadow: 
    0 4px 15px rgba(0, 0, 0, 0.3),
    0 0 20px rgba(100, 181, 246, 0.1),
    inset 0 1px 0 rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(100, 181, 246, 0.4);
  transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
  backdrop-filter: blur(10px);
  position: relative;
  overflow: hidden;
}

/* 卡片顶部光条 */
.metric-card::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: linear-gradient(
    90deg,
    transparent 0%,
    rgba(100, 181, 246, 0.5) 30%,
    rgba(100, 181, 246, 0.8) 50%,
    rgba(100, 181, 246, 0.5) 70%,
    transparent 100%
  );
}

/* 传感器图片占位样式 */
.sensor-placeholder {
  background: linear-gradient(135deg, rgba(17, 34, 64, 0.9) 0%, rgba(26, 52, 96, 0.95) 100%);
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 
    0 4px 15px rgba(0, 0, 0, 0.3),
    0 0 20px rgba(100, 181, 246, 0.1),
    inset 0 1px 0 rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(100, 181, 246, 0.4);
  transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
  backdrop-filter: blur(10px);
  position: relative;
  overflow: hidden;
}

/* 传感器卡片顶部光条 */
.sensor-placeholder::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: linear-gradient(
    90deg,
    transparent 0%,
    rgba(100, 181, 246, 0.5) 30%,
    rgba(100, 181, 246, 0.8) 50%,
    rgba(100, 181, 246, 0.5) 70%,
    transparent 100%
  );
}

.placeholder-sensor-image {
  max-width: 80%;
  max-height: 80%;
  width: auto;
  height: auto;
  filter: drop-shadow(0 2px 8px rgba(0, 0, 0, 0.4));
  transition: transform 0.3s ease;
}

.sensor-placeholder:hover .placeholder-sensor-image {
  transform: scale(1.05);
}

.metric-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(100, 181, 246, 0.2), transparent);
  transition: 0.5s;
}

.metric-card.location-changing::before {
  left: 100%;
}

.metric-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 6px 20px rgba(100, 181, 246, 0.4);
  border-color: rgba(100, 181, 246, 0.6);
  background: linear-gradient(135deg, rgba(26, 52, 96, 0.9) 0%, rgba(34, 68, 128, 0.95) 100%);
}

.metric-label {
  font-size: 22px;
  font-weight: bold;
  color: #bbdefb;
  margin-bottom: 8px;
  text-align: center;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
  letter-spacing: 1px;
}

.metric-value {
  font-size: 26px;
  font-weight: 800;
  background: linear-gradient(180deg, #64b5f6 0%, #42a5f5 50%, #2196f3 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  text-align: center;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.5));
  transition: all 0.3s ease;
  position: relative;
}

.metric-value.changing {
  color: #ff9800;
  transform: scale(1.05);
  text-shadow: 0 0 10px rgba(255, 152, 0, 0.5);
}

.unit {
  font-size: 14px;
  color: #90caf9;
  margin-left: 4px;
  font-weight: normal;
}

.monitoring-footer {
  background: linear-gradient(135deg, rgba(10, 25, 47, 0.6) 0%, rgba(17, 34, 64, 0.7) 100%);
  border-radius: 6px;
  padding: 12px;
  text-align: center;
  border: 1px solid rgba(100, 181, 246, 0.2);
}

.timestamp {
  color: #90caf9;
  font-size: 12px;
  text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
}


@keyframes marquee-scroll {
  0% {
    transform: translateY(0);
  }
  100% {
    transform: translateY(-50%);
  }
}

/* 图像弹窗样式 */
.image-modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.8);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

/* 设置弹窗样式 */
.settings-modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.8);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1001;
}

.settings-modal-content {
  position: relative;
  background-color: #0a192f;
  padding: 30px;
  border-radius: 8px;
  width: 400px;
  max-width: 90%;
  border: 1px solid rgba(100, 181, 246, 0.3);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
}

.settings-modal-content h3 {
  color: #64b5f6;
  margin-top: 0;
  margin-bottom: 20px;
  text-align: center;
}

.input-group {
  margin-bottom: 20px;
}

.input-group label {
  display: block;
  color: #bbdefb;
  margin-bottom: 8px;
  font-size: 14px;
}

.url-input {
  width: 100%;
  padding: 10px;
  background: rgba(0, 0, 0, 0.3);
  border: 1px solid rgba(100, 181, 246, 0.3);
  border-radius: 4px;
  color: #bbdefb;
  font-size: 14px;
  box-sizing: border-box;
}

.url-input:focus {
  outline: none;
  border-color: #64b5f6;
  box-shadow: 0 0 8px rgba(100, 181, 246, 0.3);
}

.url-input::placeholder {
  color: #64788f;
}

.modal-actions {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  padding-top: 20px;
  border-top: 1px solid rgba(100, 181, 246, 0.2);
  margin-top: 20px;
}

.cancel-btn, .confirm-btn, .save-btn {
  padding: 12px 24px;
  border-radius: 6px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  border: none;
  min-width: 80px;
}

.cancel-btn {
  background: rgba(244, 67, 54, 0.15);
  border: 1px solid rgba(244, 67, 54, 0.3);
  color: #ffcdd2;
}

.cancel-btn:hover {
  background: rgba(244, 67, 54, 0.25);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(244, 67, 54, 0.3);
}

.confirm-btn {
  background: linear-gradient(135deg, rgba(100, 181, 246, 0.2) 0%, rgba(68, 138, 255, 0.3) 100%);
  border: 1px solid rgba(100, 181, 246, 0.4);
  color: #bbdefb;
  flex: 1; /* 确认按钮占据更多空间 */
  max-width: 120px;
}

.confirm-btn:hover {
  background: linear-gradient(135deg, rgba(100, 181, 246, 0.3) 0%, rgba(68, 138, 255, 0.4) 100%);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(100, 181, 246, 0.3);
}

.save-btn {
  background: linear-gradient(135deg, rgba(76, 175, 80, 0.2) 0%, rgba(56, 142, 60, 0.3) 100%);
  border: 1px solid rgba(76, 175, 80, 0.4);
  color: #c8e6c9;
  flex: 0 0 auto; /* 保存按钮固定宽度 */
  min-width: 90px;
}

.save-btn:hover {
  background: linear-gradient(135deg, rgba(76, 175, 80, 0.3) 0%, rgba(56, 142, 60, 0.4) 100%);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(76, 175, 80, 0.3);
}

.modal-content {
  position: relative;
  background-color: #fff;
  padding: 20px;
  border-radius: 8px;
  max-width: 80%;
  max-height: 80%;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.close-button {
  position: absolute;
  top: 10px;
  right: 15px;
  font-size: 28px;
  font-weight: bold;
  color: #333;
  cursor: pointer;
  z-index: 1001;
}

.modal-image {
  max-width: 100%;
  max-height: 70vh;
  border-radius: 4px;
}

.image-caption {
  margin-top: 15px;
  font-size: 16px;
  color: #333;
  text-align: center;
}
</style>