defmodule HackTUI.State do
  @moduledoc """
  Shared application state (accessible by all modules).
  """

  use GenServer

  def start_link(initial_state),
    do: GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)

  def init(state), do: {:ok, state}

  def update(fun),
    do: GenServer.cast(__MODULE__, {:update, fun})

  def get,
    do: GenServer.call(__MODULE__, :get)

  def handle_cast({:update, fun}, state),
    do: {:noreply, fun.(state)}

  def handle_call(:get, _from, state),
    do: {:reply, state, state}
end
