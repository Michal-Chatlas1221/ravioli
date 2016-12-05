import "phoenix_html";
import socket from "./socket";

const pushResults = (results) => {
  channel.push("result", results);
};


let channel = socket.channel("pi:monte", {});
channel.on("calculate", x => {
	console.log("received calculate")
  let data    = fetchJobData();
  let results = calculate(data);
  pushResults(results);
});

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp); })
  .receive("error", resp => { console.log("Unable to join", resp); });

console.log("channel", channel)

let data    = fetchJobData();
let results = calculate(data);

pushResults(results);
