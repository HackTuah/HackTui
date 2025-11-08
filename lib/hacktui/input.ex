defmodule HackTUI.Input do
  @moduledoc """
  Reads keyboard input and sends keypress events to the router.
  """

  use GenServer

  def start_link(_opts \\ []),
    do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  def init(state) do
    spawn(fn -> loop_read() end)
    {:ok, state}
  end

  defp loop_read do
    case IO.getn("", 1) do
      "q" -> IO.puts("\nExiting..."); System.halt(0)
      char -> send(HackTUI.Router, {:key, char}); loop_read()
    end
  end
end
