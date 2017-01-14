defmodule RavioliCook do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(RavioliCook.Endpoint, []),
      supervisor(RavioliCook.Repo, []),
      worker(RavioliCook.JobFetcher.Server, []),
      supervisor(RavioliCook.Presence, []),
      worker(RavioliCook.NodeTracker, []),
      supervisor(Task.Supervisor, [[name: RavioliCook.TaskSupervisor]])
    ]

    opts = [strategy: :one_for_one, name: RavioliCook.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    RavioliCook.Endpoint.config_change(changed, removed)
    :ok
  end
end
