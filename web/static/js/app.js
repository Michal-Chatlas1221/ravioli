// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"

console.group();
console.log('Hi, monte carlo pi');

const round = 1000;
let hit = 0;
let x, y;

for (var i = 0; i < round; i++) {
	x = Math.random();
	y = Math.random();

	if ((x*x + y*y)<1) hit++;
}

console.log(hit);
console.endGroup();

socket.push('result', {try: round, hit: hit}).then(console.log('OK')).catch(console.log('DUPA'));
