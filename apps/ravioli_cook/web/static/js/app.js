import "phoenix_html";
import {socket, shopSocket} from "./socket";

const pushDataRequest = (results) => {
  taskChannel.push("data_request", {})
};

let resultChannel = shopSocket.channel("result:*", {});

const pushResults = (results) => {
  resultChannel.push("result", results)
}


const calculatePi = (data) => {
  const round = data["rounds"];
  let hit = 0;
  let x, y;

  for (var i = 0; i < round; i++) {
	  x = Math.random();
	  y = Math.random();

	  if ((x*x + y*y)<1) hit++;
  }

  return {hit, round};
};
const calculateMatrixRow = (data) => {
  let rowIndex = data.row
  let input = JSON.parse(data.data)

  console.log("calc row ", rowIndex)

  return multiply(input.matrix_a, input.matrix_b, rowIndex);
}
function multiply(a, b, r) {
  var aNumRows = a.length, aNumCols = a[0].length,
      bNumRows = b.length, bNumCols = b[0].length,
      m = new Array(aNumRows);  // initialize array of rows
  for (var c = 0; c < bNumCols; ++c) {
    m[c] = 0;             // initialize the current cell
    for (var i = 0; i < aNumCols; ++i) {
      m[c] += a[r][i] * b[i][c];
    }
  }
  return m;
}

const calculate = (data) => {
  if (data.job_type == 'pi') {
    let result = calculatePi(data)
    return {
      result,
      job_id: data.job_id,
      type: data.job_type
    }
  } else {
    let result = calculateMatrixRow(data)
    return {
      result,
      job_id: data.job_id,
      type: data.job_type,
      row: data.row
    }
  }
}

let taskChannel = socket.channel("tasks:*", {});
taskChannel.on("data_response", data => {
	console.log("received data_resp")
  console.log(data)

  let results = calculate(data)
  console.log(results)

  pushResults(results)
  pushDataRequest()
});

resultChannel.join()
  .receive("ok", resp => {
    console.log("Joined results successfully", resp);
  })
  .receive("error", resp => { console.log("Unable to join results", resp); });

taskChannel.join()
  .receive("ok", resp => {
    console.log("Joined successfully", resp);
    pushDataRequest()
  })
  .receive("error", resp => { console.log("Unable to join", resp); });
