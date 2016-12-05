defmodule RavioliShop.Repo.Migrations.AddScriptFileToJob do
  use Ecto.Migration

  def change do
    alter table(:jobs) do
      add :script_file, :string
    end
  end
end
