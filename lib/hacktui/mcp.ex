defmodule HackTUI.MCP do
  @moduledoc """
  Message/Command Processor – handles keyboard commands and updates shared state.
  """defmodule HackTUI.MCP do
  @moduledoc """
  Message/Command Processor – handles keyboard commands and updates shared state.
  Includes trigger for Polar Magik rendering.
  """

  use GenServer
  alias HackTUI.State
  alias HackTUI.Polar

  @commands %{
    "h" => "Help: [H]elp • [R]efresh • [X]ecute • [P]olar • [Q]uit",
    "x" => "Execute command placeholder",
    "q" => "Quit requested"
  }

  def start_link(_opts \\ []),
    do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  def init(state), do: {:ok, state}

  def dispatch({:key, key}), do: send(__MODULE__, {:key, key})

  # ————————————————————————————————————————————————————————
  # Event handling
  # ————————————————————————————————————————————————————————

  def handle_info({:key, key}, state) when is_binary(key) do
    # Normalize to single lowercase char
    key = key |> String.downcase() |> String.trim() |> String.slice(0, 1)

    cond do
      key == "" ->
        {:noreply, state}

      key == "r" ->
        # handle refresh animation asynchronously
        Task.start(fn -> animate_refresh() end)
        {:noreply, state}

      key == "p" ->
        # trigger Polar Magik animation
        Task.start(fn -> polar_magic() end)
        {:noreply, state}

      Map.has_key?(@commands, key) ->
        msg = Map.fetch!(@commands, key)
        State.update(&Map.put(&1, :message, msg))
        {:noreply, state}

      true ->
        State.update(&Map.put(&1, :message, "Unknown key: #{inspect(key)} • Press H for help"))
        {:noreply, state}
    end
  end

  # ————————————————————————————————————————————————————————
  # Animation helpers
  # ————————————————————————————————————————————————————————

  defp animate_refresh do
    for i <- 1..3 do
      dots = String.duplicate(".", i)
      State.update(&Map.put(&1, :message, "Refreshing#{dots}"))
      Process.sleep(250)
    end

    State.update(&Map.put(&1, :message, "Screen refreshed ✓"))
    Process.sleep(800)
    State.update(&Map.put(&1, :message, "Press H for help • R refresh • X execute • P polar • Q quit"))
  end

  # ————————————————————————————————————————————————————————
  # Polar Magik animation
  # ————————————————————————————————————————————————————————

  defp polar_magic do
    State.update(&Map.put(&1, :message, "Summoning Polar Magik..."))

    for frame <- 1..120 do
      # Center and radius can be adjusted for your terminal size
      Polar.draw(35, 12, 8, frame)
      Process.sleep(33)
    end

    State.update(&Map.put(&1, :message, "Aurora complete ✨"))
    Process.sleep(1200)
    State.update(&Map.put(&1, :message, "Press H for help • R refresh • X execute • P polar • Q quit"))
  end
end


  use GenServer
  alias HackTUI.State

  @commands %{
    "h" => "Help: [H]elp • [R]efresh • [X]ecute • [Q]uit",
    "x" => "Execute command placeholder",
    "q" => "Quit requested"
  }

  def start_link(_opts \\ []),
    do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  def init(state), do: {:ok, state}

  def dispatch({:key, key}), do: send(__MODULE__, {:key, key})

  # ————————————————————————————————————————————————————————
  # Event handling
  # ————————————————————————————————————————————————————————

  def handle_info({:key, key}, state) when is_binary(key) do
    # Normalize to single lowercase char
    key = key |> String.downcase() |> String.trim() |> String.slice(0, 1)

    cond do
      key == "" ->
        {:noreply, state}


      key == "r" ->
        # handle refresh animation asynchronously
        Task.start(fn -> animate_refresh() end)
        {:noreply, state}

      Map.has_key?(@commands, key) ->
        msg = Map.fetch!(@commands, key)
        State.update(&Map.put(&1, :message, msg))
        {:noreply, state}

      true ->
        State.update(&Map.put(&1, :message, "Unknown key: #{inspect(key)} • Press H for help"))
        {:noreply, state}
    end
  end

  # ————————————————————————————————————————————————————————
  # Animation helpers
  # ————————————————————————————————————————————————————————

  defp animate_refresh do
    for i <- 1..3 do
      dots = String.duplicate(".", i)
      State.update(&Map.put(&1, :message, "Refreshing#{dots}"))
      Process.sleep(250)
    end

    State.update(&Map.put(&1, :message, "Screen refreshed ✓"))
    Process.sleep(800)
    State.update(&Map.put(&1, :message, "Press H for help • R refresh • X execute • Q quit"))
  end
end
