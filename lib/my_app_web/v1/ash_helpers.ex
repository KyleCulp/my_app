defmodule MyAppWeb.V1.AshHelpers do
  def resource_to_json(data, attributes) do
    %{
      id: data.id,
      attributes: extract_keys(data, attributes),
      relationships: %{},
      type: "string"
    }
  end

  defp extract_keys(map, keys) do
    keys
    |> Enum.reduce(%{}, fn key, acc ->
      if Map.has_key?(map, key) do
        Map.put(acc, key, Map.get(map, key))
      else
        acc
      end
    end)
  end
end
