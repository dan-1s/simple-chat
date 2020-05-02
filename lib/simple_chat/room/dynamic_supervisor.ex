defmodule SimpleChat.Room.DynamicSupervisor do
  use DynamicSupervisor
  alias SimpleChat.Room.Process
  @moduledoc false

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @doc """
  Join a room
  """
  def join(room) do
    child_spec = {Process, room}
    if Process.lookup(room) == nil, do: DynamicSupervisor.start_child(__MODULE__, child_spec)

    room
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
