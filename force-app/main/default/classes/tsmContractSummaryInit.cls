public class tsmContractSummaryInit {
    
    @AuraEnabled 
    public static void tsmContractSummaryInit(String oppId){
        tsmContractSummary.tsmContractSummary(oppId); 
    }

}