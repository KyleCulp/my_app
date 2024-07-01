defmodule MyApp.Secrets do
  use AshAuthentication.Secret

  def secret_for([:authentication, :tokens, :signing_secret], MyApp.Accounts.User, _) do
    case Application.fetch_env(:my_app, MyAppWeb.Endpoint) do
      {:ok, endpoint_config} ->
        Keyword.fetch(endpoint_config, :secret_key_base)

      :error ->
        :error
    end
  end

  def secret_for([:authentication, :strategies, :github, :client_id], MyApp.Accounts.User, _),
    do: get_config(:github, :client_id)

  def secret_for([:authentication, :strategies, :github, :redirect_uri], MyApp.Accounts.User, _),
    do: get_config(:github, :redirect_uri)

  def secret_for([:authentication, :strategies, :github, :client_secret], MyApp.Accounts.User, _),
    do: get_config(:github, :client_secret)

  def secret_for([:authentication, :strategies, :google, :client_id], MyApp.Accounts.User, _),
    do: get_config(:google, :client_id)

  def secret_for([:authentication, :strategies, :google, :redirect_uri], MyApp.Accounts.User, _),
    do: get_config(:google, :redirect_uri)

  def secret_for([:authentication, :strategies, :google, :client_secret], MyApp.Accounts.User, _),
    do: get_config(:google, :client_secret)

  defp get_config(key) do
    :my_app
    |> Application.get_env([])
    |> Keyword.fetch(key)
  end

  defp get_config(strategy, key) do
    :my_app
    |> Application.get_env(strategy, [])
    |> Keyword.fetch(key)
  end
end
