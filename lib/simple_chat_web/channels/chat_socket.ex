defmodule SimpleChatWeb.ChatSocket do
  use Phoenix.Socket
  @one_day 86_400
  @signing_salt "chat-socket"

  ## Channels
  channel "chat:*", SimpleChatWeb.ChatChannel
  channel "user:*", SimpleChatWeb.UserChannel

  def connect(%{"token" => token}, socket, _connect_info) do
    case Phoenix.Token.verify(socket, @signing_salt, token, max_age: @one_day) do
      {:ok, %{id: id, username: username}} ->
        new_socket =
          socket
          |> assign(:id, id)
          |> assign(:username, username)

        {:ok, new_socket}

      {:error, _} ->
        :error
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     SimpleChatWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
