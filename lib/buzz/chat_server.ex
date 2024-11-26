defmodule Buzz.ChatServer do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, ["lobby"], name: __MODULE__)
  end

  def create_chat(name) do
    GenServer.call(__MODULE__, {:create_chat, name})
  end

  def get_chats() do
    GenServer.call(__MODULE__, :get_chats)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call({:create_chat, name}, _from, state) do
    name = name |> String.downcase() |> String.trim()

    new_state =
      if name in state do
        state
      else
        [name | state]
      end

    {:reply, {:ok, new_state}, new_state}
  end

  def handle_call(:get_chats, _from, state) do
    {:reply, state, state}
  end
end
