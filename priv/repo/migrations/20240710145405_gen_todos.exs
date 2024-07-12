defmodule MyApp.Repo.Migrations.GenTodos do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:todo_lists, primary_key: false) do
      add(:id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true)
      add(:title, :text, null: false)
      add(:description, :text)

      add(:created_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")
      )

      add(:updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")
      )

      add(
        :user_id,
        references(:users,
          column: :id,
          name: "todo_lists_user_id_fkey",
          type: :uuid,
          prefix: "public"
        ),
        null: false
      )
    end

    create table(:todo_items, primary_key: false) do
      add(:id, :uuid, null: false, default: fragment("gen_random_uuid()"), primary_key: true)
      add(:text, :text, null: false)
      add(:completed, :boolean, default: false)

      add(:created_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")
      )

      add(:updated_at, :utc_datetime_usec,
        null: false,
        default: fragment("(now() AT TIME ZONE 'utc')")
      )

      add(
        :todo_list_id,
        references(:todo_lists,
          column: :id,
          name: "todo_items_todo_list_id_fkey",
          type: :uuid,
          prefix: "public"
        ),
        null: false
      )
    end
  end

  def down do
    drop(constraint(:todo_items, "todo_items_todo_list_id_fkey"))

    drop(table(:todo_items))

    drop(constraint(:todo_lists, "todo_lists_user_id_fkey"))

    drop(table(:todo_lists))
  end
end