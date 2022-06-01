trigger CreateUser on Contact (before insert) {

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

/*Set<Id> contactIds = new Set<Id>();
Account a = [Select Id, Name from Account where Name = 'NBAA Vegas - 2019'];

if(!System.isFuture() && !System.isBatch()){

for(Contact c : Trigger.New) {
if(c.AccountId == a.Id)
contactIds.add(c.Id);           
}

if(contactIds.Size() > 0)
CreateUserHandler.createUserFromContact(contactIds);
} 
    Set<String> emailids = new Set<String>();
    for(Contact c:trigger.new){
        if(c.email!=null)
            emailids.add(c.email);
    }
    
    List<Contact> cons =[Select id,email from contact where email in:emailids];
    
    Map<String ,Contact> mapofContacts = new Map<String,Contact>();
    
    For(Contact con: cons) {
        mapofContacts.put(con.email ,con);        
    }
    
    for(Contact cn:trigger.new){
        if(mapofContacts.containsKey(cn.email)) {
            cn.addError('Contact already Exists: '+ mapofContacts.get(cn.email).id); 
        }
    }*/