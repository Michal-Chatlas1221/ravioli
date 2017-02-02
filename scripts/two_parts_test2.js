function calculate(data) {
  console.log("two_parts 2")
  console.log(data)
  const task_id = data["task_id"];
  const previous = data["metadata"]["previous"]
  const input = data["input"]

  let result = input.filter(function(x) { return previous.includes(x[0])})

  return {result, task_id};
};
