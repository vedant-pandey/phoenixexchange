defmodule PhoenixexchangeWeb.ChartChannel do
  require Logger
  use Phoenix.Channel
  alias Phoenix.PubSub

  @topic "ohlc:updates"

  def join("ohlc:feed", _payload, socket) do
    PubSub.subscribe(Phoenixexchange.PubSub, @topic)
    {:ok, socket}
  end

  def handle_info({:ohlc_tick, ohlc_data}, socket) do
    push(socket, "tick", ohlc_data)
    {:noreply, socket}
  end
end
