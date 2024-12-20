<template>
  <view class="u-charts-container" :style="{ height: height }">
    <canvas 
      v-if="canvasId"
      :id="canvasId"
      :canvas-id="canvasId"
      class="u-charts-canvas"
      @touchstart="touchStart"
      @touchmove="touchMove"
      @touchend="touchEnd"
    />
  </view>
</template>

<script>
import uCharts from '@qiun/ucharts'
import { ref, onMounted, watch } from 'vue'

export default {
  name: 'UCharts',
  props: {
    type: {
      type: String,
      default: 'line'
    },
    canvasId: {
      type: String,
      required: true
    },
    chartData: {
      type: Object,
      required: true
    },
    opts: {
      type: Object,
      default: () => ({})
    },
    height: {
      type: String,
      default: '300px'
    }
  },
  setup(props) {
    const chartRef = ref(null)

    function initChart() {
      const ctx = uni.createCanvasContext(props.canvasId)
      chartRef.value = new uCharts({
        type: props.type,
        context: ctx,
        width: uni.upx2px(750),
        height: uni.upx2px(300),
        categories: props.chartData.categories || [],
        series: props.chartData.series || [],
        animation: true,
        background: '#FFFFFF',
        padding: [15, 15, 0, 15],
        ...props.opts
      })
    }

    watch(() => props.chartData, () => {
      if (chartRef.value) {
        chartRef.value.updateData({
          categories: props.chartData.categories || [],
          series: props.chartData.series || []
        })
      }
    }, { deep: true })

    onMounted(() => {
      initChart()
    })

    function touchStart(e) {
      chartRef.value && chartRef.value.touchStart(e)
    }

    function touchMove(e) {
      chartRef.value && chartRef.value.touchMove(e)
    }

    function touchEnd(e) {
      chartRef.value && chartRef.value.touchEnd(e)
    }

    return {
      touchStart,
      touchMove,
      touchEnd
    }
  }
}
</script>

<style>
.u-charts-container {
  width: 100%;
  position: relative;
}

.u-charts-canvas {
  width: 100%;
  height: 100%;
  position: absolute;
}
</style>
