# MyApp: Ash 3.0 Framework Demo Project

This project is a demonstration of the capabilities of the Ash Framework and its related libraries, showcasing how to build a feature-rich application using Ash 3.0. The project integrates various Ash extensions to provide a comprehensive overview of the framework's potential.

## Project Goals

- [x] To showcase the integration of Ash and its related libraries in a single project.
- [ ] To demonstrate the use of AshPostgres as the data layer.
- [ ] To implement authentication using AshAuthentication.
- [ ] To provide a web interface using AshPhoenix and AshAuthenticationPhoenix.
- [ ] To expose APIs using AshJsonAPI, including OpenAPI and Redoc documentation.
- [ ] To integrate GraphQL using AshGraphql.
- [ ] To utilize state machines with AshStateMachine.
- [ ] To implement audit trails using AshPaperTrail.
- [ ] To showcase an admin interface with AshAdmin.
- [ ] To demonstrate the use of financial calculations with AshMoney.
- [ ] To secure sensitive data using AshCloak.
- [ ] To generate slugs using AshSlug.
- [ ] To import and export data using AshCSV.

## Features

- **Ash Framework**: A powerful, flexible framework for building complex applications with ease.
- **AshPostgres**: PostgreSQL integration for Ash, providing a robust and scalable data layer.
- **AshAuthentication**: Comprehensive authentication solution for Ash applications.
- **AshPhoenix**: Integration with Phoenix, providing a web interface for your Ash application.
- **AshAuthenticationPhoenix**: Phoenix integration for AshAuthentication, enabling user authentication and management.
- **AshJsonAPI**: JSON:API implementation for Ash, providing standardized API endpoints.
- **AshGraphql**: GraphQL support for Ash, enabling flexible and efficient data querying.
- **AshStateMachine**: State machine implementation for Ash, useful for managing entity states and transitions.
- **AshPaperTrail**: Audit trail functionality for Ash, enabling tracking of changes to your data.
- **AshAdmin**: Admin interface for managing your Ash application.
- **AshMoney**: Financial calculations and currency management for Ash.
- **AshCloak**: Data encryption for sensitive information in Ash.
- **AshSlug**: Slug generation for Ash resources.
- **AshCSV**: CSV import/export functionality for Ash.

## Getting Started

### Prerequisites

- Elixir 1.13 or higher
- PostgreSQL

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/ash-demo-project.git
   cd ash-demo-project


# MyApp

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix



root@3ca943af95bc:/app# mix ash_phoenix.gen.live MyApp.Todos MyApp.Todos.TodoList --resource-plural todo_lists
Would you like to name your actor? For example: `current_user`. If you choose no, we will not add any actor logic. [Yn] y
What would you like to name it? Default: `current_user` 

* creating lib/my_app_web/live/todo_list_live/index.ex
* creating lib/my_app_web/live/todo_list_live/form_component.ex
* creating lib/my_app_web/live/todo_list_live/show.ex

Add the live routes to your browser scope in lib/my_app_web/router.ex:

    live "/todo_lists", TodoListLive.Index, :index
    live "/todo_lists/new", TodoListLive.Index, :new
    live "/todo_lists/:id/edit", TodoListLive.Index, :edit

    live "/todo_lists/:id", TodoListLive.Show, :show
    live "/todo_lists/:id/show/edit", TodoListLive.Show, :edit