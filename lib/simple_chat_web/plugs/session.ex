defmodule SimpleChatWeb.Plugs.Session do
  @moduledoc false

  @behaviour Plug

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts) do
    session_options()
    |> Plug.Session.init()
    |> then(&Plug.Session.call(conn, &1))
  end

  defp session_options do
    :simple_chat
    |> Application.get_env(:session_options, [])
    |> Keyword.put_new(:store, :cookie)
    |> Keyword.put_new(:key, "_simple_chat_key")
    |> Keyword.put_new(:signing_salt, "H1SmjnNy")
  end
end
