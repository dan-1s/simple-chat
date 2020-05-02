import { readable } from "svelte/store";
import { userChannel } from "../socket";

const user = readable({ isConnected: false, error: false }, (set) => {
  userChannel
    .join()
    .receive("ok", () => {
      set({ isConnected: true, error: false });
    })
    .receive("error", (error) => {
      console.error(error);
      set({ isConnected: false, error: true });
    });
});

const refreshSession = readable(false, (set) => {
  userChannel.on("refresh", () => {
    set(true);
  });
});

const userName = readable(null, (set) => {
  userChannel.on("username", ({ username }) => {
    set(username);
  });
});

export { user, userName, refreshSession };
