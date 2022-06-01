trigger ContactTrigger on Contact (before insert, after update, after insert) {
    
    if(Trigger.isBefore){
        Set<Id> pIds = new Set<Id>();
        List<Id> accountIds = new List<Id>();
        Map<Id, Id> accountOwnerIdMap = new Map<Id, Id>();
        
        //look up community profiles and add them to the set
        for(Profile p : [Select Id from Profile where UserType =: 'PowerCustomerSuccess']){      
            pIds.add(p.Id);
        }
        
        // all the accounts whose owner ids to look up
        for ( Contact c : Trigger.new ) {
            accountIds.add( c.accountId );
        }
        
        // look up each account created by Id
        // if the account is created it will be by an internal user
        for ( Account acct : [ SELECT id, CreatedById FROM account WHERE id IN :accountIds ] ) {
            accountOwnerIdMap.put( acct.id, acct.CreatedById );
        }
        
        // change contact owner to its account owner
        if(pIds.contains(userInfo.getProfileId())){        
            for ( Contact c : Trigger.new ) {
                c.ownerId = accountOwnerIdMap.get( c.accountId );
            }
        }
    }
    
    if(Trigger.isAfter && Trigger.isInsert){ 
        Map<Id, Id> contactMap = new Map<Id, Id>();
        
        for(Contact c : Trigger.new){
            if(c.AccountId != null)
                contactMap.put(c.id, c.AccountId);
        }
        
        if(!contactMap.IsEmpty()){       
            Map<Id, List<Id>> equipMap = new Map<Id, List<Id>>();
            Map<Id, List<Id>> acMap = new Map<Id, List<Id>>();
            
            List<Equipment_Contacts__c> eqContactNewList = new List<Equipment_Contacts__c>();
            List<Aircraft_Contacts__c> acContactNewList = new List<Aircraft_Contacts__c>();
            
            //Equipment
            for(Equipment__c e : [Select Id, Account__c from Equipment__c where Account__c In: contactMap.values()]){         
                if(equipMap.containsKey(e.Account__c)) {   
                    List<Id> equipIds = equipMap.get(e.Account__c);
                    equipIds.add(e.Id);
                    equipMap.put(e.Account__c, equipIds);
                } else {
                    equipMap.put(e.Account__c, new List<Id> { e.Id });
                }
            }
            
            //Airframe
            for(Aircraft__c a : [Select Id, Account__c from Aircraft__c where Account__c In: contactMap.values()]){            
                if(acMap.containsKey(a.Account__c)) {   
                    List<Id> acIds = acMap.get(a.Account__c);
                    acIds.add(a.Id);
                    acMap.put(a.Account__c, acIds);
                } else {
                    acMap.put(a.Account__c, new List<Id> { a.Id });
                }
            }
            
            //for bulkification need contact map
            //Equipment
            for(Id i : contactMap.keyset()){
                system.debug('Id: ' + i);
                if(equipMap.get(contactMap.get(i)) != null){
                    for(Id eId : equipMap.get(contactMap.get(i))){           
                        system.debug('Equipment: ' + eId + ' Contact: ' + i);
                        
                        Equipment_Contacts__c newEQ_Contact = new Equipment_Contacts__c();
                        newEQ_Contact.Contact__c = i;
                        newEQ_Contact.Equipment__c = eId;
                        eqContactNewList.add(newEQ_Contact); 
                    }
                }
            }
            
            //Airframe
            for(Id i : contactMap.keyset()){
                system.debug('Id: ' + i);
                if(acMap.get(contactMap.get(i)) != null){
                    for(Id aId : acMap.get(contactMap.get(i))){           
                        system.debug('Airframe: ' + aId + ' Contact: ' + i);
                        
                        Aircraft_Contacts__c newAC_Contact = new Aircraft_Contacts__c();
                        newAC_Contact.Contact__c = i;
                        newAC_Contact.Aircraft__c = aId;
                        acContactNewList.add(newAC_Contact); 
                    }
                }
            }
            
            if(!eqContactNewList.IsEmpty() && eqContactNewList != null)
                Insert eqContactNewList;
            
            if(!acContactNewList.IsEmpty() && acContactNewList != null)
                Insert acContactNewList;
            
        }
    } 
    
    if(Trigger.isAfter && Trigger.isUpdate){ 
        Map<Id, Id> contactMap = new Map<Id, Id>();
        Set<Id> oldContactIds = new Set<Id>();
        
        List<Aircraft_Contacts__c> deleteAC_Contacts = new List<Aircraft_Contacts__c>();
        List<Equipment_Contacts__c> deleteEQ_Contacts = new List<Equipment_Contacts__c>();
        
        List<Equipment_Contacts__c> eqContactNewList = new List<Equipment_Contacts__c>();
        List<Aircraft_Contacts__c> acContactNewList = new List<Aircraft_Contacts__c>();
        
        for(Contact c : Trigger.new){
            if(c.AccountId != null && c.AccountId != Trigger.oldMap.get(c.Id).AccountId ){
                contactMap.put(c.id, c.AccountId);
            	oldContactIds.add(c.Id);
            }
        }
        
        if(!contactMap.IsEmpty()){ 
            Map<Id, List<Id>> equipMap = new Map<Id, List<Id>>();
            Map<Id, List<Id>> acMap = new Map<Id, List<Id>>();
                      
            //Equipment
            for(Equipment__c e : [Select Id, Account__c from Equipment__c where Account__c In: contactMap.values()]){         
                if(equipMap.containsKey(e.Account__c)) {   
                    List<Id> equipIds = equipMap.get(e.Account__c);
                    equipIds.add(e.Id);
                    equipMap.put(e.Account__c, equipIds);
                } else {
                    equipMap.put(e.Account__c, new List<Id> { e.Id });
                }
            }
            
            //Airframe
            for(Aircraft__c a : [Select Id, Account__c from Aircraft__c where Account__c In: contactMap.values()]){            
                if(acMap.containsKey(a.Account__c)) {   
                    List<Id> acIds = acMap.get(a.Account__c);
                    acIds.add(a.Id);
                    acMap.put(a.Account__c, acIds);
                } else {
                    acMap.put(a.Account__c, new List<Id> { a.Id });
                }
            }
            
            //for bulkification need contact map
            //Equipment
            for(Id i : contactMap.keyset()){
                system.debug('Id: ' + i);
                if(equipMap.get(contactMap.get(i)) != null){
                    for(Id eId : equipMap.get(contactMap.get(i))){           
                        system.debug('Equipment: ' + eId + ' Contact: ' + i);
                        
                        Equipment_Contacts__c newEQ_Contact = new Equipment_Contacts__c();
                        newEQ_Contact.Contact__c = i;
                        newEQ_Contact.Equipment__c = eId;
                        eqContactNewList.add(newEQ_Contact); 
                    }
                }
            }
            
            //Airframe
            for(Id i : contactMap.keyset()){
                system.debug('Id: ' + i);
                if(acMap.get(contactMap.get(i)) != null){
                    for(Id aId : acMap.get(contactMap.get(i))){           
                        system.debug('Airframe: ' + aId + ' Contact: ' + i);
                        
                        Aircraft_Contacts__c newAC_Contact = new Aircraft_Contacts__c();
                        newAC_Contact.Contact__c = i;
                        newAC_Contact.Aircraft__c = aId;
                        acContactNewList.add(newAC_Contact); 
                    }
                }
            }                       
        }
        
        if(oldContactIds.Size() > 0){
            deleteAC_Contacts = [Select Id from Aircraft_Contacts__c where Contact__c In: oldContactIds];
            deleteEQ_Contacts = [Select Id from Equipment_Contacts__c where Contact__c In: oldContactIds];
        }
        
        if(deleteEQ_Contacts.Size() > 0)
            delete deleteEQ_Contacts;
        
        if(deleteAC_Contacts.Size() > 0)
            delete deleteAC_Contacts;
        
        if(!eqContactNewList.IsEmpty() && eqContactNewList != null)
            Insert eqContactNewList;
        
        if(!acContactNewList.IsEmpty() && acContactNewList != null)
            Insert acContactNewList;
    }
}