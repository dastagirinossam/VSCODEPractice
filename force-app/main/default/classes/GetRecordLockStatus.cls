public with sharing class GetRecordLockStatus {

    @InvocableMethod
    public static void GetRecordStatus(List<String> rId) {
        String recordId = rId[0];

        Boolean lockStatus = Approval.isLocked(recordId);

        if(lockStatus)
        	Approval.unlock(recordId, true); 
   
    }
   
}