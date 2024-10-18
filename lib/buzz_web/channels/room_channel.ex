defmodule BuzzWeb.RoomChannel do
  use BuzzWeb, :channel

  alias Buzz.{UserList, ChatServer}

  @impl true
  def join("room:lobby", _payload, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  @impl true
  def handle_info(:after_join, socket) do
    UserList.add(socket.assigns[:handle])

    broadcast(socket, "user_list", %{users: UserList.get()})
    broadcast(socket, "chat_list", %{chats: ChatServer.get_chats()})

    {:noreply, socket}
  end

  @impl true
  def terminate(_reason, socket) do
    UserList.delete(socket.assigns[:handle])

    broadcast(socket, "user_list", %{users: UserList.get()})

    :ok
  end

  @impl true
  def handle_in("create_chat", %{"name" => chat_name}, socket) do
    case ChatServer.create_chat(chat_name) do
      {:ok, chats} ->
        broadcast(socket, "chat_list", %{chats: chats})
        {:noreply, socket}

      {:error, reason} ->
        {:reply, {:error, %{reason: reason}}, socket}
    end
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
