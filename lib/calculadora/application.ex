defmodule Calculadora.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CalculadoraWeb.Telemetry,
      Calculadora.Repo,
      {DNSCluster, query: Application.get_env(:calculadora, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Calculadora.PubSub},
      # Start a worker by calling: Calculadora.Worker.start_link(arg)
      # {Calculadora.Worker, arg},
      # Start to serve requests, typically the last entry
      CalculadoraWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Calculadora.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CalculadoraWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
