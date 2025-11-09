defmodule HackTUI.Input do
  @moduledoc """
  Reads single-key input from the terminal without echo and dispatches
  events to the Router.
  """

  use GenServer

  def start_link(_opts \\ []),
    do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  def init(state) do
    spawn_link(fn -> loop_read() end)
    {:ok, state}
  end

  defp loop_read do
    # disable echo and buffering (raw mode)
    :io.setopts(:standard_io, [echo: false, binary: true])

    case IO.getn("", 1) do
      "q" ->
        IO.write(IO.ANSI.cursor(20, 1))
        IO.puts("\nExiting HackTUI...\n")
        System.halt(0)

      key when byte_size(key) == 1 ->
        send(HackTUI.Router, {:key, key})
        loop_read()

      _ ->
        loop_read()
    end
  end
end
