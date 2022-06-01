public class AircraftTriggerHandler {
    
    public static void AircraftBeforeInsert(List<Aircraft__c> ac){
        Set<String> prodLine = new Set<String>();
        
        for(aircraft__c a : ac){
            prodLine.add(a.Aircraft_Model_2011__c);                            
        }
        
        Map<String, Aircraft_Prefix__mdt> cmdMap = new Map<String, Aircraft_Prefix__mdt>();
        for(Aircraft_Prefix__mdt ap : [Select Aircraft_Model__c, Aircraft_Prefix__c from Aircraft_Prefix__mdt where Aircraft_Model__c In: prodLine]){
            cmdMap.put(ap.Aircraft_Model__c, ap);
        }
        
        for(aircraft__c a : ac){
            if(cmdMap.get(a.Aircraft_Model_2011__c) != null && a.Name != 'NA'){
                try{
                    a.name = cmdMap.get(a.Aircraft_Model_2011__c).Aircraft_Prefix__c + a.Aircraft_SN__c;
                    a.System_Aircraft_Name__c = cmdMap.get(a.Aircraft_Model_2011__c).Aircraft_Prefix__c + a.Aircraft_SN__c;
                }catch (Exception e){
                    system.debug(e.getMessage());
                }
            }
        }        
    }
    
    public static void AircraftBeforeUpdate(Map<Id, Aircraft__c> ac){
        
        Set<String> prodLine = new Set<String>();
        
        for(aircraft__c a : ac.Values()){
            prodLine.add(a.Aircraft_Model_2011__c);
        }
        
        Map<String, Aircraft_Prefix__mdt> cmdMap = new Map<String, Aircraft_Prefix__mdt>();
        for(Aircraft_Prefix__mdt ap : [Select Aircraft_Model__c, Aircraft_Prefix__c from Aircraft_Prefix__mdt where Aircraft_Model__c In: prodLine]){
            cmdMap.put(ap.Aircraft_Model__c, ap);
        } 
        
        Map<Id, List<Id>> equipMap = new Map<Id, List<Id>>();
        Map<Id, Id> apuMap = new Map<Id, Id>();
        
        for(Equipment__c e : [Select Id, name, Aircraft__c from Equipment__c where Aircraft__c In: ac.Keyset() and Equipment_Prefix__c !=: 'APU' and Aircraft__r.Name != 'NA' Order By EnginePosition__c asc]){
            if(equipMap.containsKey(e.Aircraft__c)){
                List<Id> equipId = equipMap.get(e.Aircraft__c);
                equipId.add(e.Id);
                equipMap.put(e.Aircraft__c, equipId);
            }else{
                equipMap.put(e.Aircraft__c, new List<Id> {e.Id});
            }
        }
        
        for(Equipment__c apu : [Select Id, Aircraft__c from Equipment__c where Aircraft__c In: ac.Keyset() and Equipment_Prefix__c =: 'APU' and Aircraft__r.Name != 'NA']){
            apuMap.put(apu.Aircraft__c, apu.Id);
        }
        
        for(Aircraft__c a: ac.Values()){ 
            if(a.name != 'NA') {
                if(cmdMap.get(a.Aircraft_Model_2011__c) != null){
                    try{
                        a.System_Aircraft_Name__c = cmdMap.get(a.Aircraft_Model_2011__c).Aircraft_Prefix__c + a.Aircraft_SN__c;   
                        a.name = cmdMap.get(a.Aircraft_Model_2011__c).Aircraft_Prefix__c + a.Aircraft_SN__c;                      
                    }catch (Exception e){
                        system.debug(e.getMessage()); 
                    }
                }
                
                Integer j = 0;
                a.apu__c = null;
                a.Engine_1__c = null;
                a.Engine_2__c = null;
                a.Engine_3__c = null;             	
                a.Engine_4__c = null;
                
                if(apuMap.get(a.Id) != null)       
                    a.apu__c = apuMap.get(a.Id);         
                
                if(equipMap.get(a.Id) != null){
                    
                    if(equipMap.get(a.Id).Size() > 4){
                        j = 4;
                    }else{
                        j = equipMap.get(a.Id).Size();    
                    }
                    
                    for (Integer i = 0; i < j; i++){
                        String engine = 'Engine_' + (i + 1) + '__c';
                        system.debug('Engine: ' + engine);
                        a.put(engine, equipMap.get(a.Id)[i]);
                    }
                }
            }
        }           
    } 
    
    public static void AircraftAfterInsert(Map<Id,Aircraft__c> ac){
        Map<Id, Id> acNewAccountMap = new Map<Id, Id>();        
        
        for (Aircraft__c aircraft : ac.values())
            acNewAccountMap.put(aircraft.Id, aircraft.Account__c);
        
        if(acNewAccountMap.size() > 0) 
            AircraftContacts(acNewAccountMap);
    }
    
    public static void AircraftAfterUpdate(Map<Id,Aircraft__c> ac, Map<Id, Aircraft__c> oldAcValue){    
        
        Map<Id, Id> acNewAccountMap = new Map<Id, Id>();        
        Map<ID, Aircraft__c> transferredAircraftMap = new Map<ID, Aircraft__c>();
        for (Aircraft__c aircraft : ac.values()){
            
            // if the Account changed, then modify the related list items
            if (aircraft.Account__c != oldAcValue.get(aircraft.Id).Account__c) {
                transferredAircraftMap.put(aircraft.Id, aircraft);
                
                //Associates Contacts Per Contact to Aircraft
                acNewAccountMap.put(aircraft.Id, aircraft.Account__c);
            }
        }
        
        System.debug('Aircraft records whose equipment will be transferred: ' + transferredAircraftMap);
        
        if (transferredAircraftMap.values().size() > 0) {
            // update all related Equipment records
            List<Equipment__c> transferredEquipmentList = [select Id, Account__c, Aircraft__c from Equipment__c where Aircraft__c in: transferredAircraftMap.keySet()];
            
            System.debug('Transferred equipment: ' + transferredEquipmentList);
            
            for (Equipment__c transferredEquipment : transferredEquipmentList) {
                transferredEquipment.Account__c = transferredAircraftMap.get(transferredEquipment.Aircraft__c).Account__c;
            }
            
            if (transferredEquipmentList.size() > 0)
                update transferredEquipmentList;
        }
        
        if(acNewAccountMap.size() > 0)   
            AircraftContacts(acNewAccountMap);
    }
    
    public static void AircraftContacts(Map<Id, Id> ac){
        
        Map<Id, List<Id>> contactMap = new Map<Id, List<Id>>();

        List<Aircraft_Contacts__c> acContactNewList = new List<Aircraft_Contacts__c>();
        List<Aircraft_Contacts__c> acContactOldList = new List<Aircraft_Contacts__c>([Select Id from Aircraft_Contacts__c where Aircraft__c in: ac.keyset()]);
        
        for(Contact c : [Select Id, AccountId from Contact where AccountId =: ac.values()]){
            
            if(contactMap.containsKey(c.AccountId)) {   
                List<Id> contactsId = contactMap.get(c.AccountId);
                contactsId.add(c.Id);
                contactMap.put(c.AccountId, contactsId);
            } else {
                contactMap.put(c.AccountId, new List<Id> { c.Id });
            }
        }
        
        for(Id i : ac.keyset()){
            system.debug('Id: ' + i);
            if(contactMap.get(ac.get(i)) != null){
                for(Id cId : contactMap.get(ac.get(i))){           
                    system.debug('Aircraft: ' + i + ' Contact: ' + cId);
                    
                    Aircraft_Contacts__c newAC_Contact = new Aircraft_Contacts__c();
                    newAC_Contact.Contact__c = cId;
                    newAC_Contact.Aircraft__c = i;
                    acContactNewList.add(newAC_Contact); 
                }
            }
        }
        
        if(!acContactNewList.IsEmpty() && acContactNewList != null)
            Insert acContactNewList;
        
        if(!acContactOldList.IsEmpty() && acContactOldList != null)
            delete acContactOldList;      
    }     
}