public class TestAverageMonthlyFlightHour
{
    public static testMethod void FlightHour()
    {
        //Creating Base Test Data
        Configuration_Parameters__c cp = new Configuration_Parameters__c(Param_Value__c = '4', Param_Name__c='MAX_ROWS_AVERAGE_MONTHLY_FLIGHT_HOURS');
        insert cp;
        Account acc = new Account(Type='Aircraft', Name = 'Test Account', Area__c='East', billingcountry = 'USA', BillingState = 'TN');
        insert acc;
        Aircraft__c Aircraft1 = new Aircraft__c(Name='Test A1', Account__c = acc.Id); // Average_Monthly_Hours_Override__c = false,
        insert Aircraft1;
        Aircraft__c Aircraft2 = new Aircraft__c(Name='Test A2', Account__c = acc.Id);
        insert Aircraft2;
        Equipment__c Equipment1 = new Equipment__c(Name = 'Test E1', Aircraft__c = Aircraft1.Id, Equipment_Type__c = 'Engine', EngineorAPUSN__c = '11', Account__c = acc.Id); //e.Average_Monthly_Hours_Override__c, e.Aircraft__c From
        insert Equipment1;
        Equipment__c Equipment2 = new Equipment__c(Name = 'Test A1', Aircraft__c = Aircraft1.Id, Equipment_Type__c = 'APU', EngineorAPUSN__c = '1111111', Account__c = acc.Id); //, e.Equipment_Type__c, e.EngineorAPUSN__c, e.Average_Monthly_Hours_Override__c, e.Aircraft__c From
        insert Equipment2;
        Equipment__c Equipment3 = new Equipment__c(Name = 'NA', Aircraft__c = Aircraft1.Id, Equipment_Type__c = 'Engine', EngineorAPUSN__c = 'NA', Account__c = acc.Id); //, e.Equipment_Type__c, e.EngineorAPUSN__c, e.Average_Monthly_Hours_Override__c, e.Aircraft__c From
        insert Equipment3;
        list<Flight_Hours__c> FHToInsert = new list<Flight_Hours__c>();
        list<Flight_Hours__c> FHToInsert1 = new list<Flight_Hours__c>();
        list<Flight_Hours__c> FHToUpdate = new list<Flight_Hours__c>();
        list<Flight_Hours__c> FHToUpdate1 = new list<Flight_Hours__c>();
        
        // Flight Hours for Aircraft
        Flight_Hours__c FH_Aircraft1 = new Flight_Hours__c(Hours__c = 100, Hours_Date__c = Date.newInstance(2008,12,19), Aircraft__c = Aircraft1.Id, Equipment__c = Equipment3.Id, Parent_Equipment__c = Equipment3.Id); //, f.Archive_Flight_Hours__c, f.Aircraft__c From Flight_Hours__c
        FHToInsert.add(FH_Aircraft1);
        Flight_Hours__c FH_Aircraft2 = new Flight_Hours__c(Hours__c = 200, Hours_Date__c = Date.newInstance(2008,12,29), Aircraft__c = Aircraft1.Id, Equipment__c = Equipment3.Id, Parent_Equipment__c = Equipment3.Id); //, f.Archive_Flight_Hours__c, f.Aircraft__c From Flight_Hours__c
        FHToInsert.add(FH_Aircraft2);
        Flight_Hours__c FH_Aircraft3 = new Flight_Hours__c(Hours__c = 300, Hours_Date__c = Date.newInstance(2009,1,9), Aircraft__c = Aircraft1.Id, Equipment__c = Equipment3.Id, Parent_Equipment__c = Equipment3.Id); //, f.Archive_Flight_Hours__c, f.Aircraft__c From Flight_Hours__c
        FHToInsert.add(FH_Aircraft3);
        
        Flight_Hours__c FH_Aircraft10 = new Flight_Hours__c(Hours__c = 100, Hours_Date__c = Date.newInstance(2008,12,19), Aircraft__c = Aircraft2.Id, Equipment__c = Equipment3.Id, Parent_Equipment__c = Equipment3.Id); //, f.Archive_Flight_Hours__c, f.Aircraft__c From Flight_Hours__c
        FHToInsert.add(FH_Aircraft10);
        Flight_Hours__c FH_Aircraft20 = new Flight_Hours__c(Hours__c = 200, Hours_Date__c = Date.newInstance(2008,12,29), Aircraft__c = Aircraft2.Id, Equipment__c = Equipment3.Id, Parent_Equipment__c = Equipment3.Id); //, f.Archive_Flight_Hours__c, f.Aircraft__c From Flight_Hours__c
        FHToInsert.add(FH_Aircraft20);
        Flight_Hours__c FH_Aircraft30 = new Flight_Hours__c(Hours__c = 300, Hours_Date__c = Date.newInstance(2009,1,9), Aircraft__c = Aircraft2.Id, Equipment__c = Equipment3.Id, Parent_Equipment__c = Equipment3.Id); //, f.Archive_Flight_Hours__c, f.Aircraft__c From Flight_Hours__c
        FHToInsert.add(FH_Aircraft30);      
        
        // Flight Hours for Engine
        Flight_Hours__c FH_Engine1 = new Flight_Hours__c(Hours__c = 400, Hours_Date__c = Date.newInstance(2008,12,20), Equipment__c = Equipment1.Id, Parent_Equipment__c = Equipment1.Id); //, f.Archive_Flight_Hours__c, f.Aircraft__c From Flight_Hours__c
        FHToInsert.add(FH_Engine1);
        Flight_Hours__c FH_Engine2 = new Flight_Hours__c(Hours__c = 500, Hours_Date__c = Date.newInstance(2008,12,30), Equipment__c = Equipment1.Id, Parent_Equipment__c = Equipment1.Id); //, f.Archive_Flight_Hours__c, f.Aircraft__c From Flight_Hours__c
        FHToInsert.add(FH_Engine2);
        Flight_Hours__c FH_Engine3 = new Flight_Hours__c(Hours__c = 600, Hours_Date__c = Date.newInstance(2009,1,10), Equipment__c = Equipment1.Id, Parent_Equipment__c = Equipment1.Id); //, f.Archive_Flight_Hours__c, f.Aircraft__c From Flight_Hours__c
        FHToInsert.add(FH_Engine3);
        
        //Flight Hours for APU
        Flight_Hours__c FH_APU1 = new Flight_Hours__c(Hours__c = 700, Hours_Date__c = Date.newInstance(2008,12,21), Equipment__c = Equipment2.Id, Parent_Equipment__c = Equipment2.Id); //, f.Archive_Flight_Hours__c, f.Aircraft__c From Flight_Hours__c
        FHToInsert.add(FH_APU1);
        Flight_Hours__c FH_APU2 = new Flight_Hours__c(Hours__c = 800, Hours_Date__c = Date.newInstance(2008,12,31), Equipment__c = Equipment2.Id, Parent_Equipment__c = Equipment2.Id); //, f.Archive_Flight_Hours__c, f.Aircraft__c From Flight_Hours__c
        FHToInsert.add(FH_APU2);
        Flight_Hours__c FH_APU3 = new Flight_Hours__c(Hours__c = 900, Hours_Date__c = Date.newInstance(2009,1,11), Equipment__c = Equipment2.Id, Parent_Equipment__c = Equipment2.Id); //, f.Archive_Flight_Hours__c, f.Aircraft__c From Flight_Hours__c
        FHToInsert.add(FH_APU3);
        
        insert FHToInsert;
        
        //Updates Flight Hours for Aircraft
        Flight_Hours__c FH_Aircraft11 = new Flight_Hours__c(Id = FH_Aircraft1.Id, Hours__c = 150, Hours_Date__c = Date.newInstance(2008,12,25), Equipment__c = Equipment3.Id, Parent_Equipment__c = Equipment3.Id); //, f.Archive_Flight_Hours__c, f.Aircraft__c From Flight_Hours__c
        FHToUpdate.add(FH_Aircraft11);

        //Updates Flight Hours for Engine
        Flight_Hours__c FH_Engine11 = new Flight_Hours__c(Id = FH_Engine1.Id, Hours__c = 150, Hours_Date__c = Date.newInstance(2008,12,25), Equipment__c = Equipment1.Id, Parent_Equipment__c = Equipment1.Id); //, f.Archive_Flight_Hours__c, f.Aircraft__c From Flight_Hours__c
        FHToUpdate.add(FH_Engine11);

        //Updates FLight Hours for APU
        Flight_Hours__c FH_APU11 = new Flight_Hours__c(Id = FH_APU1.Id, Hours__c = 150, Hours_Date__c = Date.newInstance(2008,12,25), Equipment__c = Equipment2.Id, Parent_Equipment__c = Equipment2.Id); //, f.Archive_Flight_Hours__c, f.Aircraft__c From Flight_Hours__c
        FHToUpdate.add(FH_APU11);
        
        update FHToUpdate;
        
        // Changed the configuration parameter to 0 and then insert and update the flight hours record.
        Configuration_Parameters__c cp1 = new Configuration_Parameters__c(Id = cp.Id, Param_Value__c = '0');
        update cp1;
        //Aircraft
        Flight_Hours__c FH_A1 = new Flight_Hours__c(Hours__c = 150, Hours_Date__c = Date.newInstance(2008,12,25), Aircraft__c = Aircraft1.Id, Equipment__c = Equipment3.Id, Parent_Equipment__c = Equipment3.Id);
        FHToInsert1.add(FH_A1);     
        Flight_Hours__c FH_A1_1 = new Flight_Hours__c(Hours__c = 500, Hours_Date__c = Date.newInstance(2009,01,10), Aircraft__c = Aircraft1.Id, Equipment__c = Equipment3.Id, Parent_Equipment__c = Equipment3.Id);
        FHToInsert1.add(FH_A1_1);
        //Engine
        Flight_Hours__c FH_E1 = new Flight_Hours__c(Hours__c = 150, Hours_Date__c = Date.newInstance(2008,12,25), Equipment__c = Equipment1.Id, Parent_Equipment__c = Equipment1.Id);
        FHToInsert1.add(FH_E1);
        Flight_Hours__c FH_E1_1 = new Flight_Hours__c(Hours__c = 300, Hours_Date__c = Date.newInstance(2008,01,25), Equipment__c = Equipment1.Id, Parent_Equipment__c = Equipment1.Id);
        FHToInsert1.add(FH_E1_1);
        //APU
        Flight_Hours__c FH_E12 = new Flight_Hours__c(Hours__c = 150, Hours_Date__c = Date.newInstance(2008,12,25), Equipment__c = Equipment2.Id, Parent_Equipment__c = Equipment2.Id);
        FHToInsert1.add(FH_E12);
        Flight_Hours__c FH_E12_1 = new Flight_Hours__c(Hours__c = 400, Hours_Date__c = Date.newInstance(2008,02,02), Equipment__c = Equipment2.Id, Parent_Equipment__c = Equipment2.Id);
        FHToInsert1.add(FH_E12_1);
        
        insert FHToInsert1;
        
        //update
        Flight_Hours__c FH_A2 = new Flight_Hours__c(Id = FH_A1.Id, Hours__c = 2000, Hours_Date__c = Date.newInstance(2008,12,30));
        FHToUpdate1.add(FH_A2);
        
        Flight_Hours__c FH_E2 = new Flight_Hours__c(Id = FH_E1.Id, Hours__c = 2000, Hours_Date__c = Date.newInstance(2008,12,30));
        FHToUpdate1.add(FH_E2);
        
        Flight_Hours__c FH_E22 = new Flight_Hours__c(Id = FH_E12.Id, Hours__c = 2000, Hours_Date__c = Date.newInstance(2008,12,30));
        FHToUpdate1.add(FH_E22);
        
        update FHToUpdate1;
    }
}