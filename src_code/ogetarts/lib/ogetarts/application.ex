defmodule Ogetarts.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      OgetartsWeb.Endpoint,
      Ogetarts.BackupAgent,
      Ogetarts.GameSup,
      # Starts a worker by calling: Ogetarts.Worker.start_link(arg)
      # {Ogetarts.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ogetarts.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    OgetartsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
