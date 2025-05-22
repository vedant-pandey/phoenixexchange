// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// Bring in Phoenix channels client library:
import { Socket } from "phoenix"
import "./graph.js"

let socket = new Socket("/socket", { authToken: window.userToken })

socket.connect()

let channel = socket.channel("ohlc:feed", {initial_value: 1000.0, seed: 1234, volatility:0.1})
// let chartContainer = document.querySelector("#chart-container")
// let tableContainer = document.querySelector("#chart-table")

channel.on("tick", payload => {
  //   chartContainer.innerText = `
  // Open: ${payload.open}
  // High: ${payload.high}
  // Low: ${payload.low}
  // Close: ${payload.close}
  // Volume: ${payload.volume}
  // Timestamp: ${payload.timestamp}
  // `

  //   let row = document.createElement('tr')
  //     row.innerHTML = `
  // <tr>
  //   <td scope="row">${payload.open}</td>
  //   <td scope="row">${payload.high}</td>
  //   <td scope="row">${payload.low}</td>
  //   <td scope="row">${payload.close}</td>
  //   <td scope="row">${payload.volume}</td>
  //   <td scope="row">${payload.timestamp}</td>
  // </tr>
  // `
  //     tableContainer.appendChild(row)

  // document.body.append("lightweight-chart")
  // console.log(payload)
  const lwChart = document.querySelector('lightweight-chart')
  lwChart.addData({
    open: payload.open,
    high: payload.high,
    low: payload.low,
    close: payload.close,
    time: payload.timestamp,
  })
})

channel.join()
  .receive("ok", resp => {
    console.log("Joined successfully", resp)
  })
  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket
