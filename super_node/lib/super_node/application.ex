defmodule SuperNode.Application do
  @moduledoc """
  ref: https://www.youtube.com/watch?v=zQEgEnjuQsU
  from: https://github.com/aseigo/exploring-elixir/blob/master/lib/exploring_elixir/e007/autocluster.ex
  CONSOLE:
  ./run_node.sh 1
  ./run_node.sh 2
  ./run_node.sh 3
  # will show output of =>  11:16:34.247 [debug] [libcluster:the_universe] heartbeat
  """

  use Application
  alias SuperNode.AutoCluster

  def start(_type, _args) do

    IO.puts AutoCluster.visible_nodes()
    # List all child processes to be supervised
    topologies = Application.get_env(:libcluster, :topologies)

    children = [
      {Cluster.Supervisor, [topologies, [name: SuperNode.ClusterSupervisor]]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SuperNode.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
