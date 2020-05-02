defmodule SimpleChatWeb.Plugs.NodeInfo do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    assign(conn, :node, get_node_string())
  end

  defp get_node_string(), do: Node.self() |> Atom.to_string()
end
