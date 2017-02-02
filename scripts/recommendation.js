function calculate(data) {
  console.log("recommendation")
  const task_id = data["task_id"];
  const product_id = data["metadata"]

  console.log("product_id: ", product_id)

  let input1 = data["input"][0]
  let input2 = data["input"][1]

  users =
    input1
      .filter(function(el) { return el[1] == 2 })
      .map(function(el) { return el[0]})

  console.log("users: ", users)

  products = {}

  for(let i = 0; i < input2.length; i++) {
    let product = input2[i]
    console.log("product")
    if (users.includes(product[0])) {
      let current = products[product[1]] || 0
      products[product[1]] = current + 1
    }
  }

  let results = products

  console.log("results: ", results)


  return {results, task_id}
};
