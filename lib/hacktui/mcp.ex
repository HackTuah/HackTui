defmodule HackTUI.MCP do
  @moduledoc """
  Message/Command Processor – handles keyboard commands and updates shared state.
  """

  use GenServer
  alias HackTUI.State

  @commands %{
    "h" => "Help: [H]elp • [R]efresh • [X]ecute • [Q]uit",
    "r" => "Refreshing screen...",
    "x" => "Execute command placeholder",
    "q" => "Quit requested"
  }

  # ————————————————————————————————————————————————————————
  # OTP entry points
  # ————————————————————————————————————————————————————————

  def start_link(_opts \\ []),
    do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  def init(state), do: {:ok, state}

  # Public entry point for events
  def dispatch({:key, key}), do: send(__MODULE__, {:key, key})

  # ————————————————————————————————————————————————————————
  # Handle events
  # ————————————————————————————————————————————————————————

  def handle_info({:key, key}, state) when is_binary(key) do
    # Normalize to lowercase, single char only
    key = key |> String.downcase() |> String.trim() |> String.slice(0, 1)

    msg =
      case Map.get(@commands, key) do
        nil -> "Unknown key: #{inspect(key)} • Press H for help"
        text -> text
      end

    State.update(&Map.put(&1, :message, msg))
    {:noreply, state}
  end
end
