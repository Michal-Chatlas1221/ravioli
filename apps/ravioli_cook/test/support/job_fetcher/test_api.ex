defmodule RavioliCook.JobFetcher.TestApi do
  def jobs do
    %{body: [
      %{
        "id" => "id",
        "script" => "script"
      }
    ]}
  end
end
