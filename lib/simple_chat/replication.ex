defmodule SimpleChat.Replication do
  @moduledoc """
  Module to replicate data across nodes
  """

  alias __MODULE__.{Server}

  defdelegate child_spec(opts), to: Server

  @doc """
  Sync data across nodes
  """
  def sync!(room, messages) do
    broadcast!({:sync, room, messages})
  end

  defp broadcast!(data) do
    server_pid()

    Phoenix.PubSub.broadcast_from!(
      SimpleChat.PubSub,
      server_pid(),
      "chat_message_replication",
      data
    )
  end

  defp server_pid(),
    do: Process.whereis(Server)
end
