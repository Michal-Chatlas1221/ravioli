import {Socket} from "phoenix"

let socket = new Socket("ws://138.68.70.103/socket", {params: {token: window.userToken}})
let resultSocket = new Socket("ws://138.68.70.103/socket", {params: {token: window.userToken}})

socket.connect()
resultSocket.connect()

// Now that you are connected, you can join channels with a topic:

export {socket, resultSocket}
