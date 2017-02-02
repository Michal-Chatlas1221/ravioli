function calculate(data) {
  console.log("new_pi")
  const denominator = 5000000;
  const task_id = data["task_id"];
  let numerator = 0;
  let x, y;

  for (var i = 0; i < denominator; i++) {
    x = Math.random();
    y = Math.random();

    if ((x*x + y*y)<1) numerator++;
  }

  numerator = numerator * 4;


  return {numerator, denominator, task_id};
};
