defmodule RavioliCook.Job do
  defstruct id: nil, type: nil, input: nil, result: nil,
    script_file: nil, user_id: nil, divide_server_url: nil,
    division_type: nil, aggregation_type: nil

  def from_map(params) do
    %RavioliCook.Job{
      id: params["id"],
      type: params["type"],
      input: params["input"],
      result: params["result"],
      script_file: params["script_file"],
      user_id: params["user_id"],
      divide_server_url: params["divide_server_url"]
    }
  end
end
