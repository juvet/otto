defmodule Otto.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    unless Mix.env() == :prod do
      Envy.auto_load()
      Envy.reload_config()
    end

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Otto.Repo, []),
      # Start the endpoint when the application starts
      supervisor(OttoWeb.Endpoint, [])
      # Start your own worker by calling: Otto.Worker.start_link(arg1, arg2, arg3)
      # worker(Otto.Worker, [arg1, arg2, arg3]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Otto.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    OttoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
