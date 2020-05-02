defmodule SimpleChatWeb.PageController do
  use SimpleChatWeb, :controller
  require Logger

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create(conn, %{"username" => username}) do
    case validate_user(username) do
      {:ok, username} ->
        id = get_session(conn, :id)

        conn
        |> put_session(:user_name, username)
        |> refresh_user(id)
        |> redirect(to: "/")

      {:error, reason} ->
        Logger.error("Invalid user name :" <> inspect(reason))

        conn |> redirect(to: "/")
    end
  end

  def kill(conn, _params) do
    old_id = get_session(conn, :id)

    conn
    |> clear_session()
    |> refresh_user(old_id)
    |> redirect(to: "/")
  end

  defp validate_user(username) do
    trimmed_name = String.trim(username)

    trimmed_name
    |> String.length()
    |> validate_user(trimmed_name)
  end

  defp validate_user(len, _) when len < 2, do: {:error, "At least 2 characters"}
  defp validate_user(len, _) when len > 20, do: {:error, "At most 20 characters"}

  defp validate_user(_, trimmed_name) do
    re = ~r/([a-zA-Z0-9åäöÅÄÖ]+\s)*[a-zA-Z0-9åäöÅÄÖ]+$/

    if Regex.match?(re, trimmed_name) == true,
      do: {:ok, trimmed_name},
      else: {:error, "Illegal characters"}
  end

  defp refresh_user(conn, id) do
    SimpleChatWeb.Endpoint.broadcast!("user:" <> id, "refresh", %{})
    conn
  end
end
