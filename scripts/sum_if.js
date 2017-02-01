function calculate(instance) {
	
	const {search, list,task_id} = instance;
	
	let usersThatOrdered = Array.from(
	  new Set(list
	   .filter(e => e.product === search )
	   .map(e => e.user
	)));

	let products = [];
	let numbers = [];  

	list.forEach(e => {
	  if (usersThatOrdered.indexOf(e.user) !== -1) {
	    if (products.indexOf(e.product) === -1 && e.product !== search) {
	      products.push(e.product);
	      numbers.push(1);
	    } else {
	      numbers[products.indexOf(e.product)]++;
	    }	
	  }
	});

	const result = products.map((e, i) => ({
		product: e,
		occurrences: numbers[i]
	}));

	return {result, task_id}
}