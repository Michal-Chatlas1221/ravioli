import {Socket} from "phoenix"

let socket = new Socket("ws://localhost:4001/socket", {params: {token: window.userToken}})
let shopSocket = new Socket("ws://localhost:4000/socket", {params: {token: window.userToken}})

socket.connect()
shopSocket.connect()

// Now that you are connected, you can join channels with a topic:

export {socket, shopSocket}
