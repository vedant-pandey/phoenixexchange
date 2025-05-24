// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// Bring in Phoenix channels client library:
import { Socket } from "phoenix"
import "./graph.js"

let socket = new Socket("/socket", { authToken: window.userToken })

socket.connect()

let channel = socket.channel("ohlc:feed", {initial_value: 1000.0, seed: 1234, volatility:0.1})

channel.on("tick", payload => {
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
