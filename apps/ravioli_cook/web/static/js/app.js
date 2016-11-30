import "phoenix_html";
import socket from "./socket";

const pushResults = (results) => {
  channel.push("result", results);
}


let channel = socket.channel("pi:monte", {});
channel.on("calculate", x => {
  let results = calculate();
  pushResults(results);
});

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp); })
  .receive("error", resp => { console.log("Unable to join", resp); });

let results = calculate();
pushResults(results);
