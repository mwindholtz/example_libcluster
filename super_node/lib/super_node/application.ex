defmodule SuperNode.Application do
  @moduledoc """
  ### manual
  ref: https://www.youtube.com/watch?v=zQEgEnjuQsU
  from: https://github.com/aseigo/exploring-elixir/blob/master/lib/exploring_elixir/e007/autocluster.ex
  CONSOLE:
  $ ./run_node.sh 222 
  $ ./run_node.sh 111
  $ ./run_node.sh 333

  Starting node monitor process
  ********** Visible Nodes **********
  Not connected to any cluster. We are alone.
  Interactive Elixir (1.6.3) - press Ctrl+C to exit (type h() ENTER for help)
  iex(node222@Space.Home)1> 😃😃😃😃😃 Node joined: :"node111@Space.Home"
  ********** Visible Nodes **********
  Nodes in our cluster, including ourselves:
     :"node111@Space.Home"
     :"node222@Space.Home"
  😃😃😃😃😃 Node joined: :"node333@Space.Home"

  10:56:15.594 [info]  [libcluster:gossip_example] connected to :"node333@Space.Home"
  ********** Visible Nodes **********
  Nodes in our cluster, including ourselves:
     :"node111@Space.Home"
     :"node222@Space.Home"
     :"node333@Space.Home"
  😰😰😰😰😰 Node departed: :"node333@Space.Home"
  ********** Visible Nodes **********
  Nodes in our cluster, including ourselves:
     :"node111@Space.Home"
     :"node222@Space.Home"
  """

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    topologies = Application.get_env(:libcluster, :topologies)

    children = [
      {Cluster.Supervisor, [topologies, [name: SuperNode.ClusterSupervisor]]}
    ]

    SuperNode.AutoCluster.start()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SuperNode.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
