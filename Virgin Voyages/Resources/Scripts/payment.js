(function() {
	try {
		var reduxState = window.___REDUX_INITIAL_STATE___;
		var clientResponse = reduxState.clientResponse;
		return JSON.stringify(clientResponse.data);
	} catch (error) {
		return "Error extracting information: " + error;
	}
})();