import "phoenix_html";
import {socket, resultSocket} from "./socket";

const pushTaskRequest = (results) => {
  taskChannel.push("task_request", {})
};

const pushResults = (task, results) => {
  let channel = getResultChannel(resultSocket, task);
  channel.push("result", results);
}

const getResultChannel = (socket, task) => {
  const topic = `result:job-${task.job_id}`;
  let channel = socket.channels.find(c => c.topic == topic);

  if (channel && (channel.state == "joined" || channel.state == "joining")) {
    return channel;
  }

  channel = channel || socket.channel(topic);

  channel.join()
    .receive("ok", resp => {
      console.log("Joined results successfully", resp);
    })
    .receive("error", resp => { console.log("Unable to join results", resp); });

  return channel;
}

const calculatePi = (data) => {
  const rounds = data["rounds"];
  let hits = 0;
  let x, y;

  for (var i = 0; i < rounds; i++) {
	  x = Math.random();
	  y = Math.random();

	  if ((x*x + y*y)<1) hits++;
  }

  return {hits, rounds};
};
const calculateMatrixRow = (data) => {
  let rowIndex = data.row
  let input = JSON.parse(data.data)

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
    let x =  Object.assign({}, result, {
      job_id: data.job_id,
      job_type: data.job_type,
      task_index: data.task_index
    })
    return x;
  } else {
    let result = calculateMatrixRow(data)
    return {
      result,
      job_id: data.job_id,
      job_type: data.job_type,
      row: data.row
    }
  }
}

let taskChannel = socket.channel("tasks:*", {});
taskChannel.on("task_response", data => {
  let results = calculate(data)

  pushResults(data, results)
  pushTaskRequest()
});

taskChannel.join()
  .receive("ok", resp => {
    console.log("Joined successfully", resp);
    pushTaskRequest()
  })
  .receive("error", resp => { console.log("Unable to join", resp); });
