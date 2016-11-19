import "phoenix_html";
import socket from "./socket";

const calcPi = () => {
  console.group();
  console.log('Hi, monte carlo pi');
  const round = 1000000;
  let hit = 0;
  let x, y;

  for (var i = 0; i < round; i++) {
	  x = Math.random();
	  y = Math.random();

	  if ((x*x + y*y)<1) hit++;
  }

  console.log(hit);
  console.groupEnd();
  channel.push("result", {hit, round});
};


let channel = socket.channel("pi:monte", {});
channel.on("calculate", x => {
  calcPi();
  console.log("calculate");
});

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp); })
  .receive("error", resp => { console.log("Unable to join", resp); });

calcPi();
