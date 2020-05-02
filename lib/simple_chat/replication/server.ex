defmodule SimpleChat.Replication.Server do
  use GenServer
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    Phoenix.PubSub.subscribe(SimpleChat.PubSub, "chat_message_replication")
    {:ok, nil}
  end

  @impl true
  def handle_info({:sync, room, messages}, state) do
    node = Node.self() |> Atom.to_string()
    Logger.info("SYNCING to " <> node)

    SimpleChat.Room.set_messages(room, messages)
    {:noreply, state}
  end
end
