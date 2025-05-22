defmodule PhoenixexchangeWeb.ChartChannel do
  require Logger
  use Phoenix.Channel
  alias Phoenix.PubSub

  @topic "ohlc:updates"

  def join("ohlc:feed", payload, socket) do
    Logger.debug(payload)
    PubSub.subscribe(Phoenixexchange.PubSub, @topic)
    Process.send(Phoenixexchange.Exchange.Ticker, {:tick, 1000.0}, [])
    Process.send(Phoenixexchange.Exchange.Ticker, {:tick, payload["initial_value"], payload["seed"], payload["volatility"]}, [])
    {:ok, socket}
  end

  def handle_info({:ohlc_tick, ohlc_data}, socket) do
    push(socket, "tick", ohlc_data)
    {:noreply, socket}
  end

  def handle_info(_, socket) do
    {:noreply, socket}
  end
end
