function calculate(data) {
  console.log("two_parts")
  console.log(data)
  const task_id = data["task_id"];
  const input = data["input"]

  let result = input.filter(function(x) { return x % 2 == 0})


  return {result, task_id};
};
