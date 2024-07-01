defmodule MyApp.Accounts.Changes.SaveOAuthInfo do
  @moduledoc """
  Updates the identity resource with strategy-specific information when a user is registered.
  """
  use Ash.Resource.Change
  alias Hex.API.User
  alias AshAuthentication.{Info, Strategy, UserIdentity}
  alias Ash.{Changeset, Error.Framework.AssumptionFailed, Resource.Change}
  import AshAuthentication.Utils, only: [is_falsy: 1]

  # transform and validate opts
  @impl true
  def init(opts) do
    if is_atom(opts[:attribute]),
      do: {:ok, opts},
      else: {:error, "attribute must be an atom!"}
  end

  def prepare(query, opts, context) do
    IO.inspect("QUERY: ")
    IO.inspect(query)
    IO.inspect("OPTS: ")
    IO.inspect(opts)
    IO.inspect("CONTEXT: ")
    IO.inspect(context)
    query
  end

  @impl true
  def change(changeset, opts, context) do
    case Info.strategy_for_action(changeset.resource, changeset.action.name) do
      {:ok, strategy} ->
        do_change(changeset, strategy)

      :error ->
        {:error,
         AssumptionFailed.exception(
           message: "Action does not correlate with an authentication strategy"
         )}
    end
  end

  defp do_change(changeset, strategy) when is_falsy(strategy.identity_resource), do: changeset

  defp do_change(changeset, strategy) do
    case strategy.name do
      :github -> github(changeset, strategy)
      :google -> google(changeset, strategy)
      :microsoft -> microsoft(changeset, strategy)
      :discord -> discord(changeset, strategy)
      :apple -> apple(changeset, strategy)
      :steam -> steam(changeset, strategy)
      _ -> changeset
    end
  end

  defp github(changeset, strategy) do
    user_info = Ash.Changeset.get_argument(changeset, :user_info)

    # IO.inspect(user_info)
    changeset
  end

  defp google(changeset, strategy) do
    google =
      Ash.Changeset.get_argument(changeset, :user_info)
      |> string_keys_to_atom_keys()

    changeset
    |> Ash.Changeset.change_attributes(%{google: struct!(MyApp.Accounts.Google, google)})
  end

  defp microsoft(changeset, strategy) do
  end

  defp discord(changeset, strategy) do
  end

  defp apple(changeset, strategy) do
  end

  defp steam(changeset, strategy) do
  end

  def string_keys_to_atom_keys(map) when is_map(map) do
    Enum.reduce(map, %{}, fn {key, value}, acc ->
      atom_key = String.to_existing_atom(key)
      Map.put(acc, atom_key, value)
    end)
  end
end
