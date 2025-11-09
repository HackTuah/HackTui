defmodule HackTUI.Renderer do
  @moduledoc """
  HackTUI.Renderer — draws the TUI frame, polls shared state for messages,
  and updates at a fixed FPS.

  Maintains a single, stable terminal box updated in place
  using ANSI cursor repositioning rather than full-screen clears.
  Now includes an aurora-style color cycle: purple → cyan → magenta → green.
  """

  use GenServer
  alias HackTUI.State

  @fps 15  # frames per second
  @palette [:magenta, :light_magenta, :cyan, :light_cyan, :green, :light_green]

  # ————————————————————————————————————————————————————————
  # OTP entry points
  # ————————————————————————————————————————————————————————

  def start_link(_), do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  def init(state) do
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

  # pick color from aurora palette
  defp aurora_color(frame),
    do: Enum.at(@palette, rem(frame, length(@palette)))

  defp draw_frame(frame) do
    msg =
      case State.get() do
        %{message: m} when is_binary(m) -> m
        _ -> "Press H for help • R refresh • X execute • Q quit"
      end

    now = DateTime.utc_now() |> DateTime.to_string()
    node_name = to_string(node())
    color = aurora_color(frame)

    # Move cursor home and set color
    IO.write(IO.ANSI.cursor(1, 1))
    IO.write(IO.ANSI.format([IO.ANSI.color(color)]))

    box = [
      "┌────────────────────────────────────────────┐",
      "│                H A C K T U I               │",
      "├────────────────────────────────────────────┤",
      "│ Frame: #{pad("#{frame}", 36)}│",
      "│ Node:  #{pad(node_name, 36)}│",
      "│ Time:  #{pad(now, 36)}│",
      "├────────────────────────────────────────────┤",
      "│ #{pad(msg, 43)}│",
      "└────────────────────────────────────────────┘"
    ]

    Enum.each(box, &IO.puts/1)

    # reset color so shell text isn’t tinted after exit
    IO.write(IO.ANSI.reset())
  end

  defp pad(str, width) do
    s = String.slice(to_string(str), 0, width)
    pad_len = max(0, width - String.length(s))
    s <> String.duplicate(" ", pad_len)
  end
end
