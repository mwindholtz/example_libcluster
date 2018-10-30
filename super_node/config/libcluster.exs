use Mix.Config

# config :libcluster,
#   debug: true,
#   topologies: [
#     the_universe: [
#       strategy: Elixir.Cluster.Strategy.Gossip,
#       config: [
#         port: 45892,
#         if_addr: "0.0.0.0",
#         multicast_addr: "224.0.0.1",
#         multicast_ttl: 1
#       ], 
#       secret: "mysecret"
#     ]
#   ]


config :libcluster,
  debug: true,
  topologies: [
    gossip_example: [
      strategy: Elixir.Cluster.Strategy.Gossip,
      config: [
        port: 45892,
        if_addr: "0.0.0.0",
        multicast_addr: "224.0.0.1",
        multicast_ttl: 1,
        secret: "somepassword"
      ]
    ]
  ]