Public Class ProjectsTriggerHelper{    
    
    public static Boolean runOnceBefore = true;
    public static Boolean runOnceAfter = true;
    
    public static List<Equipment__c> noEquip = [Select Id from Equipment__c where name =: 'NA'];
    
    public static void BeforeInsertProject(List<MPM4_BASE__Milestone1_Project__c> projects){
        
        Set<id> engineId = new Set<id>();
        Set<id> accountId = new Set<id>();
        Set<id> aircraftId = new Set<id>();
        
        for(MPM4_BASE__Milestone1_Project__c proj: projects){            
            if(proj.Engine__c != null)
                engineId.add(proj.Engine__c);
            
            accountId.add(proj.MPM4_BASE__Account__c);
            aircraftId.add(proj.Aircraft__c);
        }
        
        Map<Id, Account> accountMap = new Map<Id, Account>([Select Id, Name from Account where Id In: accountId]);
        Map<Id, Aircraft__c> aircraftMap = new Map<Id, Aircraft__c>([Select Id, Name from Aircraft__c where Id In: aircraftId]);
        Map<Id, Equipment__c> engineMap = new Map<Id, Equipment__c>([Select Id, Name from Equipment__c where Id In: engineId]);        
        
        for(MPM4_BASE__Milestone1_Project__c proj: projects){
            
            String strName;
            
            if(proj.Project_Type__c != 'Engine')
                strName = accountMap.get(proj.MPM4_BASE__Account__c).Name + ' - ' + aircraftMap.get(proj.Aircraft__c).Name + ' - ' + proj.Input_Date__c.Month() + '/' + proj.Input_Date__c.Day() + '/' + proj.Input_Date__c.Year();
            
            if(proj.Project_Type__c == 'Engine')
                strName = accountMap.get(proj.MPM4_BASE__Account__c).Name + ' - ' + engineMap.get(proj.Engine__c).Name + ' - ' + proj.Input_Date__c.Month() + '/' + proj.Input_Date__c.Day() + '/' + proj.Input_Date__c.Year();
            
            if (strName.length() > 80)
                strName = strName.mid(0,79);
            
            if(engineId == null || engineId.isEmpty())            
                proj.Engine__c = noEquip[0].id;                
            
            proj.Name = strName;            
            proj.MPM4_BASE__Kickoff__c = proj.Input_Date__c;
            proj.MPM4_BASE__Deadline__c = proj.Delivery_Date__c; 
            
        }
    }
    
    public static void AfterInsertProject(Map<Id, MPM4_BASE__Milestone1_Project__c> projectMap){
        
        Set<Id> projects = new Set<Id>();
        Set<Id> accountIds = new Set<Id>();
        
        Map<Id, Set<Id>> approverMap = new Map<Id, Set<Id>>();
        Map<Id, Map<Id, String>> internalMap = new Map<Id, Map<Id, String>>();
            
        for(MPM4_BASE__Milestone1_Project__c proj : projectmap.values()){
            accountIds.add(proj.MPM4_BASE__Account__c);
        }
        
        Map<Id, Account> accountMap = new Map<Id, Account>([Select Id, OwnerId from Account where Id In: accountIds]);
        
        for(MPM4_BASE__Milestone1_Project__c proj : projectmap.values()){
            Map<Id, String> iMap = new Map<Id, String>();
            iMap.put(accountMap.get(proj.MPM4_BASE__Account__c).OwnerId, 'Account_Owner__c');
                            
            if(proj.Administrator__c != null)
            	iMap.put(proj.Administrator__c, 'Admin_Access__c');  
            
            if(proj.BackupCPM__c != null)
               iMap.put(proj.BackupCPM__c, 'BackUp_CPM_Access__c');
            
            if(proj.Engine_CPM__c != null)
                iMap.put(proj.Engine_CPM__c, 'Engine_CPM_Access__c');
            
            if(proj.CPM__c != null)
                iMap.put(proj.CPM__c, 'CPM_Access__c');
            
            internalMap.put(proj.Id, iMap);
                        
            if(proj.MPM4_BASE__Status__c == 'Active' || proj.MPM4_BASE__Status__c == 'On Hold' || proj.MPM4_BASE__Status__c =='Completed'){             
                Set<Id> Approvers = new Set<Id>();
                
                if(proj.Designated_Approver__c != null)
                    approvers.add(proj.Designated_Approver__c);
                
                if(proj.Secondary_Approver__c != null)
                    approvers.add(proj.Secondary_Approver__c);
                
                if(proj.X3_Approver__c != null)
                    approvers.add(proj.X3_Approver__c);
                
                if(proj.X4_Approver__c != null)
                    approvers.add(proj.X4_Approver__c);
                
                if(proj.X5_Approver__c != null)
                    approvers.add(proj.X5_Approver__c);
                
                if(proj.X6_Approver__c != null)
                    approvers.add(proj.X6_Approver__c);
                
                if(!Approvers.IsEmpty())
                    approverMap.put(proj.id, Approvers);               
            }
        }
        
        if(!internalMap.IsEmpty())
            CreateInternalShareRecords(internalMap);
        
        if(!approverMap.IsEmpty())
            CreateShareRecord(projectMap, approverMap);        
    }
    
    public static void BeforeUpdateProject(Map<Id, MPM4_BASE__Milestone1_Project__c> projectMap, Map<Id, MPM4_BASE__Milestone1_Project__c> oldProjectMap){
        
        Map<Id, Set<Id>> approverMap = new Map<Id, Set<Id>>();
        Map<Id, MPM4_BASE__Milestone1_Project__c> projMap = new Map<Id, MPM4_BASE__Milestone1_Project__c>();
        
        for(MPM4_BASE__Milestone1_Project__c proj : projectmap.values()){
            
            Set<Id> Approvers = new Set<Id>();
            Boolean changedStatus = false;
            
            if(
                (proj.Designated_Approver__c != oldProjectMap.get(proj.Id).Designated_Approver__c) ||
                (proj.Secondary_Approver__c != oldProjectMap.get(proj.Id).Secondary_Approver__c) ||
                (proj.X3_Approver__c != oldProjectMap.get(proj.Id).X3_Approver__c) ||
                (proj.X4_Approver__c != oldProjectMap.get(proj.Id).X4_Approver__c) ||
                (proj.X5_Approver__c != oldProjectMap.get(proj.Id).X5_Approver__c) ||
                (proj.X6_Approver__c != oldProjectMap.get(proj.Id).X6_Approver__c)
            ){
                approvers.add(proj.Designated_Approver__c);                
                approvers.add(proj.Secondary_Approver__c);                
                approvers.add(proj.X3_Approver__c);                
                approvers.add(proj.X4_Approver__c);                
                approvers.add(proj.X5_Approver__c);               
                approvers.add(proj.X6_Approver__c); 
                approvers.remove(null);
                system.debug(approvers);
                approverMap.put(proj.id, approvers);
            }
            
            if(proj.MPM4_BASE__Status__c != oldProjectMap.get(proj.Id).MPM4_BASE__Status__c || proj.Do_Not_Share_Project__c != oldProjectMap.get(proj.Id).Do_Not_Share_Project__c)
                changedStatus = true;
            
            //Deletes Share Records and Removes Force Follow Because of Status
            if(proj.MPM4_BASE__Status__c != 'Active' && proj.MPM4_BASE__Status__c != 'On Hold' && proj.MPM4_BASE__Status__c != 'Completed'){                            
                if(changedStatus)                   
                    proj.Pending_Squawks__c = 0;                
            }
            
            if(proj.MPM4_BASE__Status__c == 'Active' || proj.MPM4_BASE__Status__c == 'On Hold' || proj.MPM4_BASE__Status__c == 'Completed'){
                if(changedStatus)                   
                    projMap.put(proj.Id, proj);                
            }
        }
        
        if(!projMap.IsEmpty())
            GetPendingSquawks(projMap);
        
        if(!approverMap.IsEmpty())
            updateApproversGapPrevention(projectmap, approverMap);     
    }
    
    public static void AfterUpdateProject(Map<Id, MPM4_BASE__Milestone1_Project__c> projectMap, Map<Id, MPM4_BASE__Milestone1_Project__c> oldProjectMap){        
        System.debug('after update project ');
      
        Set<Id> projects = new Set<Id>();
        
        Map<Id, Set<Id>> approverMap = new Map<Id, Set<Id>>();
        Map<Id, Set<Id>> updateApproverMap = new Map<Id, Set<Id>>();
        
        Map<Id, Set<Id>> changeMap = new Map<Id, Set<Id>>();
        
        Map<Id, Id> dsMap = new Map<Id, Id>();
        Map<Id, Map<Id, String>> createShareMap = new Map<Id, Map<Id, String>>();

        Map<Id, MPM4_BASE__Milestone1_Project__c> projMap = new Map<Id, MPM4_BASE__Milestone1_Project__c>();
        
        for(MPM4_BASE__Milestone1_Project__c proj : projectmap.values()){
            
            Set<Id> Approvers = new Set<Id>();
            Boolean changedApprovers = false;
            Boolean changedStatus = false;
            
            Map<Id, String> csMap = new Map<Id, String>();
                       
            if(proj.MPM4_BASE__Status__c != oldProjectMap.get(proj.Id).MPM4_BASE__Status__c || proj.Do_Not_Share_Project__c != oldProjectMap.get(proj.Id).Do_Not_Share_Project__c)
                changedStatus = true;
            
            //Admin Share Create/Delete
            if(proj.Administrator__c != oldProjectMap.get(proj.Id).Administrator__c){
                if(proj.Administrator__c != null)
                    csMap.put(proj.Administrator__c, 'Admin_Access__c');
                
                dsMap.put(oldProjectMap.get(proj.Id).Administrator__c, proj.Id);
            }
            
            if(proj.Engine_CPM__c != oldProjectMap.get(proj.Id).Engine_CPM__c){
                if(proj.Engine_CPM__c != null)
                    csMap.put(proj.Engine_CPM__c, 'Engine_CPM_Access__c');
                
                dsMap.put(oldProjectMap.get(proj.Id).Engine_CPM__c, proj.Id);
            }
            
            if(proj.CPM__c != oldProjectMap.get(proj.Id).CPM__c){
                if(proj.CPM__c != null)
                    csMap.put(proj.CPM__c, 'CPM_Access__c');
                
                dsMap.put(oldProjectMap.get(proj.Id).CPM__c, proj.Id);
            }
            
            if(proj.BackupCPM__c != oldProjectMap.get(proj.Id).BackupCPM__c){
                if(proj.BackupCPM__c != null)
                    csMap.put(proj.BackupCPM__c, 'BackUp_CPM_Access__c');
                
                dsMap.put(oldProjectMap.get(proj.Id).BackupCPM__c, proj.Id);
            }
            
            if(!csMap.IsEmpty())
                createShareMap.put(proj.Id, csMap);
                                       
            if(
                (proj.Designated_Approver__c != oldProjectMap.get(proj.Id).Designated_Approver__c && !changedApprovers) ||
                (proj.Secondary_Approver__c != oldProjectMap.get(proj.Id).Secondary_Approver__c && !changedApprovers) ||
                (proj.X3_Approver__c != oldProjectMap.get(proj.Id).X3_Approver__c && !changedApprovers) ||
                (proj.X4_Approver__c != oldProjectMap.get(proj.Id).X4_Approver__c && !changedApprovers) ||
                (proj.X5_Approver__c != oldProjectMap.get(proj.Id).X5_Approver__c && !changedApprovers) ||
                (proj.X6_Approver__c != oldProjectMap.get(proj.Id).X6_Approver__c && !changedApprovers)
            ){
                changedApprovers = true;
            }
            
            approvers.add(proj.Designated_Approver__c);
            approvers.add(proj.Secondary_Approver__c);
            approvers.add(proj.X3_Approver__c);
            approvers.add(proj.X4_Approver__c);
            approvers.add(proj.X5_Approver__c);
            approvers.add(proj.X6_Approver__c);                             
            approvers.remove(null);
            
            if(proj.MPM4_BASE__Status__c == 'Active' || proj.MPM4_BASE__Status__c == 'On Hold' || proj.MPM4_BASE__Status__c == 'Completed'){
                //Change Designated Approvers
                //Changes Approvers on Pending Squawks
                //Resets Force follow and Share Records
                if(!Approvers.IsEmpty() && changedApprovers)
                    approverMap.put(proj.id, approvers);
                
                //Approvers Have Not Changed But Status Changed From Planning to Active, On Hold, Completed
                //Create Share Records/ForceFollow
                if(!Approvers.IsEmpty() && (changedStatus && !changedApprovers))
                    changeMap.put(proj.id, approvers);
                
                //Change Sharing On Project, Quote
                if(!Approvers.IsEmpty() && (proj.Do_Not_Share_Project__c != oldProjectMap.get(proj.Id).Do_Not_Share_Project__c))
                    changeMap.put(proj.id, approvers);
                
            }
            
            //Deletes Share Records and Removes Force Follow Because of Status
            if(proj.MPM4_BASE__Status__c != 'Active' && proj.MPM4_BASE__Status__c != 'On Hold' && proj.MPM4_BASE__Status__c != 'Completed'){                
                
                if(!Approvers.IsEmpty() && changedApprovers)
                    updateApproverMap.put(proj.id, approvers);
                
                if(changedStatus)
                    projMap.put(proj.Id, proj);             
            }
        }
        
        //Deletes Share Records
        //Updates Approvers to Quotes and Quotelines that are pending or no status
        //Creates New Share Record Accordingly
        if(!approverMap.IsEmpty()){
            updateQuoteLineApprovers(projectMap, approverMap);
            
            //Clears Share Records and Resets Force Following
            DeleteShareRecord(projectMap);              
            CreateShareRecord(projectMap, approverMap);
        }
        
        if(!updateApproverMap.IsEmpty())
            updateQuoteLineApprovers(projectMap, updateApproverMap);  
        
        //If Create Share Record for Internal Team
        if(!createShareMap.IsEmpty())
            CreateInternalShareRecords(createShareMap);
        
        //Delete Internal Share Record
        system.debug('dsMap: ' + dsMap.values());
        if(!dsMap.IsEmpty())
            deleteInternalShareRecord(dsMap);
                       
        //Only Create Share Records Because of Status Change
        if(!changeMap.IsEmpty())
            CreateShareRecord(projectMap, changeMap);
        
        //Deletes Share Records and Removes Force Follow
        if(!projMap.IsEmpty())        
            DeleteShareRecord(projMap);
                
    }
      
    //Prevent Gaps In Designated Approvers
    public static void updateApproversGapPrevention(Map<Id, MPM4_BASE__Milestone1_Project__c> projMap, Map<Id, Set<Id>> approverMap){      
        
        for(MPM4_BASE__Milestone1_Project__c proj : projMap.values()){
            
            List<Id> Approvers = new List<Id>();
            
            Approvers.addAll(approverMap.get(proj.Id));
            system.debug('Approvers: ' + approvers);
            for(Integer i = 0; i < 6; i++){  
                system.debug(i);
                system.debug('APS: ' + approvers.Size());
                if(i == 0){
                    proj.Designated_Approver__c = approvers[0];                              
                }else if(i == 1 && i < approvers.Size()){
                    proj.Secondary_Approver__c = approvers[1];                               
                }else if(i > 1 && i < approvers.Size()){
                    String da = 'X' + (i + 1) + '_Approver__c';
                    proj.put(da, approvers[i]);
                }else{
                    
                    String da = 'X' + (i + 1) + '_Approver__c';
                    
                    if(i == 1)
                        da = 'Secondary_Approver__c';
                    
                    proj.put(da, null);
                }         
            }                         
        }     
    }
    
    //Delete Admin Share Record
    public static void deleteInternalShareRecord(Map<Id, Id> dsMap){
        List<MPM4_BASE__Milestone1_Project__Share> sharesToDelete = new List<MPM4_BASE__Milestone1_Project__Share>();
        List<MPM4_BASE__Milestone1_Project__Share> ps = [SELECT Id, UserOrGroupId, UserOrGroup.Name from MPM4_BASE__Milestone1_Project__Share where ParentId In: dsMap.values()and RowCause != 'Owner'];
        
        for(MPM4_BASE__Milestone1_Project__Share p : ps){
            if(dsMap.get(p.UserOrGroupId) != null)
                sharesToDelete.add(p);
        }
        
        if(sharesToDelete.Size() > 0)
            delete sharesToDelete;
    }
    
    //Creates Internal Share Records
    public static void CreateInternalShareRecords(Map<Id, Map<Id, String>> iMap){
        
        List<MPM4_BASE__Milestone1_Project__Share> sharesToCreate = new List<MPM4_BASE__Milestone1_Project__Share>();       
        for(Id proj: iMap.keyset()){
            Map<Id, String> intMap = iMap.get(proj);
            for(id p : intMap.keyset()){
            MPM4_BASE__Milestone1_Project__Share ps = new MPM4_BASE__Milestone1_Project__Share();
                ps.AccessLevel = 'Edit';
                ps.ParentId = proj;
                ps.RowCause = intMap.get(p);
                ps.UserOrGroupId = p;
                sharesToCreate.add(ps);
            }
        }
        
        if(sharesToCreate.Size() > 0)
            insert sharesToCreate;
    }
        
    //Update QuoteLine Approvers to Match Project
    public static void updateQuoteLineApprovers(Map<Id, MPM4_BASE__Milestone1_Project__c> projectMap, Map<Id, Set<Id>> approverMap){
        
        Map<Id, SBQQ__QuoteLine__c> qlMap = new Map<Id, SBQQ__Quoteline__c>();
        List<SBQQ__QuoteLine__c> sqks = new List<SBQQ__QuoteLine__c>();
        
        For(SBQQ__QuoteLine__c ql : [Select Id, Project__c, SBQQ__ProductName__c, Add_Work_Status__c, Designated_Approver__c, Secondary_Approver__c, X3_Approver__c, X4_Approver__c, X5_Approver__c, X6_Approver__c from SBQQ__QuoteLine__c where Project__c In: projectMap.keyset() and (Add_Work_Status__c = 'Pending' or Add_Work_Status__c = null)]){
            ql.Designated_Approver__c = projectMap.get(ql.Project__c).Designated_Approver__c;
            ql.Secondary_Approver__c = projectMap.get(ql.Project__c).Secondary_Approver__c;
            ql.X3_Approver__c = projectMap.get(ql.Project__c).X3_Approver__c;
            ql.X4_Approver__c = projectMap.get(ql.Project__c).X4_Approver__c;
            ql.X5_Approver__c = projectMap.get(ql.Project__c).x5_Approver__c;
            ql.X6_Approver__c = projectMap.get(ql.Project__c).x6_Approver__c;
            
            if(ql.Add_Work_Status__c == 'Pending'){
                qlMap.put(ql.Id, ql);
                ql.Add_Work_Status__c = null;
            } 
            
            sqks.add(ql);                                         
        }
        
        //Updates Squawks with Projects Designated Approvers
        if(!sqks.IsEmpty())
            update sqks;
        
        //Updates Pending Squawks with Designated Approvers
        if(!qlMap.isEmpty())
            designatedApprovers(qlMap);                
    }
    
    //Update Pending Approvals On Project
    public static void GetPendingSquawks(Map<Id, MPM4_BASE__Milestone1_Project__c> projectMap){
        
        Map<id, Decimal> pendingSquawks = new Map<id, Decimal>();       
        for(AggregateResult ar : [Select Count(Id) totalCount, Project__c from SBQQ__QuoteLine__c where Project__c In: projectMap.keyset() and Add_Work_Status__c = 'Pending' Group By Project__c]){
            pendingSquawks.put((Id)ar.get('Project__c'), (Decimal)ar.get('totalCount'));
        }
        
        if(!pendingSquawks.IsEmpty()){
            for(MPM4_BASE__Milestone1_Project__c p : projectMap.Values()){
                p.Pending_Squawks__c = (decimal)pendingSquawks.get(p.id);
            }
        }              
    }
    
    //Add Designated Approver to Approval Process
    public static void designatedApprovers(Map<Id, SBQQ__QuoteLine__c> qlMap){
        
        List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
        List<Approval.ProcessSubmitRequest> newRequests = new List<Approval.ProcessSubmitRequest>();     
        for(ProcessInstanceWorkItem wi : [SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId IN: qlMap.keyset()]){            
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setWorkitemId(wi.Id);
            req.setAction('Removed');
            req.setComments('Recalled Due To Approver Change');
            requests.add(req);                  
        }
        
        for(Id ql : qlMap.keyset()){
            Approval.ProcessSubmitRequest newReq = new Approval.ProcessSubmitRequest();
            newReq.setObjectId(ql);
            newRequests.add(newReq);             
        }
        
        //Recalls All Pending Approvals
        try{
            Approval.ProcessResult[] processResults = Approval.process(requests);
        }catch(Exception e){
            system.debug('Recall Approval Request Error: ' +e.getMessage());
        }
        
        //Resubmits with updated Approvers
        try{ 
            Approval.ProcessResult[] submitRequests = Approval.process(newRequests, true);           
        }catch(Exception e){
            system.debug('Resubmit for Approval Error: ' + e.getMessage()); 
        }
        
        //Unlocks Records
        Approval.UnlockResult[] qlRecords = Approval.unlock(qlMap.Values(), false); 
        
    }
    
    //Creates Share Record To Make Project Visible In Community
    public static void CreateShareRecord(Map<Id, MPM4_BASE__Milestone1_Project__c> projectMap, Map<Id, Set<Id>> approverMap){
        System.debug('create share record');
        system.debug('projectMap>>'+ approverMap.values());
        //Delete Project Share Records
        List<MPM4_BASE__Milestone1_Project__Share> projectShares = [Select Id from MPM4_BASE__Milestone1_Project__Share where ParentId In: projectMap.keyset() and RowCause = 'Project_Customer_Access__c'];         
        System.debug('create share record '+ projectShares.size());
        if (projectShares != null || !projectShares.isEmpty())
            delete projectShares; 
        
        //Store Approver Ids
        Set<Id> approverIds = new Set<Id>();       
        for(Id am : approverMap.keySet()){
            System.debug('am cr'+am);
            Set<Id> lstId = approverMap.get(am);
            System.debug('amlstIdcr'+lstId);
            for(id i : lstId){
                //check for share records here
                if(!approverIds.contains(i))
                    approverIds.add(i);                                                     
            }        
        }
        
        //Gets User Role
        Map<Id, Id> approverUserMap = new Map<Id, Id>();
        
        for(User u : [Select Id, UserRole.Id FROM User WHERE Profile.Name Like 'Customer Community%' and Id In: approverIds]){
            approverUserMap.put(u.Id, u.UserRole.Id);        
        }
        
        //Gets Designated Approvers Group Ids
        Map<Id, Id> projGroupId = new Map<Id, Id>();
        for(Group g : [Select Id, RelatedId from Group where RelatedId In: approverUserMap.Values() and Type = 'RoleAndSubordinates']){
            projGroupId.put(g.RelatedId, g.Id);
        }
        
        List<MPM4_BASE__Milestone1_Project__Share> sharesToCreate = new List<MPM4_BASE__Milestone1_Project__Share>();
        
        //Loops through Project To Create Share Records If Needed
        for (MPM4_BASE__Milestone1_Project__c proj : projectMap.Values()) {
            
            //loop through designated approvers to create share records
            //if do not share checkbox is checked
            System.debug('hello map'+proj.id);
            if(proj.Do_Not_Share_Project__c){
                Set<Id> lstId = approverMap.get(proj.Id);
                system.debug(lstId);
                for(id i : lstId){
                    MPM4_BASE__Milestone1_Project__Share ps = new MPM4_BASE__Milestone1_Project__Share();
                    ps.AccessLevel = 'Read';
                    ps.ParentId = proj.Id;
                    ps.RowCause = 'Project_Customer_Access__c';
                    ps.UserOrGroupId = i;
                    sharesToCreate.add(ps);                   
                }              
            }else{
                //create share record for Roles and Subordinates
                for(Id i : projGroupId.Keyset()){
                    Set<Id> lstId = approverMap.get(proj.id);
                    for(id da : lstId){
                        if(approverUserMap.get(da) == i){
                            MPM4_BASE__Milestone1_Project__Share ps = new MPM4_BASE__Milestone1_Project__Share();
                            ps.AccessLevel = 'Read';
                            ps.ParentId = proj.Id;
                            ps.RowCause = 'Project_Customer_Access__c';
                            ps.UserOrGroupId = projGroupId.get(i);
                            sharesToCreate.add(ps);
                        }
                    }
                }
            }            
        }
        
        if (!sharesToCreate.isEmpty()){
            insert sharesToCreate;                             
            CreateQuoteShareRecords(projectMap);
        }
        
        ForceFollowProject(projectMap, approverUserMap);
    }
    
    //Force Follow Users For Chatter Communication
    public static void ForceFollowProject(Map<Id, MPM4_BASE__Milestone1_Project__c> projId, Map<Id, Id> approverUserMap){
        
        Network nws = [Select Id from Network where Name =: 'Customer Community'];
        
        List<EntitySubscription> projEntitySubList = new List<EntitySubscription>();
        Map<Id, Id> projectFollowers = new Map<Id, Id>();        
        Map<Id, Id> contactFollowers = new Map<Id, Id>();
        
        //Add values to Map
        for(EntitySubscription es : [SELECT Id, SubscriberId FROM EntitySubscription where ParentId In: projId.KeySet()]){
            projectFollowers.put(es.SubscriberId, es.Id);
        } 
        
        for(MPM4_BASE__Milestone1_Project__c userId : projId.Values()){
            //CPM Force Follow
            if(projectFollowers.get(userId.CPM__c) == null && userId.CPM__c != null){
                EntitySubscription projEntity = new EntitySubscription();
                projEntity.ParentId = userId.Id;
                projEntity.SubscriberId = userId.CPM__c;
                projEntitySubList.add(projEntity); 
            }
            
            //Engine CPM Force Follow
            if(projectFollowers.get(userId.Engine_CPM__c) == null && userId.Engine_CPM__c != null){
                EntitySubscription projEntity = new EntitySubscription();
                projEntity.ParentId = userId.Id;
                projEntity.SubscriberId = userId.Engine_CPM__c;
                projEntitySubList.add(projEntity); 
            }
            
            //BackUp CPM Force Follow
            if(projectFollowers.get(userId.BackupCPM__c) == null && userId.BackupCPM__c != null){
                EntitySubscription projEntity = new EntitySubscription();
                projEntity.ParentId = userId.Id;
                projEntity.SubscriberId = userId.BackupCPM__c;
                projEntitySubList.add(projEntity); 
            }
            
            //Designated Approver
            if(projectFollowers.get(userId.Designated_Approver__c) == null && userId.Designated_Approver__c != null){
                EntitySubscription projEntity = new EntitySubscription();
                projEntity.ParentId = userId.Id;
                projEntity.SubscriberId = userId.Designated_Approver__c;
                if(approverUserMap.get(userId.Designated_Approver__c) != null)
                    projEntity.NetworkId = nws.Id;
                projEntitySubList.add(projEntity);
                contactFollowers.put(userId.Designated_Approver__c, userId.CPM__c);
            }
            
            //Secondary Approver
            if(projectFollowers.get(userId.Secondary_Approver__c) == null && userId.Secondary_Approver__c != null){
                EntitySubscription projEntity = new EntitySubscription();
                projEntity.ParentId = userId.Id;
                projEntity.SubscriberId = userId.Secondary_Approver__c;
                if(approverUserMap.get(userId.Secondary_Approver__c) != null)
                    projEntity.NetworkId = nws.Id;
                projEntitySubList.add(projEntity); 
                contactFollowers.put(userId.Secondary_Approver__c, userId.CPM__c);
            }
            
            //Third Approver
            if(projectFollowers.get(userId.X3_Approver__c) == null && userId.X3_Approver__c != null){
                EntitySubscription projEntity = new EntitySubscription();
                projEntity.ParentId = userId.Id;
                projEntity.SubscriberId = userId.X3_Approver__c;
                if(approverUserMap.get(userId.X3_Approver__c) != null)
                    projEntity.NetworkId = nws.Id;
                projEntitySubList.add(projEntity); 
                contactFollowers.put(userId.X3_Approver__c, userId.CPM__c);
            }
            
            //Fourth Approver            
            if(projectFollowers.get(userId.X4_Approver__c) == null && userId.X4_Approver__c != null){
                EntitySubscription projEntity = new EntitySubscription();
                projEntity.ParentId = userId.Id;
                projEntity.SubscriberId = userId.X4_Approver__c;
                if(approverUserMap.get(userId.X4_Approver__c) != null)
                    projEntity.NetworkId = nws.Id;
                projEntitySubList.add(projEntity); 
                contactFollowers.put(userId.X4_Approver__c, userId.CPM__c);
            }
            
            //Fifth Approver
            if(projectFollowers.get(userId.X5_Approver__c) == null && userId.X5_Approver__c != null){
                EntitySubscription projEntity = new EntitySubscription();
                projEntity.ParentId = userId.Id;
                projEntity.SubscriberId = userId.X5_Approver__c;
                if(approverUserMap.get(userId.X5_Approver__c) != null)
                    projEntity.NetworkId = nws.Id;
                projEntitySubList.add(projEntity);
                contactFollowers.put(userId.X5_Approver__c, userId.CPM__c);
            }
            
            //Sixth Approver
            if(projectFollowers.get(userId.X6_Approver__c) == null && userId.X6_Approver__c != null){
                EntitySubscription projEntity = new EntitySubscription();
                projEntity.ParentId = userId.Id;
                projEntity.SubscriberId = userId.X6_Approver__c;
                if(approverUserMap.get(userId.X6_Approver__c) != null)
                    projEntity.NetworkId = nws.Id;
                projEntitySubList.add(projEntity); 
                contactFollowers.put(userId.X6_Approver__c, userId.CPM__c);
            }
        }
        
        if(!projEntitySubList.isEmpty()){
            try {
                Database.insert(projEntitySubList);
            }
            catch (DMLException dmlEx) {
                //if we get an error because this user is already following this object, it's okay.
                if (dmlEx.getDmlType(0) == statusCode.DUPLICATE_VALUE) {
                    System.Debug('OrgTeamSubscribeOrg: subscription already exists');
                } else {
                    throw dmlEx;
                }
            }
            
            if(!contactFollowers.IsEmpty()){
                ForceFollowCustomer(contactFollowers);
            }             
        }
    }
    
    //Deletes Share Record Which Prevents Customer From Seeing Project In Community
    public static void DeleteShareRecord(Map<Id, MPM4_BASE__Milestone1_Project__c> projMap){
        
        //Deleting new records
        List<MPM4_BASE__Milestone1_Project__Share> pSharesToDelete = new List<MPM4_BASE__Milestone1_Project__Share>();
        for(MPM4_BASE__Milestone1_Project__Share ps : [Select Id from MPM4_BASE__Milestone1_Project__Share where ParentId In: projmap.keyset() and RowCause = 'Project_Customer_Access__c']){
            pSharesToDelete.add(ps);                                                      
        }
        
        List<SBQQ__Quote__Share> qSharesToDelete = new List<SBQQ__Quote__Share>();
        Map<Id, SBQQ__Quote__c>  qteMap = new Map<Id, SBQQ__Quote__c>([Select Id from SBQQ__Quote__c where Project__c In: projMap.keyset()]);
        for(SBQQ__Quote__Share qs : [Select Id from SBQQ__Quote__Share where ParentId In: qteMap.keyset()]){
            qSharesToDelete.add(qs);
        }
        
        if(!pSharesToDelete.isEmpty())
            delete pSharesToDelete;
        
        if(!qSharesToDelete.isEmpty())
            delete qSharesToDelete;  
        
        ForceUnfollowProject(projMap, qteMap);
    }
    
    //Remove Force Following Users For Chatter Communication
    public static void ForceUnfollowProject(Map<Id, MPM4_BASE__Milestone1_Project__c> projMap, Map<Id, SBQQ__Quote__c> qteMap){
        
        List<EntitySubscription> projectFollowers =  new List<EntitySubscription>();
        for(EntitySubscription e : [SELECT Id FROM EntitySubscription where ParentId In: projMap.keyset()]){
            projectFollowers.add(e);
        }
        
        for(EntitySubscription e : [SELECT Id FROM EntitySubscription where ParentId In: qteMap.keyset()]){
            projectFollowers.add(e);
        }
        
        if(!projectFollowers.isEmpty())
            delete projectFollowers;                     
    }
    
    //CPM Force Follow Customer
    public static void ForceFollowCustomer(Map<Id, Id> contactFollowers){
        Set<Id> cId = new Set<Id>();
        
        Map<Id, User> comUsers = new Map<Id, User>([SELECT Id, ContactId FROM User where Profile.UserLicense.Name = 'Customer Community Plus' and Id In: contactFollowers.keyset()]);              
        for(User cu : comUsers.Values()){
            cId.add(cu.ContactId);                       
        }
        
        Set<String> esList = new Set<String>();
        if(!cId.isEmpty()){
            for(EntitySubscription es : [SELECT ParentId, SubscriberId FROM EntitySubscription where ParentId In: cId]){
                system.debug('Entity Subscription: ' + es.ParentId + ' ' + es.SubscriberId);
                esList.add(es.ParentId + ' ' + es.SubscriberId);
            }
        }
        
        List<EntitySubscription> custEntitySubList = new List<EntitySubscription>();        
        for(User cu : comUsers.Values()){
            EntitySubscription custEntity = new EntitySubscription();
            custEntity.ParentId = cu.ContactId;
            custEntity.SubscriberId = contactFollowers.get(cu.Id);
            if(!esList.contains(cu.ContactId + ' ' + contactFollowers.get(cu.Id))){
                custEntitySubList.add(custEntity);
            }
        }
        
        if(custEntitySubList != null || !custEntitySubList.isEmpty()){
            insert custEntitySubList;   
        }  
    }
    
    //Change Quote Records
    public static void CreateQuoteShareRecords(Map<Id, MPM4_BASE__Milestone1_Project__c> projects){
        
        Set<Id> quotes = new Set<Id>();
        
        Map<Id, List<Id>> projectQuotes = new Map<Id, List<Id>>();
        for(SBQQ__Quote__c q : [Select Id, Project__c from SBQQ__Quote__c where Project__c In: projects.KeySet() and SBQQ__Status__c =: 'Presented']){
            if(projectQuotes.containsKey(q.Project__c)){
                List<Id> quoteIds = projectQuotes.get(q.Project__c);
                quoteIds.add(q.Id);
                projectQuotes.put(q.Project__c, quoteIds);              
            }else{
                projectQuotes.put(q.Project__c, new List<Id> {q.Id});               
            }
        }
        
        if(!projectQuotes.IsEmpty()){
            Map<Id, List<Id>> projectUsers = new Map<Id, List<Id>>();
            for(MPM4_BASE__Milestone1_Project__Share p : [Select Id, ParentId, UserOrGroupId from MPM4_BASE__Milestone1_Project__Share where ParentId In: projects.KeySet() and RowCause =: 'Project_Customer_Access__c']){ 
                if(projectUsers.containsKey(p.ParentId)){
                    List<Id> userIds = projectUsers.get(p.ParentId);
                    userIds.add(p.UserOrGroupId);
                    projectUsers.put(p.ParentId, userIds);              
                }else{
                    projectUsers.put(p.ParentId, new List<Id> {p.UserOrGroupId});               
                }
            }
            
            // create the new share for quotes
            List<SBQQ__Quote__Share> sharesToCreate = new List<SBQQ__Quote__Share>();
            for(Id projId : projectQuotes.keyset()){
                for(Id q : projectQuotes.get(projId)){
                    quotes.add(q);
                    for(Id ps : projectUsers.get(projId)){
                        SBQQ__Quote__Share qs = new SBQQ__Quote__Share();                           
                        qs.AccessLevel = 'edit';                            
                        qs.ParentId = q;                            
                        qs.RowCause = 'Quote_Customer_Access__c';                            
                        qs.UserOrGroupId = ps;
                        
                        sharesToCreate.add(qs);
                    }
                }
            }
            
            //Delete Old Share Records
            List<SBQQ__Quote__Share> sharesToDelete = [Select Id from SBQQ__Quote__Share where ParentId In: quotes];
            if(!sharesToDelete.IsEmpty())       
                Delete sharesToDelete;
            
            if(!sharesToCreate.isEmpty())                             
                insert sharesToCreate; 
        }
    }
       
    public static void handleBrokerAccess(List<MPM4_BASE__Milestone1_Project__c> projects){
        Set<Id> brokerAccIds = new Set<Id>();
        List<MPM4_BASE__Milestone1_Project__Share> projectShareList = new List<MPM4_BASE__Milestone1_Project__Share>();
        Set<Id> listofProjects = new Set<Id>();
        Map<Id,Id> roleMapIds = new Map<Id,Id>();
        Set<Id> roleId = new Set<Id>();
        
        List<SBQQ__Quote__Share> shareQts = new List<SBQQ__Quote__Share>();
        
        for(MPM4_BASE__Milestone1_Project__c pr : projects){
            if(pr.Broker__c !=null)
                brokerAccIds.add(pr.broker__c);
        }
        
        if( !brokerAccIds.isEmpty() ){
            
            list<UserRole> roles = [SELECT Name, Id, PortalAccountId FROM UserRole where PortalAccountId IN :brokerAccIds];
            
            for(UserRole r :roles){
                roleId.add(r.Id);
                roleMapIds.put(r.Id,r.PortalAccountId);
            }
            
            System.debug('role ids in trigger'+roleId);
            
            Map<String,List<Id>> groupMaps = new Map<String,List<Id>>();
            for(Group g :[select Id,RelatedId from group where RelatedId = :roleId and type='Role']){
                if(!groupMaps.isEmpty()){
                    List<Id> gIds = new List<Id>();
                    gIds.addAll(groupMaps.get(roleMapIds.get(g.RelatedId)));
                    gIds.add(g.Id);
                    groupMaps.put(roleMapIds.get(g.RelatedId) ,gIds);
                }
                else{
                    List<Id> gIds = new List<Id>();
                    gIds.add(g.Id);
                    groupMaps.put(roleMapIds.get(g.RelatedId) ,gIds);
                }
            }
            
            System.debug('group Maps trigger'+groupMaps);
            
            for(MPM4_BASE__Milestone1_Project__c prj : projects){
                List<Id> groupIdList = groupMaps.get(prj.Broker__c);
                System.debug('broker name' + prj.Broker__c);
                System.debug('group id list' + groupIdList);
                System.debug('broker name' + prj.Broker__r.Name);
                listofProjects.add(prj.id);
                if(groupIdList !=null){
                    for(Id u : groupIdList){
                        MPM4_BASE__Milestone1_Project__Share prjShare = new MPM4_BASE__Milestone1_Project__Share();
                        
                        prjShare.UserOrGroupId = u;
                        prjShare.AccessLevel = 'Read';
                        prjShare.ParentId = prj.Id;
                        projectShareList.add(prjShare);
                                              
                        if(prj.Buyer_Inspection__c != null){
                            MPM4_BASE__Milestone1_Project__Share prjBuyerShare = new MPM4_BASE__Milestone1_Project__Share();
                            prjBuyerShare.UserOrGroupId = u;
                            prjBuyerShare.AccessLevel = 'Read';
                            prjBuyerShare.ParentId = prj.Buyer_Inspection__c;
                            projectShareList.add(prjBuyerShare);
                            listofProjects.add(prj.Buyer_Inspection__c);
                        }
                        
                        if(prj.Seller_Inspection__c != null){
                            MPM4_BASE__Milestone1_Project__Share prjSellerShare = new MPM4_BASE__Milestone1_Project__Share();
                            prjSellerShare.UserOrGroupId = u;
                            prjSellerShare.AccessLevel = 'Read';
                            prjSellerShare.ParentId = prj.Seller_Inspection__c;
                            projectShareList.add(prjSellerShare);
                            listofProjects.add(prj.Seller_Inspection__c);
                        }   
                    }
                }
            }
            
            for(SBQQ__Quote__c qts : [Select id,name,Project__r.Broker__c,Project__r.Buyer_Inspection__r.Broker__c ,Project__r.Seller_Inspection__r.Broker__c from SBQQ__Quote__c where Project__c in :listofProjects]){
                List<Id> userGroupId ;
                if(qts.Project__r.Broker__c != null){
                    userGroupId = groupMaps.get(qts.Project__r.Broker__c);
                }
                else{
                    if(qts.Project__r.Buyer_Inspection__r.Broker__c !=null){
                        userGroupId = groupMaps.get(qts.Project__r.Buyer_Inspection__r.Broker__c );
                    }else if (qts.Project__r.Seller_Inspection__r.Broker__c  !=null){
                        userGroupId = groupMaps.get(qts.Project__r.Seller_Inspection__r.Broker__c );
                    }
                }
                
                if(userGroupId !=null){
                    for(Id uId : userGroupId){
                        SBQQ__Quote__Share qtsh = new SBQQ__Quote__Share();                           
                        qtsh.AccessLevel = 'Read';                            
                        qtsh.ParentId = qts.Id;                            
                        qtsh.RowCause = 'Quote_Customer_Access__c';                            
                        qtsh.UserOrGroupId = uId;
                        shareQts.add(qtsh);                       
                    }
                }               
            }
            
            if(projectShareList.size()>0)
                insert projectShareList;
                       
            if(shareQts.size()>0)
                insert shareQts;
        }       
    }
    
    public static void revokeBrokerAccess(Map<Id, MPM4_BASE__Milestone1_Project__c> projectMap ,List<MPM4_BASE__Milestone1_Project__c> projects){
        
        List<MPM4_BASE__Milestone1_Project__Share> removeshareProjectList = new List<MPM4_BASE__Milestone1_Project__Share>();
        Set<Id> changedBrokerId = new Set<Id>();
        Set<Id> projectIdSet = new Set<Id>();
        List<SBQQ__Quote__Share> removeshareQuotetList = new List<SBQQ__Quote__Share>();
        
        for(MPM4_BASE__Milestone1_Project__c pr : projects){
            if( pr.Broker__c != projectMap.get(pr.Id).Broker__c){
                changedBrokerId.add(projectMap.get(pr.Id).Broker__c);
                projectIdSet.add(pr.Id);
                
                if(pr.Buyer_Inspection__c != null)
                    projectIdSet.add(pr.Buyer_Inspection__c);
                
                if(pr.Seller_Inspection__c !=null)
                    projectIdSet.add(pr.Seller_Inspection__c);                
            }
        }
   
        Set<Id> gIds = new Set<Id>();
        
        if( !changedBrokerId.isEmpty()){
            for(Group g :[select Id,RelatedId from group where RelatedId IN (SELECT Id FROM UserRole where PortalAccountId IN :changedBrokerId) and type='Role']){
                gIds.add(g.Id);
            }
          
            for(MPM4_BASE__Milestone1_Project__Share prShare :[Select ID, ParentId, UserorGroupID from MPM4_BASE__Milestone1_Project__Share where ParentId IN: projectIdSet and UserOrGroupId IN:gIds]){
                if(gIds.contains(prShare.UserorGroupId))
                    removeshareProjectList.add(prShare);
            }
            
            for(SBQQ__Quote__Share sbqShare : [Select ID, ParentId, UserorGroupID from SBQQ__Quote__Share where ParentId IN (Select id from SBQQ__Quote__c where Project__c in :projectIdSet) and UserOrGroupId IN:gIds]){
                if(gIds.contains(sbqShare.UserorGroupId))
                    removeshareQuotetList.add(sbqShare);
            }
            
            if(removeshareProjectList.size() > 0)
                delete removeshareProjectList;
            
            if(removeshareQuotetList.size() > 0)
                delete removeshareQuotetList;            
        }        
    }     
}