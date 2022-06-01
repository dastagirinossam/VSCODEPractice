public class exportSquawks {

    public MPM4_BASE__Milestone1_Project__c proj;
    public string header{get;set;}
    public List<wrapper> lstwrapper {get; set;}
    public class wrapper{
        public string squawk{get; set;}
        public string jobcard{get; set;}
        public string status{get; set;}
        public string description{get; set;}
        public string laborAmount{get; set;}
        public string laborType{get; set;}
        public string materialAmount{get; set;}
        public string materialType{get; set;}
        public string isRTS{get; set;}        
    }
   
    public string Filetype{get;set;}
    public boolean isExcel {get;set;}
    public boolean isCsv {get;set;}   
   
    public exportSquawks(ApexPages.StandardController controller){
        this.proj = (MPM4_BASE__Milestone1_Project__c)controller.getRecord();
        Filetype = '';
        lstwrapper = new List<wrapper>();
        header = 'Squawk,Job Card,Status,Description,Labor Amount,Labor Type,Material Amount,Material Type,Is RTS\r\n';                     
    }
      
    public void exportToExcel(){
          string proCode = 'UnscheduledBundle';
          string queryString = 'Select c.Id, c.Name, c.Add_Work_Status__c, c.Designated_Approver__c, c.Job_Card__c, c.Job_Card_Description__c, c.Material_Amount__c, c.Material_Type__c, c.Labor_Amount__c, c.Labor_Type__c, c.IsRTS__c From SBQQ__QuoteLine__c c where SBQQ__ProductCode__c != \'' + String.escapeSingleQuotes(proCode) + '\' And project__c =\'' + proj.Id + '\''; 
          List<SBQQ__QuoteLine__c> lstSquawks = DataBase.Query(queryString);
          system.debug('lstSquawks :'+lstSquawks.size());
          if(lstSquawks.size()>0){
              for(SBQQ__QuoteLine__c sqk :lstSquawks){
                  wrapper w = new wrapper();
                  w.squawk = sqk.Name;
                  w.jobcard = sqk.Job_Card__c;
                  w.status = sqk.Add_Work_Status__c;
                  w.description = sqk.Job_Card_Description__c;
                  w.laborAmount = string.valueof(sqk.Labor_Amount__c);
                  w.laborType = sqk.Labor_Type__c;
                  w.materialAmount = string.valueOf(sqk.Material_Amount__c);
                  w.materialType = sqk.Material_Type__c;
                  w.isRTS = sqk.IsRTS__c;
                  lstwrapper.add(w);               
              }             
          }
          system.debug('lstwrapper :'+lstwrapper.size());
    }
  
}