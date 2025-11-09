defmodule HackTUI.Renderer do
  @moduledoc """
  HackTUI.Renderer — draws the TUI frame, polls shared state for messages,
  and updates at a fixed FPS.
  """

  use GenServer
  alias HackTUI.State

  @fps 15  # frames per second

  # ————————————————————————————————————————————————————————
  # OTP entry points
  # ————————————————————————————————————————————————————————

  def start_link(_), do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  def init(state) do
    schedule_tick()
    {:ok, Map.put(state, :frame, 0)}
  end

  def handle_info(:tick, %{frame: frame} = state) do
    draw_frame(frame)
    schedule_tick()
    {:noreply, %{state | frame: frame + 1}}
  end

  # ————————————————————————————————————————————————————————
  # Internal utilities
  # ————————————————————————————————————————————————————————

  defp schedule_tick, do: Process.send_after(self(), :tick, frame_time())
  defp frame_time, do: trunc(1000 / @fps)

  defp draw_frame(frame) do
    # Pull the latest shared message (if any)
    msg =
      case State.get() do
        %{message: m} when is_binary(m) -> m
        _ -> ""
      end

    IO.write(IO.ANSI.clear())
    IO.write(IO.ANSI.home())

    now = DateTime.utc_now() |> DateTime.to_string()
    node_name = to_string(node())

    # Draw a clean box with dynamic padding and message line
    IO.puts("┌────────────────────────────────────────────┐")
    IO.puts("│               H A C K T U I                │")
    IO.puts("├────────────────────────────────────────────┤")
    IO.puts("│ Frame: #{pad("#{frame}", 36)}│")
    IO.puts("│ Node:  #{pad(node_name, 35)}│")
    IO.puts("│ Time:  #{pad(now, 35)}│")
    IO.puts("├────────────────────────────────────────────┤")
    IO.puts("│ #{pad(msg, 42)}│")
    IO.puts("└────────────────────────────────────────────┘")
  end

  defp pad(str, width) do
    s = String.slice(to_string(str), 0, width)
    pad_len = max(0, width - String.length(s))
    s <> String.duplicate(" ", pad_len)
  end
end
