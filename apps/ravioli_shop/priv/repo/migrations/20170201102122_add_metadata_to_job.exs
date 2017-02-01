defmodule RavioliShop.Repo.Migrations.AddMetadataToJob do
  use Ecto.Migration

  def change do
    alter table(:jobs) do
      add :metadata, :string
    end
  end
end
