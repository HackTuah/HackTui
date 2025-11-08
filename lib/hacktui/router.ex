defmodule HackTUI.Router do
  @moduledoc """
  Simple event router – receives key events and dispatches them to the MCP.
  """

  use GenServer

  def start_link(_opts \\ []),
    do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  def init(state), do: {:ok, state}

  def handle_info({:key, char}, state) do
    HackTUI.MCP.dispatch({:key, char})
    {:noreply, state}
  end
end
