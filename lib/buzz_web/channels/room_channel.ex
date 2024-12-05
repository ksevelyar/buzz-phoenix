defmodule BuzzWeb.RoomChannel do
  use BuzzWeb, :channel

  alias Buzz.{UserList, ChatServer, MessageServer}

  @impl true
  def join("room:" <> name, _payload, socket) do
    send(self(), {:after_join, name})

    {:ok, socket}
  end

  @impl true
  def handle_info({:after_join, chat_name}, socket) do
    UserList.add(chat_name, socket.assigns[:handle])
    push(socket, "handle", %{handle: socket.assigns.handle})

    broadcast(socket, "user_list", %{
      users: UserList.get(chat_name)
    })

    broadcast(socket, "chat_list", %{chats: ChatServer.get_chats()})
    broadcast(socket, "messages_list", %{messages: MessageServer.get_messages(chat_name)})

    {:noreply, socket}
  end

  @impl true
  def terminate(_reason, socket) do
    "room:" <> chat_name = socket.topic
    UserList.remove(chat_name, socket.assigns[:handle])

    broadcast(socket, "user_list", %{users: UserList.get(chat_name)})

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
    message = %{body: payload["body"], chat: payload["chat"], handle: socket.assigns.handle}
    "room:" <> chat_name = socket.topic

    broadcast(socket, "shout", message)
    MessageServer.add_mesage(chat_name, message)

    {:noreply, socket}
  end
end
