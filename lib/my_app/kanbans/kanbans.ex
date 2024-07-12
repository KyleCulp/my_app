defmodule MyApp.Kanbans do
  use Ash.Domain, extensions: [AshJsonApi.Domain], otp_app: :my_app

  resources do
    resource MyApp.Kanbans.Kanban
    resource MyApp.Kanbans.KanbanCollaborator
    resource MyApp.Kanbans.KanbanItem
    resource MyApp.Kanbans.KanbanView
    resource MyApp.Kanbans.KanbanStatus
    resource MyApp.Kanbans.KanbanPriority
    resource MyApp.Kanbans.KanbanSize
    resource MyApp.Kanbans.KanbanLabel
  end
end
