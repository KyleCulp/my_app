defmodule MyAppWeb.V1.QueryParams do
  defstruct page: %Ash.Page.Keyset{limit: 10},
            sort: %{created_at: :asc},
            filters: %{},
            include: "",
            fields: ""

  @type t :: %__MODULE__{
          page: Ash.Page.Keyset.t() | Ash.Page.Offset.t(),
          sort: String.t(),
          filters: map,
          include: String.t(),
          fields: String.t()
        }

  # @page_defaults %Ash.Page.Offset{
  #   offset: 0,
  #   limit: 10,
  #   count: true
  # }

  # @page_defaults %{
  #   "limit" => 10
  # }

  @spec new(map) :: {:ok, t} | {:error, String.t()}
  def new(params) do
    #
    #  {:ok, order} <- validate_order(Map.get(params, "order", "asc"), :order)
    with {:ok, page} <- parse_page(Map.get(params, "page")),
         {:ok, sort} <- validate_sort(Map.get(params, "sort")) do
      # filters =
      #   Map.drop(params, ["page", "limit", "sort", "order", "include", "fields"])

      # include = Map.get(params, "include", "")
      # fields = Map.get(params, "fields", "")

      {:ok,
       %__MODULE__{
         page: page,
         sort: sort
         #  order: order,
         #  filters: filters,
         #  include: include,
         #  fields: fields
       }}
    else
      {:error, error_msg} -> {:error, error_msg}
    end
  end

  def parse_page(params) when is_map(params) do
    params
    |> Enum.map(fn {key, value} -> {String.downcase(key) |> String.to_existing_atom(), value} end)
    |> Enum.into(%{})
    |> validate_page()
  end

  defp validate_page(params) do
    keyset_keys = [:after, :before]
    offset_keys = [:offset]

    cond do
      Enum.any?(params, fn {key, _} -> key in keyset_keys end) ->
        {:ok, struct(Ash.Page.Keyset, params)}

      Enum.any?(params, fn {key, _} -> key in offset_keys end) ->
        {:ok, struct(Ash.Page.Offset, params)}

      true ->
        # Return the params as is if it doesn't match either struct criteria
        {:ok, params}
    end
  end

  def convert_keys_to_existing_atoms(map) when is_map(map) do
    map
    |> Enum.map(fn {key, value} -> {String.downcase(key) |> String.to_existing_atom(), value} end)
    |> Enum.into(%{})
  end

  defp parse_integer(value, param) do
    case Integer.parse(value) do
      {int, ""} -> {:ok, int}
      _ -> {:error, "#{param}: Invalid integer value #{value}"}
    end
  end

  defp validate_sort(value) do
    # Add your valid sort fields here
    # valid_sort_fields = ["id", "name", "created_at"]
    IO.inspect(value)
    {:ok, value}

    # if value in valid_sort_fields do
    #   {:ok, value}
    # else
    #   {:error, "Invalid sort field"}
    # end
  end

  defp validate_order(value, param) do
    case value do
      "asc" -> {:ok, "asc"}
      "desc" -> {:ok, "desc"}
      _ -> {:error, "Invalid order value"}
    end
  end
end

# defp extract_params(params) do
#   page = Map.get(params, "page", "1")
#   limit = Map.get(params, "limit", "10")
#   sort = Map.get(params, "sort", "id")
#   order = Map.get(params, "order", "asc")
#   filters = Map.drop(params, ["page", "limit", "sort", "order", "include", "fields"])
#   include = Map.get(params, "include", "")
#   fields = Map.get(params, "fields", "")
#   {page, limit, sort, order, filters, include, fields}
# end
