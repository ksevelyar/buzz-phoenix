defmodule Buzz.UserList do
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def add(chat_name, user) do
    Agent.update(__MODULE__, fn state ->
      Map.update(state, chat_name, [user], fn users ->
        if user in users, do: users, else: [user | users]
      end)
    end)
  end

  def remove(chat_name, user) do
    Agent.update(__MODULE__, fn state ->
      case Map.get(state, chat_name, []) do
        [] ->
          state

        users ->
          updated_users = Enum.reject(users, &(&1 == user))

          if updated_users == [] do
            Map.delete(state, chat_name)
          else
            Map.put(state, chat_name, updated_users)
          end
      end
    end)
  end

  def get(chat_name) do
    Agent.get(__MODULE__, fn state ->
      Map.get(state, chat_name, [])
    end)
  end
end
