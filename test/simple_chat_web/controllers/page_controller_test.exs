defmodule SimpleChatWeb.PageControllerTest do
  use SimpleChatWeb.ConnCase

  test "expose auth token to client", %{conn: conn} do
    conn = get(conn, "/")
    auth_token = conn.assigns.auth_token

    assert is_binary(auth_token) == true
    assert html_response(conn, 200) =~ "window.authToken=\"#{auth_token}\""
  end

  test "expose user id to client", %{conn: conn} do
    conn = get(conn, "/")
    user_id = conn.assigns.id

    assert is_binary(user_id) == true
    assert html_response(conn, 200) =~ "window.userId=\"#{user_id}\""
  end
end
