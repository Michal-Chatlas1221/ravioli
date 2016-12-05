import {Socket} from "phoenix"

let socket = new Socket("ws://localhost:4000/socket", {params: {token: window.userToken}})

socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("pi:monte", {})

export default socket
