({
	helperMethod : function(component) {

        var url = $A.get('$Resource.CommunityHeader');
        var windowWidth = document.documentElement.clientWidth;
		var windowHeight = document.documentElement.clientHeight;
        var ratio = windowWidth/windowHeight;
        var newNumber = windowHeight/ratio;
        var percent = (windowHeight-newNumber)/windowHeight;
        var finalHeight = percent + (percent * ((ratio * .1)*2));
        var bannerHeight = Math.round(windowHeight/ (windowWidth/windowHeight) * finalHeight);
        var picHeight = Math.round((bannerHeight/2)*.15);        
        var winHeight = Math.round((picHeight * (ratio - finalHeight)) + picHeight);
        
        component.set("v.bannerHeight", bannerHeight);
        component.set('v.backgroundImageURL', url);
        component.set('v.picHeight', picHeight);
        component.set('v.winHeight', winHeight);;           
    } 
})