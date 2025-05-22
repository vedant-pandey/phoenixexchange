import "../../vendor/lightweight-charts.js"

const { CandlestickSeries, createChart } = LightweightCharts

const elementStyles = `
    :host {
        display: block;
        height: 100%;
    }
    :host[hidden] {
        display: none;
    }
    .chart-inner-container {
        height: 100%;
        width: 100%;
    }
`;


(function() {
    class LightweightChartWC extends HTMLElement {
        connectedCallback() {
            const container = document.createElement('div');
            container.setAttribute('class', 'chart-inner-container');

            const style = document.createElement('style');
            style.textContent = elementStyles;
            this.attachShadow({ mode: 'open' });
            this.shadowRoot.append(style, container);


            this.chart = createChart(container, {
                layout: {
                    textColor: 'black', background: {
                        type: 'solid',
                        color: 'white'
                    }
                }
            });
            this.candlestickSeries = this.chart.addSeries(CandlestickSeries, { upColor: '#26a69a', downColor: '#ef5350', borderVisible: false, wickUpColor: '#26a69a', wickDownColor: '#ef5350' });

            this.data = [];

            this.candlestickSeries.setData(this.data);

            this.chart.timeScale().fitContent();
        }

        disconnectedCallback() { }

        addData(data) {
            this.candlestickSeries.update(data)
        }
    }

    // Register our custom element with a specific tag name.
    window.customElements.define('lightweight-chart', LightweightChartWC);

})();

