({
	doInit : function(component, event, helper) {

        var action = component.get("c.getOwner");        
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
        component.set('v.winHeight', winHeight);
        
        window.addEventListener('resize', $A.getCallback(function(){
            if(component.isValid()) {
    			helper.helperMethod(component, event, helper);
            }
        }));        

		action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
               // set current user information on userInfo attribute
                component.set("v.ProfileName", storeResponse);
            }
        });
        $A.enqueueAction(action);
    },     
    
    handleClick: function(component, event, helper) {
		
        component.set("v.isOpen", true);
                
        window.addEventListener('mousedown', $A.getCallback(function(e){
            component.set("v.isOpen", false);
		}), 
		false);
        
	},
    
    logout: function(cmp, evt, hlp) {
        window.location.replace("http://www.mystandardaero.com/secur/logout.jsp?retUrl=%2F/s/login/");
    }
  
})