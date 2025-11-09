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
  msg =
    case State.get() do
      %{message: m} when is_binary(m) -> m
      _ -> "Press H for help • R refresh • X execute • Q quit"
    end

  now        = DateTime.utc_now() |> DateTime.to_string()
  node_name  = to_string(node())

  # Move cursor to top-left (1,1) and draw over the same area
  IO.write(IO.ANSI.cursor(1, 1))

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

  # Flush to stdout explicitly
  IO.flush(:stdio)
end


  defp pad(str, width) do
    s = String.slice(to_string(str), 0, width)
    pad_len = max(0, width - String.length(s))
    s <> String.duplicate(" ", pad_len)
  end
end
