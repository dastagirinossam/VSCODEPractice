global class ProductUpdateBatchJobscheduled implements Schedulable {
    
    global void execute(SchedulableContext sc) {     
        ProductUpdateBatchJob b = new ProductUpdateBatchJob(); 
        database.executebatch(b);
    }
    
}