defmodule SimpleChatWeb.Plugs.Auth do
  import Plug.Conn
  @signing_salt "chat-socket"

  def init(opts), do: opts

  def call(conn, _opts) do
    id = get_session(conn, :id)

    conn
    |> add_to_session(id)
    |> put_user_id()
  end

  defp add_to_session(conn, nil), do: put_session(conn, :id, generate_id())
  defp add_to_session(conn, _id), do: conn

  defp put_user_id(conn) do
    id = get_session(conn, :id)
    user_name = get_session(conn, :user_name)

    token = Phoenix.Token.sign(conn, @signing_salt, %{username: user_name, id: id})

    conn
    |> assign(:id, id)
    |> assign(:auth_token, token)
  end

  defp generate_id() do
    UUID.uuid4(:hex)
  end
end
