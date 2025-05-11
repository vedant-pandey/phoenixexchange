defmodule PhoenixexchangeWeb.ChartSocket do
  require Logger
  use Phoenix.Socket

  channel "ohlc:*", PhoenixexchangeWeb.ChartChannel

  @impl true
  def connect(_params, socket, connect_info) do
    case Phoenix.Token.verify(socket, "user socket", connect_info[:auth_token], max_age: 1_209_600) do
      {:ok, user_id} -> {:ok, assign(socket, :current_user, user_id)}
      {:error, _reason} -> {:ok, assign(socket, :current_user, "nobody")}
    end
  end

  @impl true
  def id(_socket), do: nil
end
