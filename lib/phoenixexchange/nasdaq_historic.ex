defmodule Phoenixexchange.NasdaqHistoric do
  use Ecto.Schema
  import Ecto.Changeset

  schema "nasdaq_historic" do
    field :close, :decimal
    field :high, :decimal
    field :low, :decimal
    field :open, :decimal
    field :date, :integer
    field :adjclose, :decimal
    field :volume, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(nasdaq_historic, attrs) do
    nasdaq_historic
    |> cast(attrs, [:date, :open, :high, :low, :close, :adjclose, :volume])
    |> validate_required([:date, :open, :high, :low, :close, :adjclose, :volume])
  end
end
