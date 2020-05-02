defmodule SimpleChatWeb.ChatChannel do
  use Phoenix.Channel
  alias SimpleChat.{Room, Replication}

  def join("chat:" <> room, _payload, socket) do
    send(self(), {:after_join, room})

    {:ok, socket}
  end

  def handle_info({:after_join, room}, socket) do
    room
    |> Room.join()
    |> Room.get_messages()
    |> broadcast_messages(socket)

    push(socket, "room", %{room: room})
    {:noreply, socket}
  end

  def handle_in(
        "chat:" <> room,
        %{"msg" => msg},
        %{assigns: %{username: user}} = socket
      ) do
    msg_data = %{room: room, user: user, msg: msg}
    messages = Room.new_message(msg_data)

    broadcast_messages(messages, socket)
    Replication.sync!(room, messages)

    {:noreply, socket}
  end

  defp broadcast_messages([], socket), do: socket

  defp broadcast_messages(messages, socket) do
    # New messages are prepended so we need to reverse the list
    broadcast!(socket, "msg", %{conversation: messages |> Enum.reverse()})
  end
end
