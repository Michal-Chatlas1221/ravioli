import "phoenix_html";
import socket from "./socket";

const pushDataRequest = (results) => {
  channel.push("data_request", {})
};

const calculate = (data) => {
  console.group();
  console.log("Data: ", data);
  console.log('Hi, monte carlo pi');
  const round = data["rounds"];
  let hit = 0;
  let x, y;

  for (var i = 0; i < round; i++) {
	  x = Math.random();
	  y = Math.random();

	  if ((x*x + y*y)<1) hit++;
  }

  console.log(hit);
  console.groupEnd();

  return {hit, round};
};

let channel = socket.channel("tasks:*", {});
channel.on("data_response", data => {
	console.log("received data_resp")
  console.log(data)
  let results = calculate(data)
  console.log(results)
  pushDataRequest()
});

channel.join()
  .receive("ok", resp => {
    console.log("Joined successfully", resp);
    pushDataRequest()
  })
  .receive("error", resp => { console.log("Unable to join", resp); });

console.log("channel", channel)
