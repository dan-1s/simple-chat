defmodule SimpleChat.Room do
  @doc delegate_to: {__MODULE__.DynamicSupervisor, :join, 1}
  defdelegate join(room), to: SimpleChat.Room.DynamicSupervisor

  @doc delegate_to: {__MODULE__.Process, :new_message, 1}
  defdelegate new_message(data), to: SimpleChat.Room.Process

  @doc delegate_to: {__MODULE__.Process, :get_messages, 1}
  defdelegate get_messages(room), to: SimpleChat.Room.Process

  @doc delegate_to: {__MODULE__.Process, :set_messages, 2}
  defdelegate set_messages(room, messages), to: SimpleChat.Room.Process
end
