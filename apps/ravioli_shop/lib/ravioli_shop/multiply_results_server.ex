defmodule RavioliShop.MultiplyResultsServer do
  @moduledoc """
    Let us not worry about docs right now
  """

  use GenServer

  alias RavioliShop.Jobs

  @name :multiply_results_server

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: @name)
  end

  def add_result_row(row_id, row), do:
    GenServer.cast(@name, {:add_result_row, row_id, row})

  def init(:ok) do
    {:ok, []}
  end

  def handle_cast({:add_result_row, row_id, row}, state) do
    new_row = %{row_id: to_int(row_id), row: row}
    new_state =
      state ++ [new_row]
      |> Enum.uniq_by(fn row -> row.row_id end)
      |> Enum.sort_by(fn row -> row.row_id end)
      |> IO.inspect()

    {:noreply, new_state}
  end

  def to_int(i) when is_integer(i), do: i
  def to_int(nil), do: nil
  def to_int(s), do: String.to_integer(s)
end
