defmodule SuperNode.AutoCluster do
  @moduledoc """

  ref: https://www.youtube.com/watch?v=zQEgEnjuQsU
  from: https://github.com/aseigo/exploring-elixir/blob/master/lib/exploring_elixir/e007/autocluster.ex

  CONSOLE: 
  iex --name node1@localhost -S mix
  iex --name node2@localhost -S mix
  epmd -names
  SuperNode.AutoCluster.monitor()
  SuperNode.AutoCluster.ping_node(:"node2@127.0.0.1")

  SuperNode.AutoCluster.start()

  """

  def visible_nodes do
    Node.list()
    |> display_nodes("Visible Nodes")
  end

  def hidden_nodes do
    Node.list(:hidden)
    |> display_nodes("Hidden Nodes")
  end

  def all_nodes do
    Node.list(:known)
    |> display_nodes("All Nodes")
  end

  def ping_node(node) when is_atom(node), do: Node.ping(node)

  def start do
    monitor()
    Application.ensure_all_started(:libcluster)
  end

  def connect_node(node) do
    IO.puts("* * * * * Going to connect up node #{inspect(node)}...")
    true = :net_kernel.connect_node(node)
  end

  def disconnect_node(node) do
    IO.puts("* * * * * Going to disconnect node #{inspect(node)}...")
    true = :erlang.disconnect_node(node)
  end

  def monitor, do: monitor(Process.whereis(:cluster_monitor))

  def monitor(nil) do
    pid =
      spawn(fn ->
        IO.puts("Starting node monitor process")
        :net_kernel.monitor_nodes(true)
        monitor_cluster()
      end)

    Process.register(pid, :cluster_monitor)
    pid
  end

  def monitor(_), do: IO.puts("Already monitoring!")

  defp monitor_cluster do
    SuperNode.AutoCluster.visible_nodes()

    receive do
      {:nodeup, node} ->
        IO.puts(good_news_marker() <> " Node joined: #{inspect(node)}")
        monitor_cluster()

      {:nodedown, node} ->
        IO.puts(bad_news_marker() <> " Node departed: #{inspect(node)}")
        monitor_cluster()

      x ->
        IO.puts("Outa here with #{x}")
        :ok
    end
  end

  defp display_nodes(nodes, title) do
    IO.puts("#{stars()} #{title} #{stars()}")
    display_nodes(nodes)
  end

  defp display_nodes([]), do: IO.puts("Not connected to any cluster. We are alone.")

  defp display_nodes(nodes) when is_list(nodes) do
    IO.puts("Nodes in our cluster, including ourselves:")

    [Node.self() | nodes]
    |> Enum.sort()
    |> Enum.dedup()
    |> Enum.each(fn node -> IO.puts("     #{inspect(node)}") end)
  end

  defp good_news_marker,
    do: IO.ANSI.green() <> String.duplicate(<<0x1F603::utf8>>, 5) <> IO.ANSI.reset()

  defp bad_news_marker,
    do: IO.ANSI.red() <> String.duplicate(<<0x1F630::utf8>>, 5) <> IO.ANSI.reset()

  defp stars, do: String.duplicate("*", 10)
end
