defmodule Phoenixexchange.Exchange.Ticker do
  use GenServer
  require Logger
  alias Phoenix.PubSub

  @topic "ohlc:updates"
  @tick_interval 1000

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{price: 100.0, timer: nil}, name: __MODULE__)
  end

  def init(state) do
    # timer = schedule_tick()
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

  defp geometric_brownian_motion(seed, initial_price, volatility, drift) do
    :rand.seed(:exsss, {seed, seed * 2, seed * 3})

    Enum.reduce([initial_price], fn acc ->
      last_price = hd(acc)
      random_factor = :rand.normal(0, 1)
      new_price = last_price * :math.exp(drift - 0.5 * volatility + volatility * random_factor)
      [new_price | acc]
    end)
    |> Enum.reverse()
  end

  defp generate_ohlc_from_close(yesterday_close, today_close, volatility, seed_offset) do
    # Add randomness based on seed offset to avoid pattern repetition
    local_seed = seed_offset * 10000
    :rand.seed(:exsss, {local_seed, local_seed * 2, local_seed * 3})

    # Determine daily range based on volatility
    daily_range = today_close * volatility * (0.5 + :rand.uniform())

    # Open typically gaps from previous close
    open_change = today_close * volatility * 0.2 * :rand.normal(0, 1)
    open = yesterday_close + open_change

    # High and low based on range
    high = max(open, today_close) + daily_range * :rand.uniform() * 0.5
    low = min(open, today_close) - daily_range * :rand.uniform() * 0.5

    # Volume correlates with volatility
    volume = round(1000 * (1.0 + abs(today_close - yesterday_close) / yesterday_close * 20))

    %{
      open: Float.round(open, 2),
      high: Float.round(high, 2),
      low: Float.round(low, 2),
      close: Float.round(today_close, 2),
      volume: volume
    }
  end
end
