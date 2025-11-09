defmodule HackTUI.Renderer do
  @moduledoc """
  HackTUI.Renderer — draws the TUI frame, polls shared state for messages,
  and updates at a fixed FPS.

  It maintains a single, stable terminal box updated in place
  using ANSI cursor repositioning rather than full screen clears.
  """

  use GenServer
  alias HackTUI.State

  @fps 15  # frames per second

  # ————————————————————————————————————————————————————————
  # OTP entry points
  # ————————————————————————————————————————————————————————

  def start_link(_), do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  def init(state) do
    # Clear screen once at startup
    IO.write(IO.ANSI.clear())
    IO.write(IO.ANSI.home())

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
    # Fetch message from shared state (or show default help)
    msg =
      case State.get() do
        %{message: m} when is_binary(m) -> m
        _ -> "Press H for help • R refresh • X execute • Q quit"
      end

    # Move cursor to top-left (1,1) so each frame overwrites the last
    IO.write(IO.ANSI.cursor(1, 1))

    now = DateTime.utc_now() |> DateTime.to_string()
    node_name = to_string(node())

    box = [
      "┌────────────────────────────────────────────┐",
      "│                H A C K T U I               │",
      "├────────────────────────────────────────────┤",
      "│ Frame: #{pad("#{frame}", 36)}│",
      "│ Node:  #{pad(node_name, 35)}│",
      "│ Time:  #{pad(now, 35)}│",
      "├────────────────────────────────────────────┤",
      "│ #{pad(msg, 42)}│",
      "└────────────────────────────────────────────┘"
    ]

    Enum.each(box, &IO.puts/1)

    # Flush to stdout explicitly (Elixir 1.19+ requires device)
    IO.flush(:stdio)
  end

  defp pad(str, width) do
    s = String.slice(to_string(str), 0, width)
    pad_len = max(0, width - String.length(s))
    s <> String.duplicate(" ", pad_len)
  end
end
