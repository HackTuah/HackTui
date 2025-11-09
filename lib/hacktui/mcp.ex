defmodule HackTUI.MCP do
  @moduledoc """
  Message/Command Processor – handles keyboard commands and updates state.
  """

  use GenServer
  alias HackTUI.State

  @commands %{
    "h" => "Help: [H]elp [R]efresh [X]ecute [Q]uit",
    "r" => "Refreshing screen...",
    "x" => "Execute command placeholder"
  }

  def start_link(_opts \\ []),
    do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  def init(state), do: {:ok, state}

  # Called from Router when a key is pressed
  def dispatch({:key, key}), do: send(__MODULE__, {:key, key})

  def handle_info({:key, key}, state) do
    msg = Map.get(@commands, key, "Unknown key: #{key}")
    State.update(&Map.put(&1, :message, msg))
    {:noreply, state}
  end
end
