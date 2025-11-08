defmodule HackTUI.MCP do
  @moduledoc """
  Message/Command Processor – handles keyboard commands and updates state.
  """

  use GenServer

  @commands %{
    "h" => {:show, "Help: [H]elp [R]efresh [X]ecute [Q]uit"},
    "r" => {:show, "Refreshing screen..."},
    "x" => {:show, "Execute command placeholder"}
  }

  def start_link(_opts \\ []),
    do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  def init(state), do: {:ok, state}

  def dispatch(msg), do: send(__MODULE__, msg)

  def handle_info({:key, key}, state) do
    case Map.get(@commands, key) do
      {:show, msg} ->
        HackTUI.State.update(&Map.put(&1, :message, msg))
      nil ->
        HackTUI.State.update(&Map.put(&1, :message, "Unknown key: #{key}"))
    end
    {:noreply, state}
  end
end
