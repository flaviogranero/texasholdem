defmodule TexasHoldem.RoomChannel do
  use TexasHoldem.Web, :channel

  def join("rooms:lobby", payload, socket) do
    if authorized?(payload) do
      Process.flag(:trap_exit, true)
      # :timer.send_interval(5000, :ping)
      send(self, {:after_join, payload})
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (rooms:lobby).
  def handle_info({:after_join, msg}, socket) do
    broadcast! socket, "user:entered", %{user: msg}
    push socket, "join", %{status: "connected"}
    {:noreply, socket}
  end
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    broadcast! socket, "new_msg", %{body: body}
    {:noreply, socket}
  end

  # This is invoked every time a notification is being broadcast
  # to the client. The default implementation is just to push it
  # downstream but one could filter or change the event.
  def handle_out("new_msg", payload, socket) do
    push socket, "new_msg", payload
    {:noreply, socket}
  end

  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
