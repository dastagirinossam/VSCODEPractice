({
    doInit : function (component, event) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1));
        var sURLVariables = sPageURL.split('&');
        
        for (var i = 0; i < sURLVariables.length; i++) {
            var sParameterName = sURLVariables[i].split('='); 
        }
        
        var recordId = sParameterName[1];
        
        var action = component.get("c.getBuyerProjectQuoteLines");
        action.setParams({"lstRecordId" : recordId});
        //alert('hii');
        
        action.setCallback(this, function(s) {
            var quoteLine = s.getReturnValue();  
           // alert('hello12'+s.getReturnValue().length);
            var ql = JSON.parse(JSON.stringify(quoteLine));
            
            component.set("v.project", ql[0].Project__c);
            component.set("v.projectName", ql[0].Project__r.Name);
            
            component.set("v.quoteLine", s.getReturnValue());
            component.set("v.quoteLineSize", s.getReturnValue().length);
            console.log('Quote Line Size: ' + s.getReturnValue().length);
        });
        
        $A.enqueueAction(action);                        
    },
    
    redirect: function (){
        var url = window.location.href; 
        var value = url.substr(0,url.lastIndexOf('/') + 1);
        window.history.back();
        return false;
    },
    
    downloadBuyerSquawksCsv : function(component,event,helper){
        
        var stockData = component.get("v.quoteLine");
        var projName = component.get("v.projectName");
        
        var csv = helper.convertArrayOfObjectsToCSV(component,stockData);   
        if (csv == null){return;} 
        
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURIComponent(csv);
        hiddenElement.target = '_self'; 
        hiddenElement.download = projName + ' Buyers Squawks Report.csv';  
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file
    }
    
})