function calculate(data) {
  console.log("two_parts 2")
  console.log(data)
  const task_id = data["task_id"];
  const previous = data["metadata"]["previous"]
  const product_id = data["metadata"]["product_id"]
  const input = data["input"]

  let result =
      input
      .filter(function(x) { return previous.includes(x[0])})
      .filter(function(x) { return x[1] != product_id})
      .map(function(x) { return x[1] })

  console.log("result2")
  console.log(result)

  return {result, task_id};
};
