({
	sortBy: function(component, field) {
        var sortAsc = component.get("v.sortAsc"),
			sortField = component.get("v.sortField"),
        	records = component.get("v.approvalHistory");
        console.log("Here are the records: " + records);
        console.log(sortField);
        sortAsc = field == sortField? !sortAsc: true;
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = a[field] > b[field];
            return t1? 0: (sortAsc?-1:1)*(t2?-1:1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.approvalHistory", records);
    }
   
})