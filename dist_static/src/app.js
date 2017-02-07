import {socket, resultSocket} from "./socket";

let channelJoined = false;
let previousScriptSrc = '';
let effectiveWorkerScript = '';

const readFile = (pathOfFileToReadFrom) => {
    var request = new XMLHttpRequest();
    request.open("GET", pathOfFileToReadFrom, false);
    request.send(null);
    var returnValue = request.responseText;

    return returnValue;
}

const getTextRepresentationOfWebWorkerCode = () => `
  ;
  self.onmessage = function(e) {
    self.postMessage(calculate(e.data));
    self.close();
  };
`
const pushTaskRequest = (taskChannel) => {
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
      channelJoined = true;
      console.log("Joined results successfully", resp);
    })
    .receive("error", resp => { console.log("Unable to join results", resp); });

  return channel;
}

const embedScriptFile = (scriptSrc, callback, data) => {
  if (previousScriptSrc !== scriptSrc) {
    var blob = new Blob([readFile(scriptSrc) + getTextRepresentationOfWebWorkerCode()], {type: 'text/javascript'});
    var workerScript = window.URL.createObjectURL(blob);
    effectiveWorkerScript = workerScript;
    previousScriptSrc = scriptSrc;
    console.log('Script changed');
  }

  var worker = new Worker(effectiveWorkerScript);
  worker.onmessage = function(e) {
    callback(e)
  }
  worker.postMessage(data);
}

export default class App {
  runForPluralTask() {
    let taskChannel = socket.channel("tasks:*", {});

    taskChannel.on("task_response", message => {
      if (message.items.length > 0) {
        message.items.forEach((data, i) => {
          embedScriptFile(data.script_file, (result) => {
            pushResults(data, result.data);
          }, data)

          if (i === message.items.length - 4) {
            setTimeout(function() {
              console.log("timeout")
              pushTaskRequest(taskChannel)
            }, 1000)
          }
        })
      } else {
        setTimeout(function() {
          console.log("timeout")
          pushTaskRequest(taskChannel)
        }, 1000)
      }
    })

    taskChannel.join()
    .receive("ok", resp => {
      console.log("Joined successfully", resp);
      pushTaskRequest(taskChannel)
    })
    .receive("error", resp => { console.log("Unable to join", resp); });
  }
}
