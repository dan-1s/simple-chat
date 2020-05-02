import { Socket } from "phoenix";

const socket = new Socket("/chat_socket", {
  params: { token: window.authToken },
});
socket.connect();

function getRoomFromUrl() {
  return window.location.pathname.split("/")[1];
}

const chatRoomFromUrl = getRoomFromUrl();
const chat = `chat:${chatRoomFromUrl}`;
const user = `user:${window.userId}`;

const chatChannel = socket.channel(chat, {});
const userChannel = socket.channel(user, {});

const sendChatMsgToRoom = (msg, userName) => {
  chatChannel.push(chat, { msg, userName });
};

export { chatChannel, userChannel, chatRoomFromUrl, sendChatMsgToRoom };
