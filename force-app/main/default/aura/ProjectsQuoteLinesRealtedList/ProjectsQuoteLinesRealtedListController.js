({
    doInit : function (component, event) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        var sURLVariables = sPageURL.split('&');
        
        for (var i = 0; i < sURLVariables.length; i++) {
            var sParameterName = sURLVariables[i].split('='); 
        }
        
        var recordId = sParameterName[1];
        
        var action = component.get("c.getProjectQuoteLines");
        action.setParams({"lstRecordId" : recordId});
        
        action.setCallback(this, function(s) {

            if(s.getReturnValue().length !=0){
                var quoteLine = s.getReturnValue();  
                var ql = JSON.parse(JSON.stringify(quoteLine));
                component.set("v.project", ql[0].Project__c);
                component.set("v.projectName", ql[0].Project__r.Name);
                component.set("v.showELH", ql[0].Project__r.Show_Estimated_Labor_Hours__c);
                
                
                component.set("v.quoteLine", s.getReturnValue());
                component.set("v.quoteLineSize", s.getReturnValue().length);
                
            }
        });
        
        $A.enqueueAction(action);  
        
        var action1 = component.get("c.checkIsBroker");
        action1.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if(storeResponse[0] =='Customer - Broker' ){
                    component.set("v.isBroker", true);
                    
                }
            }
        });
        $A.enqueueAction(action1);
        
        var action2 = component.get("c.checkProjectType");
        action2.setParams({"lstRecordId" : recordId});
        action2.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();

                if(storeResponse[0].Project_Type__c == 'Pre-Buy'){
                   
                    if((storeResponse[0].Buyer_Inspection__c == undefined || storeResponse[0].Buyer_Inspection__c == null) && storeResponse[0].Seller_Inspection__c != null)
                        component.set("v.ProjType","Buyer");

                    if( (storeResponse[0].Seller_Inspection__c == undefined || storeResponse[0].Seller_Inspection__c == null) && storeResponse[0].Buyer_Inspection__c != null)
                        component.set("v.ProjType","Seller");
                    
                }
                else {
                    component.set("v.ProjType","Inspection");  
                }
            }
        });
        $A.enqueueAction(action2);    
    },
   
	redirect: function (){
    	var url = window.location.href; 
        var value = url.substr(0,url.lastIndexOf('/') + 1);
        window.history.back();
        return false;
    },
    
	downloadCsv : function(component,event,helper){
        
        var stockData = component.get("v.quoteLine");
        var projName = component.get("v.projectName");
        
        var csv = helper.convertArrayOfObjectsToCSV(component, stockData);   
         if (csv == null){return;} 
         
	     var hiddenElement = document.createElement('a');
          hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURIComponent(csv);
          hiddenElement.target = '_self'; 
          hiddenElement.download = projName + 'Squawks Report.csv';  
          document.body.appendChild(hiddenElement); // Required for FireFox browser
    	  hiddenElement.click(); // using click() js function to download csv file
	}
   
})