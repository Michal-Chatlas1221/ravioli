defmodule RavioliShop.Repo.Migrations.AddNameAndDescriptionToJob do
  use Ecto.Migration

  def change do
    alter table(:jobs) do
      add :name, :string
      add :description, :text
    end
  end
end
