public class EngineForSaleApex {
    
    public List<Equipment__c> getEngines(){
        return [Select Engine_Manufacture__c, Model__c, Part_No__c, LastHours__c, LastCycles__c, EngineorAPUSN__c, MPI_Remaining__c, CZI_Remaining__c
                FROM Equipment__c 
                Where Make_Available_in_myStandardAero__c = True];
    }
    
    public List<Equipment__c> getHON_Engines(){
        return [Select Engine_Manufacture__c, Model__c, Part_No__c, LastHours__c, LastCycles__c, EngineorAPUSN__c, MPI_Remaining__c, CZI_Remaining__c
                FROM Equipment__c 
                Where Make_Available_in_myStandardAero__c = True and Engine_Manufacture__c = 'Honeywell'];
    }
    
	public List<Equipment__c> getPW_Engines(){
        return [Select Engine_Manufacture__c, Model__c, Part_No__c, LastHours__c, LastCycles__c, EngineorAPUSN__c, MPI_Remaining__c, CZI_Remaining__c
                FROM Equipment__c 
                Where Make_Available_in_myStandardAero__c = True and Engine_Manufacture__c = 'Pratt & Whitney Canada'];
    }
    
	public List<Equipment__c> getAPU_Engines(){
        return [Select Engine_Manufacture__c, Model__c, Part_No__c, LastHours__c, LastCycles__c, EngineorAPUSN__c, MPI_Remaining__c, CZI_Remaining__c
                FROM Equipment__c 
                Where Make_Available_in_myStandardAero__c = True and Name like 'APU%'];
    }
    
	public List<Equipment__c> getBuyEngines(){
        return [Select Engine_Manufacture__c, Model__c, Part_No__c, LastHours__c, LastCycles__c, EngineorAPUSN__c, MPI_Remaining__c, CZI_Remaining__c
                FROM Equipment__c 
                Where Make_Available_in_myStandardAero__c = True and Buy__c = True];
    }
    
	public List<Equipment__c> getExchangeEngines(){
        return [Select Engine_Manufacture__c, Model__c, Part_No__c, LastHours__c, LastCycles__c, EngineorAPUSN__c, MPI_Remaining__c, CZI_Remaining__c
                FROM Equipment__c 
                Where Make_Available_in_myStandardAero__c = True and Exchange__c = True];
    }
    
    public List<Equipment__c> getLeaseEngines(){
        return [Select Engine_Manufacture__c, Model__c, Part_No__c, LastHours__c, LastCycles__c, EngineorAPUSN__c, MPI_Remaining__c, CZI_Remaining__c
                FROM Equipment__c 
                Where Make_Available_in_myStandardAero__c = True and List_Lease__c = True];
    }
    
    public List<Equipment__c> getConsignedEngines(){
        return [Select Engine_Manufacture__c, Model__c, Part_No__c, LastHours__c, LastCycles__c, EngineorAPUSN__c, MPI_Remaining__c, CZI_Remaining__c
                FROM Equipment__c 
                Where Make_Available_in_myStandardAero__c = True and Consigned__c = True];
    }
        
    @AuraEnabled
    Public static List<ListEquipWrap> equipMethod(){
        List<ListEquipWrap> listEquip = new List<ListEquipWrap>();
        Integer j = 1;
        List<Equipment__c> equipList = [Select Engine_Manufacture__c, Model__c, Part_No__c, LastHours__c, LastCycles__c, EngineorAPUSN__c, MPI_Remaining__c, CZI_Remaining__c
                FROM Equipment__c 
                Where Make_Available_in_myStandardAero__c = True and Engine_Manufacture__c = 'Honeywell'];
        for(Equipment__c e: equipList){
            ListEquipWrap eq = new ListEquipWrap();
            eq.equip = e;
            eq.i = j;
            listEquip.add(eq);
            j++;
        }
        
        system.debug('listEquip>>'+listEquip);
        Return listEquip;
    }
     @AuraEnabled
    Public static List<ListEquipWrap> equipMethod1(){
        List<ListEquipWrap> listEquip = new List<ListEquipWrap>();
        Integer j = 1;
        List<Equipment__c> equipList = [Select Engine_Manufacture__c, Model__c, Part_No__c, LastHours__c, LastCycles__c, EngineorAPUSN__c, MPI_Remaining__c, CZI_Remaining__c
                                        From Equipment__c
                                        Where Make_Available_in_myStandardAero__c = True];
        for(Equipment__c e: equipList){
            ListEquipWrap eq = new ListEquipWrap();
            eq.equip = e;
            eq.i = j;
            listEquip.add(eq);
            j++;
        }
        
        system.debug('listEquip>>'+listEquip);
        Return listEquip;
    }

  @AuraEnabled
    Public static List<ListEquipWrap> equipMethod2(){
        List<ListEquipWrap> listEquip = new List<ListEquipWrap>();
        Integer j = 1;
        List<Equipment__c> equipList = [Select Engine_Manufacture__c, Model__c, Part_No__c, LastHours__c, LastCycles__c, EngineorAPUSN__c, MPI_Remaining__c, CZI_Remaining__c
                FROM Equipment__c 
                Where Make_Available_in_myStandardAero__c = True and Name like 'APU%'];
        for(Equipment__c e: equipList){
            ListEquipWrap eq = new ListEquipWrap();
            eq.equip = e;
            eq.i = j;
            listEquip.add(eq);
            j++;
        }
        
        system.debug('listEquip>>'+listEquip);
        Return listEquip;
    }

 @AuraEnabled
    Public static List<ListEquipWrap> equipMethod3(){
        List<ListEquipWrap> listEquip = new List<ListEquipWrap>();
        Integer j = 1;
        List<Equipment__c> equipList = [Select Engine_Manufacture__c, Model__c, Part_No__c, LastHours__c, LastCycles__c, EngineorAPUSN__c, MPI_Remaining__c, CZI_Remaining__c
                FROM Equipment__c 
                Where Make_Available_in_myStandardAero__c = True and Engine_Manufacture__c = 'Pratt & Whitney Canada'];
        for(Equipment__c e: equipList){
            ListEquipWrap eq = new ListEquipWrap();
            eq.equip = e;
            eq.i = j;
            listEquip.add(eq);
            j++;
        }
        
        system.debug('listEquip>>'+listEquip);
        Return listEquip;
    }
    
    public class ListEquipWrap{
        @AuraEnabled public Equipment__c equip ;
        @AuraEnabled public integer i;
        
    }

}