defmodule HackTUI.Application do
  @moduledoc """
  HackTUI Application Supervisor – orchestrates renderer, input, router, and MCP engine.
  """

  use Application

  def start(_type, _args) do
    children = [
      {HackTUI.State, %{}},
      HackTUI.Router,
      HackTUI.Renderer,
      HackTUI.Input,
      HackTUI.MCP
    ]

    opts = [strategy: :one_for_one, name: HackTUI.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
