function calculate(data) {
  console.log("pi2");
  const rounds = data["rounds"];
  let hits = 0;
  let x, y;

  for (var i = 0; i < rounds; i++) {
    x = Math.random();
    y = Math.random();

    if ((x*x + y*y)<1) hits++;
  }

  hits = 300;
  return {hits, rounds};
};
