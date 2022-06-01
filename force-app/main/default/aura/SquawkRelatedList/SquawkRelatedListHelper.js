({    
	method1: function(component) {
		var action = component.get("c.getAppHistory"); // name on the apex class
        action.setParams({
   			"lstRecordId": component.get("v.recordId")
  		});
        
        action.setCallback(this, function(p) {
            
            if(p.getReturnValue() == null){
                component.set("v.appHistorySize", "0");
            }else{                
                if(p.getReturnValue().length > 6){
                    var apHistory = [];
                	var ah = p.getReturnValue();
                    for(var i = 0; i < 6; i++){
                        apHistory.push(ah[i]);                                              
                    }
                    component.set("v.appHistorySize", "6+");
                    component.set("v.appHistory", apHistory);
                }else{
                   component.set("v.appHistorySize", p.getReturnValue().length);
                   component.set("v.appHistory", p.getReturnValue());
                }
            }
        });
        
        $A.enqueueAction(action);
	},
       	     	
    method2: function(component) {
		var action = component.get("c.getFiles");
        action.setParams({
   			"lstRecordId": component.get("v.recordId")
  		});
                
        action.setCallback(this, function(p) {
            if(p.getReturnValue() == null){
               component.set("v.filesSize", "0");
            }else{
                var files = [];
                var files2 = [];
				var f = p.getReturnValue();                
                if(p.getReturnValue().length > 6){
                    component.set("v.filesSize", "6+");
                    for(var i = 0; i < 6; i++){
                        if(i%2==0){
                            files.push(f[i]);
                        }else{
                            files2.push(f[i]);
                        }
                    }               	   
                }else{
                    component.set("v.filesSize", p.getReturnValue().length);
                    for(var i = 0; i < p.getReturnValue().length; i++){
                        if(i%2==0){
                            files.push(f[i]);
                        }else{
                            files2.push(f[i]);
                        }
                    }                      
                }                
            }
            
            component.set("v.files", files); 
            component.set("v.files2", files2);   
        });
        
        $A.enqueueAction(action);
	},

    sortData: function (cmp, fieldName, sortDirection) {
		
        var currentDir = component.get("v.arrowDirection"); 
      	if (currentDir == 'arrowdown') {  
        	component.set("v.arrowDirection", 'arrowup');
         	component.set("v.isAsc", true);
      	} else {
         	component.set("v.arrowDirection", 'arrowdown');
         	component.set("v.isAsc", false);
      	}
               
        var data = cmp.get("v.appHistory");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.appHistory", data);
    },
    
    sortBy: function(component, field) {
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.records");
        sortAsc = field == sortField? !sortAsc: true;
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = a[field] > b[field];
            return t1? 0: (sortAsc?-1:1)*(t2?-1:1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.records", records);
    }
})