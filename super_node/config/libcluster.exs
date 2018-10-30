use Mix.Config

config :libcluster,
  debug: true,
  topologies: [
    the_universe: [
      strategy: Elixir.Cluster.Strategy.Gossip,
      config: [
        port: 45892,
        if_addr: "0.0.0.0",
        multicast_addr: "230.1.1.251",
        multicast_ttl: 1,
        secret: "the_password"
      ],
      connect: {SuperNode.AutoCluster, :connect_node, []},
      disconnect: {SuperNode.AutoCluster, :disconnect_node, []}
    ]
  ]
