
<template>
  <div id="BTCChart" ></div>
  <p id="swap-list-title"><strong>Swap Details</strong></p>
  <div id="swap-list">
    <p v-for="(item,key) in info" id="swap-list-info">
      No{{ key }}-- Symbol : {{ item.symbol }}, Price : {{ item.price }}, Time : {{ item.time }}
    </p>
  </div>
</template>

<script>
import echarts from 'echarts'; // 导入 echarts

export default {
  data() {
    return {
      info:[{symbol:"BTC / USDT",price:"67701",time:"05-01"},{symbol:"BTC/USDT",price:"63701",time:"05-02"},{symbol:"ETH / USDT",price:"68701",time:"05-15"},
        {symbol:"BTC / USDT",price:"67701",time:"05-011"},{symbol:"BTC/USDT",price:"63701",time:"05-011"},{symbol:"ETH / USDT",price:"68701",time:"05-15"},
        {symbol:"BTC / USDT",price:"66701",time:"05-01"},{symbol:"BTC/USDT",price:"63701",time:"05-02"},{symbol:"ETH / USDT",price:"68701",time:"05-15"},
        {symbol:"BTC / USDT",price:"67701",time:"05-01"},{symbol:"BTC/USDT",price:"63701",time:"05-02"},{symbol:"ETH / USDT",price:"68701",time:"05-15"},
        {symbol:"BTC / USDT",price:"67301",time:"05-13"},{symbol:"BTC/USDT",price:"63701",time:"05-02"},{symbol:"ETH / USDT",price:"68701",time:"05-15"},
        {symbol:"BTC / USDT",price:"67401",time:"05-01"},{symbol:"BTC/USDT",price:"63701",time:"05-02"},{symbol:"ETH / USDT",price:"68701",time:"05-15"},
        {symbol:"BTC / USDT",price:"67733",time:"05-01"},{symbol:"BTC/USDT",price:"63701",time:"05-02"},{symbol:"ETH / USDT",price:"68701",time:"05-15"},
        {symbol:"BTC / USDT",price:"65401",time:"05-01"},{symbol:"BTC/USDT",price:"63701",time:"05-02"},{symbol:"ETH / USDT",price:"68701",time:"05-15"},
        {symbol:"BTC / USDT",price:"68901",time:"05-01"},{symbol:"BTC/USDT",price:"63701",time:"05-02"},{symbol:"ETH / USDT",price:"68701",time:"05-15"},
      ],
      data: [{ price: 0, time: 0 }],
      chartOption: {
        xAxis: {
          type: 'category',
          name: 'M-Day',
          data: [] // 初始化为空数组
        },
        yAxis: {
          type: 'value',
          name: 'USDT / MONSTER0',
        },
        series: [{
          data: [],
          type: 'line',
          smooth: true
        }]
      }
    };
  },
  methods: {
    setData() {
      for (let i = 0; i < 20; i++) {
        let price = this.getRandomNumber(20, 90);
        if(price > 50){
          price -= 10;
        }
        let time = this.timestampToMonthAndDay(this.getRandomNumber(1700000000,1800000000));
        this.data.push({ price,time }); // 将新元素添加到 data 数组中
      }
      // 更新 chartOption 中的数据
      this.chartOption.xAxis.data = this.data.map(item => item.time);
      this.chartOption.series[0].data = this.data.map(item => item.price);
      console.log(this.data);
    },
    getRandomNumber(min, max) {
      return Math.floor(Math.random() * (max - min + 1)) + min;
    },
    timestampToMonthAndDay(timestamp) {
      const dateObj = new Date(timestamp * 1000); // 将时间戳乘以 1000 转换为毫秒
      const month = dateObj.getMonth() + 1; // 月份从 0 开始，所以要加 1
      const day = dateObj.getDate();

      return `${month}-${day}`;
}
  },
  mounted() {
    this.setData();
    let BTCChart = echarts.init(document.getElementById('BTCChart'));
    BTCChart.setOption(this.chartOption);
  }
};
</script>

<style>
#BTCChart{
  width: 600px; 
  height:300px;
}
#swap-list{
  width: 600px; 
  height:410px;
  margin: 0px;
  border-radius: 10px;/* 盒子角变圆 */
  border: 3px solid rgb(42, 41, 41);
  box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  font-style:oblique; /* 让字体变得飘逸 */
  overflow: auto; /* 盒子满了可以自动滑动 */
}
  /* 自定义滑动条 */
  /* 定义滚动条的宽度 */
  ::-webkit-scrollbar {
    width: 7px;
  }
  /* 定义滚动条轨道的样式 */
  ::-webkit-scrollbar-track {
    background: #F7C001;
    border-radius: 10px; /* 设置滑块的圆角 */
    box-shadow: 0px 10px 20px rgba(78, 72, 68, 0.961);/* 盒子阴影 */
  }
  /* 定义滚动条的样式 */
  ::-webkit-scrollbar-thumb {
    background: #2a2626;
    border-radius: 5px; /* 设置滑块的圆角 */
  }
#swap-list-title{
  width: 500px;
  height:30px;
  margin-left: 30px;
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
  text-align: center;
}
#swap-list-info{
  width: 500px;
  height:25px;
  margin-left: 30px;
  border-radius: 10px;/* 盒子角变圆 */
  font-style:oblique; /* 让字体变得飘逸 */
  text-align: center;
}
</style>