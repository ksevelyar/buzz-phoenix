defmodule Buzz.MessageServer do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def add_mesage(chat_id, message) do
    GenServer.cast(__MODULE__, {:add_message, chat_id, message})
  end

  def get_messages(chat_id) do
    GenServer.call(__MODULE__, {:get_messages, chat_id})
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:add_message, chat_id, message}, state) do
    chat_messages = state[chat_id] || :queue.new()

    updated_chat_messages = :queue.in(message, chat_messages)
    updated_state = Map.put(state, chat_id, updated_chat_messages)

    {:noreply, updated_state}
  end

  def handle_call({:get_messages, chat_id}, _from, state) do
    messages = state[chat_id]

    messages = if messages do
      :queue.to_list(messages)
    else
      []
    end

    {:reply, messages, state}
  end
end
