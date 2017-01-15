defmodule RavioliShop.ResultChannel do
  @moduledoc """
    Let us not worry about docs right now
  """

  use RavioliShop.Web, :channel

  alias RavioliShop.PiResultsServer
  alias RavioliShop.MultiplyResultsServer

  def join("result:*", _msg, socket) do
    {:ok, socket}
  end

  def handle_in("result", data, socket) do
    case data["type"] do
      "pi" ->
        %{"hit" => hit, "round" => round} = data["result"]
        PiResultsServer.add_result(hit, round)
      "matrix_by_rows" ->
        IO.puts "multiply"
        IO.inspect data
        MultiplyResultsServer.add_result_row(data["row"], data["result"])
      _ -> nil
    end
    # ResultsServer.add_result(hit, round, job_id)
    # push(socket, "calculate", %{})
    {:noreply, socket}
  end
end
