defmodule Phoenixexchange.Exchange.Ticker do
  use GenServer
  alias Phoenix.PubSub

  @topic "ohlc:updates"
  @tick_interval 10000

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{price: 100.0}, name: __MODULE__)
  end

  def init(state) do
    schedule_tick()
    {:ok, state}
  end

  def handle_info(:tick, state) do
    new_ohlc = generate_ohlc(state.price)

    PubSub.broadcast(Phoenixexchange.PubSub, @topic, {:ohlc_tick, new_ohlc})

    schedule_tick()

    {:noreply, %{state | price: new_ohlc.close}}
  end

  defp schedule_tick do
    Process.send_after(self(), :tick, @tick_interval)
  end

  defp generate_ohlc(last_price) do
    factor = :rand.normal(0, 0.01)

    close = last_price * (1 + factor)

    open = last_price
    high = max(open, close) * (1 + :rand.uniform() * 0.005)
    low = min(open, close) * (1 - :rand.uniform() * 0.005)

    %{
      symbol: "STOCK",
      timestamp: DateTime.utc_now(),
      open: Float.round(open, 2),
      high: Float.round(high, 2),
      low: Float.round(low, 2),
      close: Float.round(close, 2),
      volume: :rand.uniform(10000)
    }
  end
end
