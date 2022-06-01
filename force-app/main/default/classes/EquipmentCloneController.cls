Public class EquipmentCloneController {

Public ApexPages.StandardController controller; 

Public Equipment__c eq = new Equipment__c();


Public EquipmentCloneController(ApexPages.StandardController Controller){
        this.controller=Controller; 
        eq = (Equipment__c)Controller.getRecord();  
    }
    
Public PageReference saveAndReturn() {
    
    Savepoint sp = Database.setSavepoint();
    Equipment__c newEQ;
    newEQ = eq.clone(false);
    
    try {
    
    insert newEQ;
 
    } catch (Exception e){
    Database.rollback(sp);
    ApexPages.Message myMsg = new ApexPages.message(ApexPages.severity.ERROR,'Duplicate Engine Found, Please Change The Engine Serial Number');
    ApexPages.addMessage(myMsg);
    Return Null;
    }
    
    PageReference parentPage = new PageReference('/' + newEQ.Id);
    parentPage.setRedirect(true);
    return parentPage;
}
    
Public PageReference GoBack() {
    PageReference parentPage = new PageReference('/' + eq.Id);
    parentPage.setRedirect(true);
    return parentPage;
    }        

}