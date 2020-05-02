import { readable } from "svelte/store";
import { chatChannel } from "../socket";

const chat = readable({ isConnected: false, error: false }, (set) => {
  chatChannel
    .join()
    .receive("ok", () => {
      set({ isConnected: true, error: false });
    })
    .receive("error", (error) => {
      console.error(error);
      set({ isConnected: false, error: true });
    });
});

const currentRoom = readable(null, (set) => {
  chatChannel.on("room", ({ room }) => {
    set(room);
  });
});

const messages = readable([], (set) => {
  chatChannel.on("msg", ({ conversation }) => {
    set(conversation);
  });
});

export { chat, messages, currentRoom };
