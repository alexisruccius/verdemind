defmodule Verdemind.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      VerdemindWeb.Telemetry,
      Verdemind.Repo,
      {DNSCluster, query: Application.get_env(:verdemind, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Verdemind.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Verdemind.Finch},
      # Start a worker by calling: Verdemind.Worker.start_link(arg)
      # {Verdemind.Worker, arg},
      # Start to serve requests, typically the last entry
      VerdemindWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Verdemind.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VerdemindWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
