({   
	toggleClass: function(component,componentId,className) {
		var modal = component.find(componentId);
		$A.util.removeClass(modal,className+'hide');
		$A.util.addClass(modal,className+'open');
	},

	toggleClassInverse: function(component,componentId,className) {
		var modal = component.find(componentId);
		$A.util.addClass(modal,className+'hide');
		$A.util.removeClass(modal,className+'open');
	}
})