defmodule MyApp.Accounts.Calculations.DisplayName do
  # An example concatenation calculation, that accepts the delimiter as an argument,
  # and the fields to concatenate as options
  use Ash.Resource.Calculation

  def calculate(records, _, _) do
    Enum.map(records, &get_display_name/1)
  end

  defp get_display_name(%{google: %{name: google_name}}) when not is_nil(google_name) do
    google_name
  end

  defp get_display_name(%{github: %{name: github_name}}) when not is_nil(github_name) do
    github_name
  end

  defp get_display_name(%{email: email}), do: email

  # Optional callback that verifies the passed in options (and optionally transforms them)
  # @impl true
  # def init(opts) do
  #   if opts[:keys] && is_list(opts[:keys]) && Enum.all?(opts[:keys], &is_atom/1) do
  #     {:ok, opts}
  #   else
  #     {:error, "Expected a `keys` option for which keys to concat"}
  #   end
  # end

  # @impl true
  # # A callback to tell Ash what keys must be loaded/selected when running this calculation
  # # you can include related data here, but be sure to include the attributes you need from said related data
  # # i.e `posts: [:title, :body]`.
  # def load(_query, opts, _context) do
  #   opts[:keys]
  # end

  # @impl true
  # def calculate(records, opts, args) do
  #   IO.inspect(records)
  #   IO.inspect(opts)
  #   IO.inspect(args)

  #   Enum.map(records, fn record ->
  #     Enum.map_join(opts[:keys], args.separator, fn key ->
  #       to_string(Map.get(record, key))
  #     end)
  #   end)
  # end

  # # You can implement this callback to make this calculation possible in the data layer
  # # *and* in elixir. Ash expressions are already executable in Elixir or in the data layer, but this gives you fine grain control over how it is done
  # @impl true
  # def expression(opts, context) do
  #   IO.inspect(opts)
  #   IO.inspect(context)
  # end
end
