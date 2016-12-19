defmodule RavioliShop.Repo.Migrations.AddDivideServerUrlToJob do
  use Ecto.Migration

  def change do
    alter table(:jobs) do
      add :divide_server_url, :string
    end
  end
end
