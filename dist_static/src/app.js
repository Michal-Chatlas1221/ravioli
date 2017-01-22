import {socket, resultSocket} from "./socket";

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
      console.log("Joined results successfully", resp);
    })
    .receive("error", resp => { console.log("Unable to join results", resp); });

  return channel;
}

const embedScriptFile = (scriptSrc, callback) => {
  const id = "fetched-script-tag";
  let oldScriptTag = document.getElementById(id);

  if (oldScriptTag && oldScriptTag.src == scriptSrc) {
    callback();
  }
  else {
    if (oldScriptTag) oldScriptTag.remove();

    let scriptTag = document.createElement('script');
    scriptTag.src = scriptSrc;

    scriptTag.onload = callback;
    scriptTag.onreadystatechange = callback;

    scriptTag.id = id;

    document.head.appendChild(scriptTag);
  }
}

export default class App {
  run() {
    let taskChannel = socket.channel("tasks:*", {});
    taskChannel.on("task_response", data => {
      embedScriptFile(data.script_file, () => {
      let results = calculate(data)

      pushResults(data, results)
      pushTaskRequest(taskChannel)
      });
    });
    taskChannel.join()
    .receive("ok", resp => {
      console.log("Joined successfully", resp);
      pushTaskRequest(taskChannel)
    })
    .receive("error", resp => { console.log("Unable to join", resp); });
  }  
}
