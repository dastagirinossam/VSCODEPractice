public class AircraftFlightHours { 
    
    private List<Flight_Hours__c> fhrs; 
    private Aircraft__c ac; 
    
    public AircraftFlightHours(ApexPages.StandardController controller) {
        this.ac = (Aircraft__c)controller.getRecord();
    }
    
    public List<Flight_Hours__c> getFhrs() {
        fhrs = [Select id, Name, Aircraft__c, Source__c, Hours__c, Hours_Date__c, Archive_Flight_Hours__c from Flight_Hours__c where Aircraft__c = :ac.id ORDER BY Hours__c desc];
        return fhrs;
    }

    public PageReference saveAndReturn() {
        update fhrs;
        PageReference parentPage = new PageReference('/' + ac.Id);
        parentPage.setRedirect(true);
        return parentPage;
    }

}