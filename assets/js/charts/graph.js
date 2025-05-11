import  "../../vendor/lightweight-charts.js"

const {CandlestickSeries, createChart} = LightweightCharts

const elementStyles = `
    :host {
        display: block;
    }
    :host[hidden] {
        display: none;
    }
    .chart-container-2 {
        height: 100%;
        width: 100%;
    }
`;


// (function() {
//   class LightweightChartWC extends HTMLElement {
//     connectedCallback() {
//       const container = document.createElement('div');
//       container.setAttribute('class', 'chart-container-2');
//
//       const style = document.createElement('style');
//       style.textContent = elementStyles;
//       this.attachShadow({ mode: 'open' });
//       this.shadowRoot.append(style, container);
//
//       console.log("asdasd\n\n",CandlestickSeries)
//
//       const chartOptions = { layout: { textColor: 'black', background: { type: 'solid', color: 'white' } } };
//       const chart = createChart(container, chartOptions);
//       const candlestickSeries = chart.addSeries(CandlestickSeries, { upColor: '#26a69a', downColor: '#ef5350', borderVisible: false, wickUpColor: '#26a69a', wickDownColor: '#ef5350' });
//
//       const data = [{ open: 10, high: 10.63, low: 9.49, close: 9.55, time: 1642427876 }, { open: 9.55, high: 10.30, low: 9.42, close: 9.94, time: 1642514276 }, { open: 9.94, high: 10.17, low: 9.92, close: 9.78, time: 1642600676 }, { open: 9.78, high: 10.59, low: 9.18, close: 9.51, time: 1642687076 }, { open: 9.51, high: 10.46, low: 9.10, close: 10.17, time: 1642773476 }, { open: 10.17, high: 10.96, low: 10.16, close: 10.47, time: 1642859876 }, { open: 10.47, high: 11.39, low: 10.40, close: 10.81, time: 1642946276 }, { open: 10.81, high: 11.60, low: 10.30, close: 10.75, time: 1643032676 }, { open: 10.75, high: 11.60, low: 10.49, close: 10.93, time: 1643119076 }, { open: 10.93, high: 11.53, low: 10.76, close: 10.96, time: 1643205476 }];
//
//       candlestickSeries.setData(data);
//
//       chart.timeScale().fitContent();
//       // this.chart = LightweightCharts.createChart(container);
//     }
//
//     disconnectedCallback() { }
//   }
//
//   // Register our custom element with a specific tag name.
//   window.customElements.define('lightweight-chart', LightweightChartWC);
//
// })();

