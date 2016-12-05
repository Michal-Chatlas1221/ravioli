defmodule RavioliShop.ResultChannel do
  @moduledoc """
    Let us not worry about docs right now
  """

  use RavioliShop.Web, :channel

  alias RavioliShop.PiResultsServer

  def join("result:*", _msg, socket) do
    {:ok, socket}
  end

  def handle_in("result", data, socket) do
    IO.puts "result:"
    IO.inspect data
    case data["type"] do
      "pi" ->
        IO.puts "result_pi"
        %{"hit" => hit, "round" => round} = data["result"]
        PiResultsServer.add_result(hit, round)
      "multiply" ->
        IO.puts "multiply"
      _ -> nil
    end
    # ResultsServer.add_result(hit, round, job_id)
    # push(socket, "calculate", %{})
    {:noreply, socket}
  end
end
