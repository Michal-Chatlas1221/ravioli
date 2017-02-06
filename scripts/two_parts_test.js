function calculate(data) {
  console.log("two_parts")
  console.log(data)
  const task_id = data["task_id"];
  const input = data["input"]
  const product_id = data["metadata"]["product_id"]

  let result =
      input
      .filter(function(el) { return el[1] == product_id})
      .map(function(el) { return el[0] })

  console.log("result")
  console.log(result)

  return {result, task_id};
};
