defmodule BuzzWeb.RoomChannel do
  use BuzzWeb, :channel

  alias Buzz.UserList

  @impl true
  def join("room:lobby", _payload, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  @impl true
  def handle_info(:after_join, socket) do
    UserList.add(socket.assigns[:handle])

    broadcast(socket, "user_list", %{users: UserList.get()})

    {:noreply, socket}
  end

  @impl true
  def terminate(_reason, socket) do
    UserList.delete(socket.assigns[:handle])

    broadcast(socket, "user_list", %{users: UserList.get()})

    :ok
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", %{body: payload["body"], handle: socket.assigns.handle})

    {:noreply, socket}
  end
end
