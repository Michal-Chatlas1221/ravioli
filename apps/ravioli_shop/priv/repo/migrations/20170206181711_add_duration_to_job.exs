defmodule RavioliShop.Repo.Migrations.AddDurationToJob do
  use Ecto.Migration

  def change do
    alter table(:jobs) do
      add :duration, :float
    end
  end
end
