public class FlightHours { 
    
    private List<Flight_Hours__c> fhrs; 
    private Equipment__c equip; 
    
    public FlightHours(ApexPages.StandardController controller) {
        this.equip= (Equipment__c)controller.getRecord();
    }
    
    public List<Flight_Hours__c> getFhrs() {
        fhrs = [Select id, Name, Equipment__c, Source__c, Hours__c, Hours_Date__c, Archive_Flight_Hours__c from Flight_Hours__c where Equipment__c = :equip.id ORDER BY Hours__c desc];
        return fhrs;
    }

    public PageReference saveAndReturn() {
        update fhrs;
        PageReference parentPage = new PageReference('/' + equip.Id);
        parentPage.setRedirect(true);
        return parentPage;
    }

}