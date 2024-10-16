defmodule Buzz.Chats do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def create_chat(name) do
    GenServer.call(__MODULE__, {:create_chat, name})
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call({:create_chat, name}, _from, state) do
    chat_id = generate_chat_id()
    chat = %{id: chat_id, name: name, users: []}
    new_state = Map.put(state, chat_id, chat)
    {:reply, {:ok, chat}, new_state}
  end

  defp generate_chat_id do
    :erlang.unique_integer([:positive])
  end
end
