defmodule RavioliCook.Results.WeightedAverage do
  @moduledoc """
    Let us not worry about docs right now
  """

  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def init(:ok) do
    {:ok, %{numerator: 0, denominator: 0}}
  end

  def handle_cast(
    {:add_result, %{"numerator" => numerator, "denominator" => denominator}}, state) do
    numerator = state.numerator + to_int(numerator)
    denominator = state.denominator + to_int(denominator)

    new_state = %{numerator: numerator, denominator: denominator}
    IO.puts "current value: #{numerator / denominator}"

    {:noreply, new_state}
  end
  def handle_cast({:add_result, _}, state) do
    {:noreply, state}
  end

  def to_int(i) when is_integer(i), do: i
  def to_int(s), do: String.to_integer(s)
end
