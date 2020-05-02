defmodule SimpleChatWeb.UserChannel do
  use Phoenix.Channel

  def join("user:" <> id, _payload, socket) do
    if id === socket.assigns.id do
      send(self(), :after_join)
      {:ok, socket}
    else
      {:error, "Client <-> Server id miss match"}
    end
  end

  def handle_info(:after_join, %{assigns: %{username: username}} = socket) do
    broadcast!(socket, "username", %{username: username})

    {:noreply, socket}
  end
end
