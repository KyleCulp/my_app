defmodule MyApp.Redis do
  use GenServer

  @redis_conn :redis_conn

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:ok, conn} = Redix.start_link(host: redis_host(), port: redis_port(), name: @redis_conn)
    {:ok, conn}
  end

  defp redis_host do
    Application.get_env(:my_app, MyApp.Redis)[:host]
  end

  defp redis_port do
    Application.get_env(:my_app, MyApp.Redis)[:port]
  end

  def command(command) do
    Redix.command(@redis_conn, command)
  end

  def command!(command) do
    Redix.command!(@redis_conn, command)
  end
end
