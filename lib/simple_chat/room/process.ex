defmodule SimpleChat.Room.Process do
  use GenServer
  require Logger
  alias SimpleChat.Room.DynamicSupervisor

  def start_link(room) do
    initial_state = []
    GenServer.start_link(__MODULE__, initial_state, name: via_tuple(room))
  end

  @doc """
  Add new message to room
  """
  def new_message(%{room: room, msg: msg, user: user}) do
    room
    |> lookup
    |> call({:new, msg, user})
  end

  @doc """
  Get messages from room
  """
  def get_messages(room) do
    room
    |> lookup
    |> call(:get_messages)
  end

  @doc """
  Set messages in room
  """
  def set_messages(room, messages) do
    case lookup(room) do
      nil -> DynamicSupervisor.join(room) |> lookup() |> call({:set_messages, messages})
      pid -> call(pid, {:set_messages, messages})
    end
  end

  @doc """
  Find process id by room name
  """
  def lookup(room) do
    case Registry.lookup(RoomRegistry, room) do
      [{pid, _}] -> pid
      _ -> nil
    end
  end

  defp call(pid, payload), do: GenServer.call(pid, payload)

  defp via_tuple(room) do
    {:via, Registry, {RoomRegistry, room}}
  end

  @impl true
  def init(initial_state), do: {:ok, initial_state}

  @impl true
  def handle_call(:get_messages, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:new, msg, user}, _from, current_messages) do
    now = DateTime.utc_now()
    unix_ms = DateTime.to_unix(now, :millisecond)

    next_messages = [
      %{
        id: UUID.uuid4(),
        user: user,
        msg: msg,
        timestamp: unix_ms
      }
      | current_messages
    ]

    {:reply, next_messages, next_messages}
  end

  @impl true
  def handle_call({:set_messages, messages}, _from, current_messages) do
    next_messages =
      MapSet.union(MapSet.new(messages), MapSet.new(current_messages))
      |> MapSet.to_list()
      |> Enum.sort(&(&1.timestamp >= &2.timestamp))

    {:reply, next_messages, next_messages}
  end
end
