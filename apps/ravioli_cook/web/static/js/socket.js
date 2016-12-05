import {Socket} from "phoenix"

let socket = new Socket("ws://localhost:4001/socket", {params: {token: window.userToken}})

socket.connect()

// Now that you are connected, you can join channels with a topic:

export default socket
