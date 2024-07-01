defmodule MyAppWeb.NavbarUserMenuLive do
  use MyAppWeb, :live_view

  alias Phoenix.PubSub
  alias MyApp.PubSub

  def mount(_params, %{"current_user_id" => current_user_id}, socket) do
    user = MyApp.Accounts.User |> Ash.get!(current_user_id, load: [:display_name])

    if connected?(socket) do
      # PubSub.subscribe(PubSub, "notifications:#{current_user_id}")
      socket =
        socket
        |> assign(
          notifications: [],
          current_user_id: current_user_id,
          current_user: user
        )

      # user = MyApp.Accounts.User |> Ash.get!("2d9b2e0e-d9f4-49aa-86d6-3c890283a7b3", load: [:display_name])
      {:ok, socket, layout: false}
    else
      {:ok,
       assign(socket, notifications: [], current_user_id: current_user_id, current_user: user),
       layout: false}
    end
  end

  def handle_info({:new_notification, notification}, socket) do
    {:noreply, update(socket, :notifications, &[notification | &1])}
  end

  def render(assigns) do
    ~H"""
    <button
      type="button"
      class="flex text-sm bg-gray-800 rounded-full md:me-0 focus:ring-4 focus:ring-gray-300 dark:focus:ring-gray-600"
      id="user-menu-button"
      aria-expanded="false"
      data-dropdown-toggle="user-dropdown"
      data-dropdown-placement="bottom"
    >
      <span class="sr-only">Open user menu</span>
      <img class="w-8 h-8 rounded-full bg-white" src="/images/logo.svg" alt="user photo" />
    </button>
    <!-- Dropdown menu -->
    <div
      class="z-50 hidden my-4 text-base list-none bg-white divide-y divide-gray-100 rounded-lg shadow dark:bg-gray-700 dark:divide-gray-600"
      id="user-dropdown"
    >
      <div class="px-4 py-3">
        <span class="block text-sm text-gray-900 dark:text-white">
          <%= @current_user.display_name %>
        </span>
        <span class="block text-sm  text-gray-500 truncate dark:text-gray-400">
          <%= @current_user.email %>
        </span>
      </div>
      <ul class="py-2" aria-labelledby="user-menu-button">
        <li>
          <a
            href="#"
            class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:hover:bg-gray-600 dark:text-gray-200 dark:hover:text-white"
          >
            Dashboard
          </a>
        </li>
        <li>
          <a
            href="#"
            class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:hover:bg-gray-600 dark:text-gray-200 dark:hover:text-white"
          >
            Settings
          </a>
        </li>
        <li>
          <.link
            href="/sign-out"
            class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:hover:bg-gray-600 dark:text-gray-200 dark:hover:text-white"
          >
            Sign out
          </.link>
        </li>
      </ul>
    </div>
    """
  end
end
