defmodule Phoenixexchange.Exchange.Ticker do
  use GenServer
  require Logger
  import Ecto.Query
  alias Phoenix.PubSub
  alias Phoenixexchange.Repo
  alias Phoenixexchange.NasdaqHistoric

  @topic "ohlc:updates"
  @tick_interval 1000

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{price: 100.0, timer: nil, price_id: 1}, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_info(:tick, state) do
    new_ohlc = generate_ohlc(state.price_id)

    PubSub.broadcast(Phoenixexchange.PubSub, @topic, {:ohlc_tick, new_ohlc})

    timer = schedule_tick()

    {:noreply, %{state | price: new_ohlc.close, timer: timer, price_id: state.price_id + 1}}
  end

  def handle_info({:tick, initial_price}, state) do
    if state.timer, do: Process.cancel_timer(state.timer)

    new_ohlc = generate_ohlc(state.price_id)

    PubSub.broadcast(Phoenixexchange.PubSub, @topic, {:ohlc_tick, new_ohlc})

    timer = schedule_tick()

    {:noreply, %{state | price: initial_price, timer: timer, price_id: state.price_id + 1}}
  end

  # def handle_info({:tick, initial_price, seed, volatility}, state) do
  #   Logger.debug("Initial price #{initial_price} | seed #{seed} | volatility #{volatility}")
  #   {:noreply, state}
  # end

  def handle_info(_, state) do
    Logger.debug("no op")
    {:noreply, state}
  end

  defp schedule_tick do
    Process.send_after(self(), :tick, @tick_interval)
  end

  defp generate_ohlc(price_id) do

    val = Repo.one(from d in NasdaqHistoric, where: d.id == ^price_id)
    # val = Repo.one(from d in NasdaqHistoric, where: d.id == 1)
    Logger.debug(val)

    %{
      symbol: "STOCK",
      timestamp: val.date,
      open: Decimal.to_float(val.open),
      high: Decimal.to_float(val.high),
      low: Decimal.to_float(val.low),
      close: Decimal.to_float(val.close),
      volume: val.volume
    }
  end

end
