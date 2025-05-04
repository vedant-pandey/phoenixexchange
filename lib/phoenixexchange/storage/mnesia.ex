defmodule Phoenixexchange.Storage.Mnesia do
  def setup do
    File.mkdir_p!(Application.get_env(:mnesia, :dir))

    :mnesia.stop()
    :mnesia.create_schema([node()])
    :mnesia.start()

    create_tables()

    :ok
  end
  
  defp create_tables do
    :mnesia.create_table(
      Phoenixexchange.User,
      [
        attributes: [:id, :username, :email],
        disc_copies: [node()],
        type: :set
      ]
    )

    :mnesia.wait_for_tables([Phoenixexchange.User], 5000)
  end
end
