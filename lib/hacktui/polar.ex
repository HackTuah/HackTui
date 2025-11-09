defmodule HackTUI.Polar do
  @moduledoc """
  Draws a simple animated polar pattern using ANSI cursor positioning.
  """

  @chars ["·", "•", "◉", "●"]
  @palette [
    IO.ANSI.magenta(),
    IO.ANSI.light_magenta(),
    IO.ANSI.cyan(),
    IO.ANSI.light_cyan(),
    IO.ANSI.green(),
    IO.ANSI.light_green()
  ]

  # Render a ring around the given center
  def draw(center_x, center_y, radius, frame) do
    0..359
    |> Enum.each(fn angle ->
      θ = :math.pi() * angle / 180
      r = radius - rem(angle + frame, 4) / 4
      x = trunc(center_x + r * :math.cos(θ))
      y = trunc(center_y + r * :math.sin(θ))
      color = Enum.at(@palette, rem(angle + frame, length(@palette)))
      char = Enum.at(@chars, rem(angle + frame, length(@chars)))
      IO.write(IO.ANSI.cursor(y, x))
      IO.write(color <> char <> IO.ANSI.reset())
    end)
  end
end
