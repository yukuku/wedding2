var Validation = {
	number: function(input, min, max) {
		var test = input.value;
		
		if (isNaN(parseInt(test))) {
			input.focus();
			alert("This must be a number.");
			return false;
		} 
		
		test = parseInt(test);
		
		if (typeof min != 'undefined') {
			if (test < min) {
				input.focus();
				alert("This must be a number " + min + " or greater.");
				return false;
			}
		} 
		if (typeof max != 'undefined') {
			if (test > max) {
				input.focus();
				alert("This must be a number " + max + " or less.");
				return false;
			}
		}
		return true;
	},
	filled: function(input) {
		var test = input.value;
		if (test == '') {
			input.focus();
			alert("This is required to be filled in.");
			return false;
		}
		return true;
	}
} 