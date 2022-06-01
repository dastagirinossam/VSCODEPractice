public class EquipmentTriggerHandler {
    
    public static Aircraft__c NA = [Select Id from Aircraft__c where Name =: 'NA']; 
    
    public static void EquipmentBefore(List<Equipment__c> eq){              
        for(Equipment__c e : eq){
            
            if(e.Aircraft__c == null)
                e.Aircraft__c = NA.id;
            
        }
    }
    
    public static void EquipmentAfter(Map<Id, Equipment__c> eq, Map<Id, Equipment__c> oldEqValue){        
        Map<Id, Id> eqNewAccountMap = new Map<Id, Id>(); 
        Set<Id> Aircraft = new Set<Id>();
        
        for (Equipment__c equipment : eq.values()) {
            system.debug('Equipment: ' + equipment.Id);
            
            // if the Account changed, then modify the related list items
            if(trigger.isUpdate){
                if (equipment.Account__c != oldEqValue.get(equipment.Id).Account__c) {
                    
                    //Associates Contacts Per Contact to Aircraft
                    eqNewAccountMap.put(equipment.Id, equipment.Account__c);
                }
                
                if (equipment.Aircraft__c != oldEqValue.get(equipment.Id).Aircraft__c) {
                    
                    //Associates Equipment to Aircraft
                    if(equipment.Aircraft__c != NA.Id)
                    	Aircraft.Add(equipment.Aircraft__c);
                    
                    if(oldEqValue.get(equipment.Id).Aircraft__c != NA.Id)
                    	Aircraft.Add(oldEqValue.get(equipment.Id).Aircraft__c);
                }
                
            }else{
                eqNewAccountMap.put(equipment.Id, equipment.Account__c);
                Aircraft.Add(equipment.Aircraft__c);
            }      
        }
        
        if(eqNewAccountMap.values().size() > 0)
            EquipmentContacts(eqNewAccountMap);
        
        if(!Aircraft.IsEmpty() && Aircraft != null)
            AircraftEquipment(Aircraft);
        
    }
    
    public static void EquipmentContacts(Map<Id, Id> eq){

        Map<Id, List<Id>> contactMap = new Map<Id, List<Id>>();

        List<Equipment_Contacts__c> eqContactNewList = new List<Equipment_Contacts__c>();
        List<Equipment_Contacts__c> eqContactOldList = new List<Equipment_Contacts__c>([Select Id from Equipment_Contacts__c where Equipment__c in: eq.keyset()]);
        
        for(Contact c : [Select Id, AccountId from Contact where AccountId =: eq.values()]){
            
            if(contactMap.containsKey(c.AccountId)) {   
                List<Id> contactsId = contactMap.get(c.AccountId);
                contactsId.add(c.Id);
                contactMap.put(c.AccountId, contactsId);
            } else {
                contactMap.put(c.AccountId, new List<Id> { c.Id });
            }
        }
        
        for(Id i : eq.keyset()){
            system.debug('Id: ' + i);
            if(contactMap.get(eq.get(i)) != null){
                for(Id cId : contactMap.get(eq.get(i))){           
                    system.debug('Equipment: ' + i + ' Contact: ' + cId);
                    
                    Equipment_Contacts__c newEQ_Contact = new Equipment_Contacts__c();
                    newEQ_Contact.Contact__c = cId;
                    newEQ_Contact.Equipment__c = i;
                    eqContactNewList.add(newEQ_Contact); 
                }
            }
        }
        
        if(!eqContactNewList.IsEmpty() && eqContactNewList != null)
            Insert eqContactNewList;
        
        if(!eqContactOldList.IsEmpty() && eqContactOldList != null)
            delete eqContactOldList;      
    }  
    
    public static void AircraftEquipment(Set<Id> Aircraft){
        
        Map<Id, Aircraft__c> ac = new Map<Id, Aircraft__c>([Select Id, apu__c, Engine_1__c, Engine_2__c, Engine_3__c, Engine_4__c from Aircraft__c where Id In: Aircraft]);
        
        Map<Id, List<Id>> equipMap = new Map<Id, List<Id>>();
        Map<Id, Id> apuMap = new Map<Id, Id>();
        
        for(Equipment__c e : [Select Id, name, Aircraft__c from Equipment__c where Aircraft__c In: ac.keySet() and Equipment_Prefix__c !=: 'APU' and Aircraft__r.Name != 'NA' Order By Name]){
            if(equipMap.containsKey(e.Aircraft__c)){
                List<Id> equipId = equipMap.get(e.Aircraft__c);
                equipId.add(e.Id);
                equipMap.put(e.Aircraft__c, equipId);
            }else{
                equipMap.put(e.Aircraft__c, new List<Id> {e.Id});
            }
        }
        
        for(Equipment__c apu : [Select Id, Aircraft__c from Equipment__c where Aircraft__c In: ac.keySet() and Equipment_Prefix__c =: 'APU' and Aircraft__r.Name != 'NA']){
            apuMap.put(apu.Aircraft__c, apu.Id);
        }
        
        for(Aircraft__c a: ac.Values()){ 
            
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
        
        update ac.Values();        
    }     
}