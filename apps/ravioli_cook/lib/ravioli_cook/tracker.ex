defmodule RavioliCook.Tracker do
  @moduledoc """
  Tracks which node in a cluster is responsible for handling each job.
  Server's state consists of three fields:
  - `jobs` - list of current jobs processed by nodes.
  Each job is represented by `{job_id, vector_clock}` tuple.
  - `queue` - list of queued jobs awaiting for responses from other nodes.
  Each queued job is represented by `{job_id, vector_clock, timer_ref}` tuple.
  - `nodes` - list of currently connected nodes.
  Used to keep track of nodes' monitors.
  """
  use GenServer

  alias RavioliCook.Tracker.{ClockServer, VectorClock}

  @name :tracker
  @job_start_timeout 500

  def start_link do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  @doc """
  Notifies all connected nodes about job and sets up a timer for a
  {:start, job} message.
  After a given time, it starts processing the job. If it receives a message
  from other node which is already processing this job, cancels the timer
  and deletes the job if it already started.
  """
  def process_job(job_id), do: GenServer.cast(@name, {:process_job, job_id})

  @doc "Returns the list of jobs processed by the current node"
  def get_jobs(), do: GenServer.call(@name, :get_jobs)

  ## Callbacks

  def init([]) do
    send(self(), :refresh_nodes)

    {:ok, %{jobs: [], queue: [], nodes: []}}
  end

  def handle_cast({:process_job, job_id}, %{queue: queue} = state) do
    clock = ClockServer.update()

    query_other_nodes(job_id, clock)
    timer_ref =
      Process.send_after(self(), {:start_job, job_id, clock}, @job_start_timeout)

    new_queue = queue ++ [{job_id, clock, timer_ref}]

    {:noreply, %{state | queue: new_queue}}
  end

  def handle_call(:get_jobs, _from, %{jobs: jobs} = state) do
    {:reply, jobs, state}
  end

  # TODO: Check all edge cases
  def handle_cast({:job_query, queried_job, node, clock}, %{jobs: jobs} = state) do
    updated_clock = ClockServer.update(clock)

    with {job_id, job_clock} <- Enum.find(jobs, fn {j, _} -> j == queried_job end),
         :lt                 <- VectorClock.compare(job_clock, clock) do
      send_job_reply(job_id, node, updated_clock)
    else
      _ ->
        nil
    end

    {:noreply, state}
  end

  def handle_info({:nodedown, node}, %{nodes: nodes} = state) do
    {:noreply, %{state | nodes: nodes -- [node]}}
  end

  def handle_info({:job_reply, job, node, clock}, %{jobs: jobs, queue: queue} = state) do
    ClockServer.update(clock)

    new_jobs = List.keydelete(jobs, job, 0)
    {{_, _, timer_ref}, new_queue} = List.keytake(queue, job, 0)
    Process.cancel_timer(timer_ref)


    {:noreply, %{state | jobs: new_jobs, queue: new_queue}}
  end

  def handle_info({:start_job, job, clock}, %{jobs: jobs, queue: queue} = state) do
    ClockServer.update()

    new_jobs = Enum.uniq(jobs ++ [{job, clock}])
    new_queue = List.keydelete(queue, job, 0)

    {:noreply, %{state | jobs: new_jobs, queue: new_queue}}
  end

  def handle_info(:refresh_nodes, %{nodes: nodes} = state) do
    Process.send_after(self(), :refresh_nodes, 1000)

    current_nodes = Node.list()
    new_nodes = current_nodes -- nodes
    Enum.each(new_nodes, &Node.monitor(&1, true))

    {:noreply, %{state | nodes: current_nodes}}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  def query_other_nodes(job, clock) do
    GenServer.abcast(Node.list(), @name, {:job_query, job, Node.self(), clock})
  end

  def send_job_reply(job, node, clock) do
    send({@name, node}, {:job_reply, job, Node.self, clock})
  end
end
