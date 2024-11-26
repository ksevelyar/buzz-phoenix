defmodule Buzz.UserList do
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def add(user) do
    Agent.update(__MODULE__, fn users ->
      if user in users do
        users
      else
        [user | users]
      end
    end)
  end

  def delete(user) do
    Agent.update(__MODULE__, fn users -> Enum.reject(users, fn u -> u == user end) end)
  end

  def get do
    Agent.get(__MODULE__, & &1)
  end
end
