trigger AverageMonthlyFlightHour on Flight_Hours__c (after insert, after update)
{
    // Global variable declaration
    list<Id> EquipmentIds = new list<Id>();
    list<Id> AircraftIds = new list<Id>();
    String EquipmentIdString = '';
    String AircraftIdString = '';
    Date EquipmentOldDate;
    Date EqipmentNewDate;
    Date AircraftOldDate;
    Date AircraftNewDate;
    Double EqipmentNewHour;
    Double EqipmentOldHour;
    Double AircraftNewHour;
    Double AircraftOldHour;
    Double AverageMonthlyFlightHours;
    Integer ParamValue = 0;
    String YearRange = '';
    String Equipment_query = '';
    String Aircraft_query = '';
    String EngineSerialNumber;
    String hasEngineFlightHours;
    list<Equipment__c> EngineToUpdate = new list<Equipment__c>();
    list<Equipment__c> APUToUpdate = new list<Equipment__c>();
    list<Aircraft__c> AircraftsToUpdate = new list<Aircraft__c>();
    list<Aircraft__c> AircraftsToUpdateForEngine = new list<Aircraft__c>();
    list<Id> air1 = new list<Id>();
    list<Equipment__c> Eqt = new list<Equipment__c>();
    list<Flight_Hours__c> EngineFlightHours = new list<Flight_Hours__c>();
    list<Id> EngineIds = new list<Id>();
    list<Flight_Hours__c> FlightHoursForEquipment = new list<Flight_Hours__c>();
    list<Flight_Hours__c> FlightHoursForAircraft = new list<Flight_Hours__c>();
    map<Id, Equipment__c> serialNumber = new map<Id, Equipment__c>();
    list<Equipment__c> serial = new list<Equipment__c>();
    map<Id,String> maps = new map<Id,String>();
    map<Id,String> maps1 = new map<Id,String>();
    
    // This section is for getting the Equipment and Aircraft Ids separated by commas for Dynamic query
    for(Integer i=0;i<trigger.new.size();i++)
    {
        if(trigger.new[i].Equipment__c != null)
        {
            EquipmentIds.add(trigger.new[i].Equipment__c);
        }
        if(trigger.new[i].Aircraft__c != null)
        {
            AircraftIds.add(trigger.new[i].Aircraft__c);
        }
    }
    
    map<Id, Equipment__c> Equipments = new map<Id, Equipment__c>([Select Id, Equipment_Type__c, EngineorAPUSN__c, Average_Monthly_Hours_Override__c, Aircraft__c From Equipment__c where Id in : EquipmentIds]);
    map<Id, Aircraft__c> Aircrafts = new map<Id, Aircraft__c>([Select Id, Average_Monthly_Hours_Override__c From Aircraft__c where Id in : AircraftIds]);
    map<Id, Equipment__c> ExuipmentOverride = new map<Id, Equipment__c>([Select Id, Aircraft__r.Average_Monthly_Hours_Override__c, Aircraft__c From Equipment__c where Id in : EquipmentIds]);
    
    //This query is used to get the Parameter Value of MAX_ROWS_AVERAGE_MONTHLY_FLIGHT_HOURS
    list<Configuration_Parameters__c> configParam = new list<Configuration_Parameters__c>([Select Param_Value__c, Id, Param_Name__c From Configuration_Parameters__c where Param_Name__c =: 'MAX_ROWS_AVERAGE_MONTHLY_FLIGHT_HOURS']);
    ParamValue = Integer.valueOf(configParam.get(0).Param_Value__c);
    if(ParamValue == 1)
    {
        ParamValue = 2;
    }
    
    //This section creates a date one year before the current date
    Date cDate = date.today();
    String currentDate = string.valueOf(cDate);
    Date oDate = cDate.addYears(-1);
    
    //This section is used to get the Lowest engine serial number 
    Eqt = [Select Aircraft__c From Equipment__c where Equipment_Type__c =:'Engine' and Id in : EquipmentIds];   
    
    for(Integer i=0;i<Eqt.size();i++)
    {
        air1.add(Eqt[i].Aircraft__c);
    }
    if(air1.size()>0)
    {
        if(air1.get(0) != null)
        {
            serial = [Select Id, EngineorAPUSN__c, Aircraft__c from Equipment__c where Aircraft__c in : air1 and Equipment_Type__c =:'Engine' order by Aircraft__c, EngineorAPUSN__c];
        }
    }
    
    for(Integer i=0; i<Eqt.size(); i++)
    {
        for(Integer j=0; j<serial.size(); j++)
        {
            if(Eqt[i].Aircraft__c == serial[j].Aircraft__c)
            {
                serialNumber.put(serial[j].Id, serial[j]);
                break;
            }
        }
    }
    
    //To get the Engine flight Hours associated to an aircraft. 
    List<Equipment__c> AircraftEngine = new List<Equipment__c>([Select Id, Aircraft__c from Equipment__c where Equipment_Type__c =:'Engine' and Aircraft__c in : AircraftIds]);

    for(Integer j=0;j<AircraftEngine.size();j++)
    {
        EngineIds.add(AircraftEngine[j].Id);
    }
    if(AircraftEngine.size() > 0)
    {
        EngineFlightHours = [Select Id, Equipment__c from Flight_Hours__c where Equipment__c in : AircraftEngine];
    }
    
    // This section sets a flag to Yes or No based on whether Associated Engine of a Aircraft has Flight Hours.
    for(Equipment__c e : AircraftEngine)
    {
        for(Flight_Hours__c fh : EngineFlightHours)
        {
            if(fh.Equipment__c == e.Id)
            {
                maps.put(e.Aircraft__c, 'Yes');
            }
            else
            {
                maps.put(e.Aircraft__c, 'No');
            }
        }
    }

    //This section is used to retrive the Flight Hours and Flight Hours Date of the records that are being inserted or updated.
    FlightHoursForEquipment = [Select Id, Hours__c, Hours_Date__c, Equipment__c From Flight_Hours__c where Archive_Flight_Hours__c =: false and Equipment__c in : EquipmentIds and Equipment__c != 'a0300000000C4P3' order by Equipment__c, Hours_Date__c desc];
    FlightHoursForAircraft = [Select Id, Hours__c, Hours_Date__c, Aircraft__c From Flight_Hours__c where Archive_Flight_Hours__c =: false and Aircraft__c in : AircraftIds order by Aircraft__c, Hours_Date__c desc];   
    
    //This section of the trigger runs on the insert of Flight Hours record and calculates the Roll up to the Average Monthly Hours field.
    if(trigger.isInsert)
    {
        try
        {
            for(Integer i=0; i<trigger.new.size(); i++)
            {
                if(FlightHoursForAircraft.size()>0) //This section check wheather there is two or more then two records to process for flight hours.
                {
                    if(trigger.new[i].Aircraft__c != null && Aircrafts.get(trigger.new[i].Aircraft__c).Average_Monthly_Hours_Override__c == false)
                    {                       
                        if(maps.get(trigger.new[i].Aircraft__c) == 'No' || maps.get(trigger.new[i].Aircraft__c) == null)//This section checks if the Associated Engine to an Aircraft has flight hours.
                        {
                            Integer x = 0;
                            AircraftOldDate =  null;
                            AircraftOldHour = 0.0;
                            for(Flight_Hours__c fh : FlightHoursForAircraft)
                            {
                                if(trigger.new[i].Aircraft__c == fh.Aircraft__c)
                                {
                                    if(x == 0)
                                    {
                                        AircraftNewDate = fh.Hours_Date__c;
                                        AircraftNewHour = fh.Hours__c;
                                    }
                                    else if(x < ParamValue)
                                    {
                                        AircraftOldDate = fh.Hours_Date__c;     
                                        AircraftOldHour = fh.Hours__c;
                                    }
                                    else if(ParamValue == 0 || ParamValue == null)
                                    {
                                        if(fh.Hours_Date__c >= oDate)
                                        {
                                            AircraftOldDate = fh.Hours_Date__c;     
                                            AircraftOldHour = fh.Hours__c;
                                        }
                                    }
                                    else break;
                                    x++;
                                }                               
                            }
                            if(x >= 1 && AircraftOldDate !=  null && AircraftOldHour != null)
                            {
                                AverageMonthlyFlightHours = CLS_MonthlyFlightHours.fn_calAverageFlightHours(AircraftNewDate, AircraftOldDate, AircraftNewHour, AircraftOldHour);
                                if(AverageMonthlyFlightHours > 999)
                                {
                                    AverageMonthlyFlightHours = 999;
                                }
                                Aircraft__c Aircraft = new Aircraft__c(Id=trigger.new[i].Aircraft__c, Average_Monthly_Hours__c = AverageMonthlyFlightHours);
                                AircraftsToUpdate.add(Aircraft);
                            }
                        }
                    }
                }
                if(FlightHoursForEquipment.size()>0)    //This section check wheather there is two or more then two records to process for flight hours.
                {
                    
                    if(trigger.new[i].Equipment__c != null && Equipments.get(trigger.new[i].Equipment__c).Average_Monthly_Hours_Override__c == false)
                    {
                        if(Equipments.get(trigger.new[i].Equipment__c).Equipment_Type__c == 'Engine')   //Checks if the Equipment is of Type Engine
                        {
                            Integer x = 0;
                            EquipmentOldDate = null;
                            EqipmentOldHour = 0.0;
                            for(Flight_Hours__c fh : FlightHoursForEquipment)
                            {
                                if(trigger.new[i].Equipment__c == fh.Equipment__c)
                                {
                                    if(x == 0)
                                    {
                                        EqipmentNewDate = fh.Hours_Date__c;
                                        EqipmentNewHour = fh.Hours__c;
                                    }
                                    else if(x < ParamValue)
                                    {
                                        EquipmentOldDate = fh.Hours_Date__c;
                                        EqipmentOldHour = fh.Hours__c;
                                    }
                                    else if(ParamValue == 0 || ParamValue == null)
                                    {
                                        if(fh.Hours_Date__c >= oDate)
                                        {
                                            EquipmentOldDate = fh.Hours_Date__c;        
                                            EqipmentOldHour = fh.Hours__c;
                                        }
                                    }
                                    else break;
                                    x++;                                    
                                }
                            }
                            if(x >= 1 && EquipmentOldDate != null && EqipmentOldHour != null)
                            {
                                AverageMonthlyFlightHours = CLS_MonthlyFlightHours.fn_calAverageFlightHours(EqipmentNewDate, EquipmentOldDate, EqipmentNewHour, EqipmentOldHour);
                                if(AverageMonthlyFlightHours > 999)
                                {
                                    AverageMonthlyFlightHours = 999;
                                }
                                Equipment__c Equipment = new Equipment__c(Id = trigger.new[i].Equipment__c, Average_Monthly_Hours__c = AverageMonthlyFlightHours);
                                EngineToUpdate.add(Equipment);
                                if(ExuipmentOverride.get(trigger.new[i].Equipment__c).Aircraft__r.Average_Monthly_Hours_Override__c == false)
                                {
                                    if(serialNumber.containsKey(trigger.new[i].Equipment__c))
                                    {
                                        Aircraft__c Aircraft = new Aircraft__c(Id = serialNumber.get(trigger.new[i].Equipment__c).Aircraft__c, Average_Monthly_Hours__c = AverageMonthlyFlightHours);
                                        AircraftsToUpdateForEngine.add(Aircraft);
                                    }
                                }
                            }
                        }
                        if(Equipments.get(trigger.new[i].Equipment__c).Equipment_Type__c == 'APU')
                        {
                            Integer x = 0;
                            EquipmentOldDate = null;
                            EqipmentOldHour = 0.0;
                            for(Flight_Hours__c fh : FlightHoursForEquipment)
                            {
                                if(trigger.new[i].Equipment__c == fh.Equipment__c)
                                {
                                    if(x == 0)
                                    {
                                        EqipmentNewDate = fh.Hours_Date__c;
                                        EqipmentNewHour = fh.Hours__c;
                                    }
                                    else if(x < ParamValue)
                                    {
                                        EquipmentOldDate = fh.Hours_Date__c;
                                        EqipmentOldHour = fh.Hours__c;
                                    }
                                    else if(ParamValue == 0 || ParamValue == null)
                                    {
                                        if(fh.Hours_Date__c >= oDate)
                                        {
                                            EquipmentOldDate = fh.Hours_Date__c;        
                                            EqipmentOldHour = fh.Hours__c;
                                        }
                                    }
                                    else break;
                                    x++;                                    
                                }
                            }
                            if(x >= 1 && EquipmentOldDate != null && EqipmentOldHour != null)
                            {
                                AverageMonthlyFlightHours = CLS_MonthlyFlightHours.fn_calAverageFlightHours(EqipmentNewDate, EquipmentOldDate, EqipmentNewHour, EqipmentOldHour);
                                if(AverageMonthlyFlightHours > 999)
                                {
                                    AverageMonthlyFlightHours = 999;
                                }
                                Equipment__c Equipment = new Equipment__c(Id = trigger.new[i].Equipment__c, Average_Monthly_Hours__c = AverageMonthlyFlightHours);
                                APUToUpdate.add(Equipment);
                            }                       
                        }
                    }
                }   
            }
        }
        catch(Exception e)
        {
            System.debug(e);
        }
    }
    //This section of the trigger runs on the Update of Flight Hours record and calculates the Roll up to the Average Monthly Hours field.
    if(trigger.isUpdate)
    {
        try
        {
            for(Integer i=0; i<trigger.new.size(); i++)
            {
                if(FlightHoursForAircraft.size() > 0)   //This section check wheather there is two or more then two records to process for flight hours.
                {
                    if(trigger.new[i].Aircraft__c != null && Aircrafts.get(trigger.new[i].Aircraft__c).Average_Monthly_Hours_Override__c == false)
                    {
                        //This section checks whether the hours and the date fields were changed or not.
                        if(trigger.new[i].Hours__c != trigger.old[i].Hours__c || trigger.new[i].Hours_Date__c != trigger.old[i].Hours_Date__c)
                        {
                            if(maps.get(trigger.new[i].Aircraft__c) == 'No' || maps.get(trigger.new[i].Aircraft__c) == null)
                            {
                                Integer x = 0;
                                AircraftOldDate =  null;
                                AircraftOldHour = 0.0;
                                for(Flight_Hours__c fh : FlightHoursForAircraft)
                                {
                                    if(trigger.new[i].Aircraft__c == fh.Aircraft__c)
                                    {
                                        if(x == 0)
                                        {
                                            AircraftNewDate = fh.Hours_Date__c;
                                            AircraftNewHour = fh.Hours__c;
                                        }
                                        else if(x < ParamValue)
                                        {
                                            AircraftOldDate = fh.Hours_Date__c;     
                                            AircraftOldHour = fh.Hours__c;
                                        }
                                        else if(ParamValue == 0 || ParamValue == null)
                                        {
                                            if(fh.Hours_Date__c >= oDate)
                                            {
                                                AircraftOldDate = fh.Hours_Date__c;     
                                                AircraftOldHour = fh.Hours__c;
                                            }
                                        }
                                        else break;
                                        x++;                                        
                                    }
                                }
                                if(x >= 1 && AircraftOldDate !=  null && AircraftOldHour != null)
                                {
                                    AverageMonthlyFlightHours = CLS_MonthlyFlightHours.fn_calAverageFlightHours(AircraftNewDate, AircraftOldDate, AircraftNewHour, AircraftOldHour);
                                    if(AverageMonthlyFlightHours > 999)
                                    {
                                        AverageMonthlyFlightHours = 999;
                                    }
                                    Aircraft__c Aircraft = new Aircraft__c(Id=trigger.new[i].Aircraft__c, Average_Monthly_Hours__c = AverageMonthlyFlightHours);
                                    AircraftsToUpdate.add(Aircraft);
                                }
                            }
                        }                       
                    }
                }
                if(FlightHoursForEquipment.size() > 0)  //This section check wheather there is two or more then two records to process for flight hours.
                {
                    if(trigger.new[i].Equipment__c != null && Equipments.get(trigger.new[i].Equipment__c).Average_Monthly_Hours_Override__c == false)
                    {
                        //This section checks whether the hours and the date fields were changed or not.
                        if(trigger.new[i].Hours__c != trigger.old[i].Hours__c || trigger.new[i].Hours_Date__c != trigger.old[i].Hours_Date__c)
                        {
                            if(Equipments.get(trigger.new[i].Equipment__c).Equipment_Type__c == 'Engine')   // This section checks whether Eqipment is of type Engine
                            {
                                Integer x = 0;
                                EquipmentOldDate = null;
                                EqipmentOldHour = 0.0;
                                for(Flight_Hours__c fh : FlightHoursForEquipment)
                                {
                                    if(trigger.new[i].Equipment__c == fh.Equipment__c)
                                    {
                                        if(x == 0)
                                        {
                                            EqipmentNewDate = fh.Hours_Date__c;
                                            EqipmentNewHour = fh.Hours__c;
                                        }
                                        else if(x < ParamValue)
                                        {
                                            EquipmentOldDate = fh.Hours_Date__c;
                                            EqipmentOldHour = fh.Hours__c;
                                        }
                                        else if(ParamValue == 0 || ParamValue == null)
                                        {
                                            if(fh.Hours_Date__c >= oDate)
                                            {
                                                EquipmentOldDate = fh.Hours_Date__c;        
                                                EqipmentOldHour = fh.Hours__c;
                                            }
                                        }   
                                        else break;
                                        x++;                                
                                    }
                                }
                                if(x >= 1  && EquipmentOldDate != null && EqipmentOldHour != null)
                                {
                                    AverageMonthlyFlightHours = CLS_MonthlyFlightHours.fn_calAverageFlightHours(EqipmentNewDate, EquipmentOldDate, EqipmentNewHour, EqipmentOldHour);
                                    if(AverageMonthlyFlightHours > 999)
                                    {
                                        AverageMonthlyFlightHours = 999;
                                    }
                                    Equipment__c Equipment = new Equipment__c(Id = trigger.new[i].Equipment__c, Average_Monthly_Hours__c = AverageMonthlyFlightHours);
                                    EngineToUpdate.add(Equipment);
                                    if(ExuipmentOverride.get(trigger.new[i].Equipment__c).Aircraft__r.Average_Monthly_Hours_Override__c == false)
                                    {
                                        if(serialNumber.containsKey(trigger.new[i].Equipment__c))
                                        {
                                            Aircraft__c Aircraft = new Aircraft__c(Id = serialNumber.get(trigger.new[i].Equipment__c).Aircraft__c, Average_Monthly_Hours__c = AverageMonthlyFlightHours);
                                            AircraftsToUpdateForEngine.add(Aircraft);
                                        }
                                    }
                                }
                            }
                            if(Equipments.get(trigger.new[i].Equipment__c).Equipment_Type__c == 'APU')  // This section checks whether Eqipment is of type APU
                            {
                                Integer x = 0;
                                EquipmentOldDate = null;
                                EqipmentOldHour = 0.0;
                                for(Flight_Hours__c fh : FlightHoursForEquipment)
                                {
                                    if(trigger.new[i].Equipment__c == fh.Equipment__c)
                                    {
                                        if(x == 0)
                                        {
                                            EqipmentNewDate = fh.Hours_Date__c;
                                            EqipmentNewHour = fh.Hours__c;
                                        }
                                        else if(x < ParamValue)
                                        {
                                            EquipmentOldDate = fh.Hours_Date__c;
                                            EqipmentOldHour = fh.Hours__c;
                                        }
                                        else if(ParamValue == 0 || ParamValue == null)
                                        {
                                            if(fh.Hours_Date__c >= oDate)
                                            {
                                                EquipmentOldDate = fh.Hours_Date__c;        
                                                EqipmentOldHour = fh.Hours__c;
                                            }
                                        }
                                        else break;
                                        x++;                                    
                                    }
                                }
                                if(x >= 1  && EquipmentOldDate != null && EqipmentOldHour != null)
                                {
                                    AverageMonthlyFlightHours = CLS_MonthlyFlightHours.fn_calAverageFlightHours(EqipmentNewDate, EquipmentOldDate, EqipmentNewHour, EqipmentOldHour);
                                    if(AverageMonthlyFlightHours > 999)
                                    {
                                        AverageMonthlyFlightHours = 999;
                                    }
                                    Equipment__c Equipment = new Equipment__c(Id = trigger.new[i].Equipment__c, Average_Monthly_Hours__c = AverageMonthlyFlightHours);
                                    APUToUpdate.add(Equipment);
                                }                           
                            }
                        }
                    }
                }   
            }
        }
        catch(Exception e)
        {
            System.debug(e);
        }
    }
    
    //This section actually performs that update operation of the Average Monthly Hours
    try
    {
        if(AircraftsToUpdate.size()>0)
        {
            update CLS_MonthlyFlightHours.fn_getListForUpdateAC(AircraftsToUpdate);
        }
        if(EngineToUpdate.size()>0)
        {
            update CLS_MonthlyFlightHours.fn_getListForUpdateEQ(EngineToUpdate);
        }
        if(APUToUpdate.size()>0)
        {
            update CLS_MonthlyFlightHours.fn_getListForUpdateEQ(APUToUpdate);
        }
        if(AircraftsToUpdateForEngine.size()>0)
        {
            update CLS_MonthlyFlightHours.fn_getListForUpdateAC(AircraftsToUpdateForEngine);
        }
    }
    catch(Exception e)
    {
        System.debug(e);
    }
}