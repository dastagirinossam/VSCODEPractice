({
    openModal : function(component, event, helper) {
        var isOpen = component.get('v.isOpen');
        var action = component.get("c.fetchUser");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse); 
                
                var modal = component.find("myModal");
                var modalBackdrop = component.find("myModal-Back");
                
                // Now add and remove class
                $A.util.addClass(modal, 'slds-fade-in-open');
                $A.util.addClass(modalBackdrop, 'slds-fade-in-open');
            }
        });
        $A.enqueueAction(action);
    },
    
    onSubmit : function(component, event, helper) {
        
        var u = component.get("v.userInfo");
        console.log('User Id: ' + u.Id);
        
        var pw = component.get('v.Password');
        console.log('Password: ' + pw);
        
        if(pw == null){
            var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                title : 'Password Reset',
                message : 'Password must be at least 8 Characters Long',
                duration:' 5000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            resultsToast.fire();      
        }else if(pw.length < 8){
            var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                title : 'Password Reset',
                message : 'Password must be at least 8 Characters Long',
                duration:' 5000',
                key: 'info_alt',
                type: 'error',
                mode: 'pester'
            });
            resultsToast.fire();
        }else{
            
            var action = component.get('c.customerResetPassword'); 
            action.setParams({ 
                'uId' : u.Id, 
                'pw' : pw
            });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var result =  response.getReturnValue();
                    
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        title : 'Password Reset',
                        message : 'Your password has been reset succesfully!',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    resultsToast.fire();
                }else if (state === "ERROR") {
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        title : 'Passwords Reset',
                        message : 'An Error Happened When Resetting our password. Please contact your StandardAero CPM to resolve this issue.',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    resultsToast.fire();
                }
            });
            $A.enqueueAction(action);
            
            component.set('v.isOpen', false);
            
            var modal = component.find("myModal");
            var modalBackdrop = component.find("myModal-Back");
            
            // Now add and remove class
            $A.util.removeClass(modal, 'slds-fade-in-open');
            $A.util.removeClass(modalBackdrop, 'slds-fade-in-open');
            
        }
    },
    
    cancel: function(component, event, helper){
        component.set('v.isOpen', false);
        
        var modal = component.find("myModal");
        var modalBackdrop = component.find("myModal-Back");
        
        // Now add and remove class
        $A.util.removeClass(modal, 'slds-fade-in-open');
        $A.util.removeClass(modalBackdrop, 'slds-fade-in-open');
    }
})