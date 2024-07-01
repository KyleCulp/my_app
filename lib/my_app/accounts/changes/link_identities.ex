defmodule MyApp.Accounts.Changes.LinkIdentities do
  use Ash.Resource.Change

  # transform and validate opts
  @impl true
  def init(opts) do
    if is_atom(opts[:attribute]) do
      {:ok, opts}
    else
      {:error, "attribute must be an atom!"}
    end
  end

  @impl true
  def change(changeset, opts, _context) do
    # case Ash.Changeset.fetch_change(changeset, opts[:attribute]) do
    #   {:ok, new_value} ->
    #     slug = String.replace(new_value, ~r/\s+/, "-")
    #     Ash.Changeset.force_change_attribute(changeset, opts[:attribute], slug)

    #   :error ->
    #     changeset
    # end
    IO.inspect(changeset)
    IO.inspect(opts)
    changeset
  end
end
