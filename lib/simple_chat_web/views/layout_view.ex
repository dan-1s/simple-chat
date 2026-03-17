defmodule SimpleChatWeb.LayoutView do
  use SimpleChatWeb, :view

  def vite_dev_server do
    Application.get_env(:simple_chat, :vite, [])
    |> Keyword.get(:dev_server)
  end

  def vite_dev?, do: is_binary(vite_dev_server())

  def vite_stylesheet_paths(entry) do
    if vite_dev?() do
      []
    else
      case vite_manifest_entry(entry) do
        nil ->
          [static_asset_path("assets/app.css")]

        manifest_entry ->
          manifest_entry
          |> Map.get("css", [])
          |> Enum.map(&static_asset_path/1)
      end
    end
  end

  def vite_javascript_path(entry) do
    if vite_dev?() do
      "#{vite_dev_server()}/#{entry}"
    else
      case vite_manifest_entry(entry) do
        nil -> static_asset_path(vite_fallback_javascript(entry))
        manifest_entry -> manifest_entry |> Map.fetch!("file") |> static_asset_path()
      end
    end
  end

  def vite_client_path do
    "#{vite_dev_server()}/@vite/client"
  end

  defp vite_manifest_entry(entry) do
    manifest_path = Application.app_dir(:simple_chat, "priv/static/.vite/manifest.json")

    if File.exists?(manifest_path) do
      manifest_path
      |> File.read!()
      |> Jason.decode!()
      |> Map.get(entry)
    end
  end

  defp static_asset_path(path), do: Routes.static_path(SimpleChatWeb.Endpoint, "/#{path}")

  defp vite_fallback_javascript("js/app.js"), do: "assets/app.js"
end
