defmodule MyAppWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use MyAppWeb, :controller` and
  `use MyAppWeb, :live_view`.
  """
  use MyAppWeb, :html

  embed_templates "layouts/*"

  def layout_header(assigns)
  def layout_sidebar(assigns)
  def layout_footer(assigns)
end
