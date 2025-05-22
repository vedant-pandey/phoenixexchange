defmodule Phoenixexchange.Exchange.Ticker do
  use GenServer
  require Logger
  alias Phoenix.PubSub

  @topic "ohlc:updates"
  @tick_interval 1000
  # @api_key System.get_env("API_KEY") || raise " environment variable API_KEY is missing. "
  # @hostname System.get_env("PROVIDER_HOTSNAME") || raise " environment variable PROVIDER_HOTSNAME is missing. "

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{price: 100.0, timer: nil}, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_info(:tick, state) do
    new_ohlc = generate_ohlc(state.price)

    PubSub.broadcast(Phoenixexchange.PubSub, @topic, {:ohlc_tick, new_ohlc})

    timer = schedule_tick()

    {:noreply, %{state | price: new_ohlc.close, timer: timer}}
  end

  def handle_info({:tick, initial_price}, state) do
    if state.timer, do: Process.cancel_timer(state.timer)

    new_ohlc = generate_ohlc(state.price)

    PubSub.broadcast(Phoenixexchange.PubSub, @topic, {:ohlc_tick, new_ohlc})

    timer = schedule_tick()

    {:noreply, %{state | price: initial_price, timer: timer}}
  end

  def handle_info({:tick, initial_price, seed, volatility}, state) do
    Logger.debug("Initial price #{initial_price} | seed #{seed} | volatility #{volatility}")
    {:noreply, state}
  end

  def handle_info(_, state) do
    Logger.debug("no op")
    Logger.debug(IEx.Info.info(state))
    Logger.debug(state)
    {:noreply, state}
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
      timestamp: DateTime.utc_now() |> DateTime.to_unix(:millisecond),
      open: Float.round(open, 2),
      high: Float.round(high, 2),
      low: Float.round(low, 2),
      close: Float.round(close, 2),
      volume: :rand.uniform(10000)
    }
  end

end
