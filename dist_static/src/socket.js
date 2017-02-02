import {Socket} from "phoenix"

let socket = new Socket("ws://localhost:4001/socket", {params: {token: window.userToken}})
let resultSocket = new Socket("ws://localhost:4001/socket", {params: {token: window.userToken}})

socket.connect()
resultSocket.connect()

// Now that you are connected, you can join channels with a topic:

export {socket, resultSocket}
