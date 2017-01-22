function calculate(data) {
  console.log("kv")
  // const denominator = data["rounds"];
  separator = data["job_type"][5];
  console.log("sep", separator)
  const task_id = data["task_id"];
  const input = data["input"];
  let results = input.split(separator).reduce(function(map, word){
    map[word] = (map[word]||0)+1;
    return map;
  }, Object.create(null));

  let value = Math.random();

  return {results, task_id};
};
