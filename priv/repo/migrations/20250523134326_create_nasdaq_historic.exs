defmodule Phoenixexchange.Repo.Migrations.CreateNasdaqHistoric do
  use Ecto.Migration

  def change do
    create table(:nasdaq_historic) do
      add :date, :integer
      add :open, :decimal
      add :high, :decimal
      add :low, :decimal
      add :close, :decimal
      add :adjclose, :decimal
      add :volume, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
