/**
 *
 * @Author - Krunal Pala
 * @ Date - 14/03/2017
 * @Purpose - This class is used for the CPQ Quote templates - rendering Dynamic Sales Rep contact section
 */
public without sharing class SB_QTSalesRepSectionProcessor {
    // quote id from parameter
    public Id quoteId {get; set;}
    //Quote sobj
    public SBQQ__Quote__c quoteSObj {get; set;}

    public Opportunity masterOpp {get;set;}
    // Main array which binds in xsl fo page in Quote Template.
    public List<SalesRepDepWise> salesRepDepWiseToReturnList {get;set;}

    public Set<String> groupingSetForMaterials {get;set;}
    
    // Constructor.
    public SB_QTSalesRepSectionProcessor() {
    
        quoteId = (Id)ApexPages.currentPage().getParameters().get('qid');

        quoteSObj = [Select id, SBQQ__Opportunity2__c,SBQQ__Opportunity2__r.Equipment__r.Model__c,
                            SBQQ__Opportunity2__r.Equipment__r.EngineorAPUSN__c,SBQQ__Opportunity2__r.AFSM__c
                      From SBQQ__Quote__c 
                      where id = :quoteId ];

         masterOpp =   [Select Id,SBQQ__PrimaryQuote__c,AFSM__c, Type, 
                            Equipment__r.Model__c,
                            Equipment__r.EngineorAPUSN__c,
                            AFSM_Lookup__c,AFSM_Lookup__r.Title, AFSM_Lookup__r.Name,
                            AFSM_Lookup__r.MobilePhone
                       From Opportunity
                       where id = :quoteSObj.SBQQ__Opportunity2__c];             
    
        processSalesRepDetail();
    }

    /*=====  Below is the main method which process sales rep - Logic is below
    Step 1- From the Master Quote find the Master opportunity, 
    Step 2 - From Master Opportunity find all child opportunity and their Primary Quote's Sales Rep.
    Step 3 - Group All of them as per Quote Type field on Quote Object (Quote_Type__c)
    Step 4  - Display all group members (Sales Rep Name, Role and Phone number)  group by Labor_Type1__c
     ======*/
    
    private void processSalesRepDetail(){

        // Get List of child opportunities and their primary quotes
          List<Opportunity> childOppList = [Select Id,SBQQ__PrimaryQuote__c,AFSM_Lookup__c, Type, 
                                                 AFSM_Lookup__r.Title, AFSM_Lookup__r.Name,
                                                 AFSM_Lookup__r.MobilePhone,Equipment__r.Model__c,
                                                 Equipment__r.EngineorAPUSN__c
                                             From Opportunity
                                             Where MasterOpportunitylookup__c   = :quoteSObj.SBQQ__Opportunity2__c 
                                                   ];

       if(childOppList == null || childOppList.isEmpty()){
           system.debug('here in empty sales rep');
          childOppList = new List<Opportunity>();
          childOppList.add(masterOpp);
        }                                              
        

        Set<String> userInfoString = new Set<String>();
        Map<String, SalesRepDepWise> depWiseMap = new Map<String,SalesRepDepWise>();
        SalesRepDepWise salesRepDepWise = null;
        SalesRepDetail salesRepDtl = null;
        List<SalesRepDetail> salesRepDetailList  = null;

        groupingSetForMaterials = new Set<String>();
        groupingSetForMaterials.add('Avionics');
        groupingSetForMaterials.add('Paint');
        groupingSetForMaterials.add('Interior');

        

        for(Opportunity opp : childOppList ){
          //userInfoString.add(opp.AFSM__c.split(','));

            String oppType= null;  // to use for group 2nd
            String engineEquipmnt = null; // to use for group 1st
            String key = null;
            String engineSN = null; // for comparison

            oppType= opp.Type;
            engineEquipmnt = opp.Equipment__r.Model__c + ' Serial Number '+opp.Equipment__r.EngineorAPUSN__c;
            engineSN = opp.Equipment__r.EngineorAPUSN__c;

            System.debug(' ---engineSN' +engineSN +'   oppType -- '+oppType + ' --engineEquipmnt --' +engineEquipmnt  );

            if(oppType != null){
                salesRepDepWise = depWiseMap.get(oppType);
               
                key = oppType;
            } else if ((oppType == null || oppType.length() == 0) &&
                 (engineEquipmnt !=null && engineEquipmnt.length() >0 )) {
                salesRepDepWise = depWiseMap.get(engineEquipmnt);
              
                key = engineEquipmnt;
            }else{
                salesRepDepWise =  depWiseMap.get(null);
                
                key = null;
            }

           /*  if(engineSN != null && engineSN != 'NA'){
                salesRepDepWise = depWiseMap.get(engineEquipmnt);
                key = engineEquipmnt;
            } else if ((engineSN == null || engineSN.length() == 0 || engineSN == 'NA') &&
                 (oppType !=null && oppType.length() >0 )) {
                salesRepDepWise = depWiseMap.get(oppType);
                key = oppType;
            }else{
                salesRepDepWise =  depWiseMap.get(null);
                key = null;
            }*/

            system.debug('---Key ---'+ key);

            salesRepDtl = new SalesRepDetail();
            salesRepDtl.salesRepName = opp.AFSM_Lookup__r.Name;
            salesRepDtl.mobileNumber =opp.AFSM_Lookup__r.MobilePhone;
            salesRepDtl.designation = opp.AFSM_Lookup__r.Title;
         

            if(salesRepDepWise == null){

                salesRepDepWise = new SalesRepDepWise();
                salesRepDepWise.derivedOppTypOrEnginEquipmnt = key;
               
                salesRepDetailList = new List<SalesRepDetail>();
                salesRepDetailList.add(salesRepDtl);

                salesRepDepWise.salesRepDetailList = salesRepDetailList;


            }else{
                salesRepDetailList = salesRepDepWise.salesRepDetailList;

                if(salesRepDetailList!=null){
                    salesRepDetailList.add(salesRepDtl);
                    salesRepDepWise.salesRepDetailList = salesRepDetailList;
                    salesRepDepWise.derivedOppTypOrEnginEquipmnt = key;
                }
                else {
                    system.debug('---outerLines --  is null'  );
                }

            }

            depWiseMap.put(key,salesRepDepWise);
            
          
        }


        for(SalesRepDepWise sdw : depWiseMap.values()){
            
            salesRepDetailList = sdw.salesRepDetailList;

            Map<String, SalesRepDetail> uniqueMap = new Map<String,SalesRepDetail>();

            for(SalesRepDetail srd : salesRepDetailList){
              uniqueMap.put(srd.salesRepName, srd);
            }

            sdw.salesRepDetailList = uniqueMap.values();

        }


        List<SalesRepDepWise> salesRepListNoAvPntSet = new List<SalesRepDepWise>();
        List<SalesRepDepWise> salesRepListWithAvPntSet = new List<SalesRepDepWise>();
        
        Integer count = 0;
        for(SalesRepDepWise salesRepDepWs : depWiseMap.values()){

            //salesRepDepWs.outerExGroupNumber = ++count;
            
            if(groupingSetForMaterials.contains(salesRepDepWs.derivedOppTypOrEnginEquipmnt)){
                 salesRepListWithAvPntSet.add(salesRepDepWs); 
            }else{
                salesRepListNoAvPntSet.add(salesRepDepWs);
            }
            
        }

        salesRepListWithAvPntSet.sort();
        salesRepListNoAvPntSet.sort();


        salesRepDepWiseToReturnList = new List<SalesRepDepWise>();
        salesRepDepWiseToReturnList.addAll(salesRepListNoAvPntSet);
        salesRepDepWiseToReturnList.addAll(salesRepListWithAvPntSet);
        
        system.debug('--salesRepDepWiseToReturnList---'+salesRepDepWiseToReturnList);

    }

    
  // Below is the wrapper class for display Sales Rep Department Name 
  public class SalesRepDepWise implements Comparable{

        public String derivedOppTypOrEnginEquipmnt {get; set;}
        public List<SalesRepDetail> salesRepDetailList {get;set;}


       public Integer compareTo(Object compare) {

            
            SalesRepDepWise compareSalesDepWise = (SalesRepDepWise)compare;
    
            if (this.derivedOppTypOrEnginEquipmnt == compareSalesDepWise.derivedOppTypOrEnginEquipmnt) return 0;

            if (this.derivedOppTypOrEnginEquipmnt > compareSalesDepWise.derivedOppTypOrEnginEquipmnt) return 1;

              return -1;       

        }
  }

  // Below is the wrapper class for display of the sales rep details.
  public class SalesRepDetail{

    public String salesRepName {get;set;}
    public String mobileNumber {get;set;}
    public String designation {get;set;}
    
  }

}