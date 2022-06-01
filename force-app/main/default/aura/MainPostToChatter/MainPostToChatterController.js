({
	PostToChatter : function(component, event, helper) {
        
        var postChatter = component.find("chatterPost").get("v.value");    
  		
        if(postChatter != null){
                  
            var action = component.get('c.PostComment');
            action.setParams({
                "UserPost": postChatter
            });
            
            action.setCallback(component, function(response) {
                var state = response.getState();
                if (state === 'SUCCESS'){
                    $A.get('e.force:refreshView').fire();
                } else {
                     console.log(state);
                }
            });
    
            $A.enqueueAction(action);		
        }
    }
    
})

/*    
 * forceChatter:feed
 * var feed = chatter.getFeed();
    var feedConfig = feed.getConfig();
    feed.refresh({
        feedType : feedConfig.feedType,
        isFullRefresh : true,
        params : feedConfig
    });*/