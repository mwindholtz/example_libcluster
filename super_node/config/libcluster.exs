use Mix.Config

config :libcluster,
  topologies: [
    gossip_example: [
      strategy: Cluster.Strategy.Gossip,
      config: [
        port: 45892,
        if_addr: "0.0.0.0",
        multicast_addr: "224.0.0.1",
        multicast_ttl: 1,
        secret: "somepassword"
      ],
      connect: {SuperNode.AutoCluster, :connect_node, []},
      disconnect: {SuperNode.AutoCluster, :disconnect_node, []}
    ]
  ]