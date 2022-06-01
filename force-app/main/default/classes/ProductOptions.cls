Public with Sharing class ProductOptions{
    
    private final Product2 currentProduct;
    private final Product2 prodFam;
    private integer counter1=0;  //keeps track of the offset
    private integer list_size=100; //sets the page size or number of row
    public integer lastNumber;
    public integer total_size;
    private final integer  listLimit;
    public String cost {get; set;}    
    public String pricebook {get;set;}
    public Transient Blob resume {get;set;}
    public PageReference ref {get;set;}
    
    public List<SBQQ__ProductOption__c> product = new List<SBQQ__ProductOption__c>();
    public List<PricebookEntry> pbe {get; set;}
    public List<SBQQ__Cost__c> prodCost {get; set;} 
    public List<SBQQ__ProductOption__c> productOptionsList {get; set;}
    public List<ProductOptionsWrapper> listProductOptionsWrapper {get; set;}
    public  List<listProductOptionsWrapper1> listprodWrap {get;set;}
    public List<SBQQ__ProductOption__c> selectedProductOptions{get;set;}
    
    //Blank Constructor    
    public ProductOptions() {
       
    }
    
    //Return To Product
    public PageReference BackToProduct(){
        String theme = UserInfo.getUiThemeDisplayed();
        PageReference pr;

        pr = new PageReference('/' + currentProduct.id);
        pr.setRedirect(true);
        
        return pr;
    } 
    
    //Return To Product After Save    
    public void saveReturnToProduct() {
        
        saveProductOptions();
        
        //PageReference pr = new PageReference('/' + currentProduct.id);
        //pr.setRedirect(true);
        //return pr;
        
    }
    
    //Save
    public void saveProductOptions(){
        system.debug('>>>>>>');
        selectedProductOptions = new List<SBQQ__ProductOption__c>();
        selectedProductOptions.clear();
        for(ProductOptionsWrapper wrapProductOptionObj : listProductOptionsWrapper) {
            selectedProductOptions.add(wrapProductOptionObj.po);
        }
        
        Update selectedProductOptions;  
        CreateCase();
    }
    
    public PageReference CreateCase() {
        searchRecord();
        system.debug('>>>>1');
        
        PageReference tempPage = ApexPages.currentPage();            
        tempPage.setRedirect(true);
        return tempPage;
        
    }
    
    //Initial Loading Constructor    
    public ProductOptions(ApexPages.StandardController controller) {
        this.currentProduct = (Product2)controller.getRecord();               
        listProductOptionsWrapper = new List<ProductOptionsWrapper>();
        listprodWrap = new  List<listProductOptionsWrapper1>();
        listLimit = 900;
        total_size = [SELECT count() FROM SBQQ__ProductOption__c 
                                       where SBQQ__CONFIGUREDSKU__r.Id =:currentProduct.id];
        searchRecord();
    } 
    
    //Adds Wrap to List, Used To Delect Selected Line Items and In Initial Query
    public void searchRecord(){  
            listprodWrap.clear();  
        listProductOptionsWrapper.clear();
        ProductOptionsWrapper[] tmpcase = new ProductOptionsWrapper[]{};
              integer counter = 0;
            integer loopCount = 0;
        for(SBQQ__ProductOption__c p: [SELECT Id, 
                                       SBQQ__ProductName__c,  
                                       SBQQ__Feature__c, 
                                       SBQQ__Feature__r.Name, 
                                       Product_Pricing__c,
                                       SBQQ__Number__c, 
                                       Labor_Code__c, 
                                       Product_Description__c,  
                                       SBQQ__ProductCode__c, 
                                       SBQQ__Quantity__c, 
                                       SBQQ__OptionalSKU__r.QuantityUnitOfMeasure, 
                                       SBQQ__QuantityEditable__c, 
                                       SBQQ__Selected__c, 
                                       SBQQ__OptionalSKU__c, 
                                       SBQQ__OptionalSKU__r.Name, 
                                       SBQQ__CONFIGUREDSKU__r.Name,
                                       Warranty_Program__c,
                                       TSM_Notes__c,
                                       Table_Value__c
                                       FROM SBQQ__ProductOption__c 
                                       where SBQQ__CONFIGUREDSKU__r.Id =:currentProduct.id Order by SBQQ__Number__c  limit :list_size offset :counter1 ]) {
                                           system.debug('listLimit>>>'+listLimit);
                                            if(counter < listLimit)
                                                                {
                                                                    system.debug('tmpcase>>>'+tmpcase.size());
                                                                    tmpcase.add(new ProductOptionsWrapper(p));
                                                                  
                                                                  counter++;
                                                                }else{
                                                                    loopCount++;
                                                                  listprodWrap.add(new listProductOptionsWrapper1(tmpcase,loopCount));  
                                                                 tmpcase = new ProductOptionsWrapper[]{};
                                                                tmpcase.add(new ProductOptionsWrapper(p));
                                                                      counter = 0; 
                                                                    }
                                       }
        if(!tmpcase.isEmpty()){
          
            system.debug(tmpcase);
        listprodWrap.add(new listProductOptionsWrapper1(tmpcase,loopCount));     
        listProductOptionsWrapper.addAll(tmpcase);
           
            }
    }
    
    //Find Selected Boxes To Delete
    public void processSelected(){
        selectedProductOptions = new List<SBQQ__ProductOption__c>();
        selectedProductOptions.clear();
        for(ProductOptionsWrapper wrapProductOptionObj : listProductOptionsWrapper) {
            if(wrapProductOptionObj.selected == true) {
                selectedProductOptions.add(wrapProductOptionObj.po);
            }
        }
        
        Delete selectedProductOptions;
        
        searchRecord();
    }
    
    public void cloneProductOptions(){
        List<SBQQ__ProductOption__c> clonedRecords = new List<SBQQ__ProductOption__c>();
        SBQQ__ProductOption__c newProd;
        
        //get Product Options to Clone
        selectedProductOptions = new List<SBQQ__ProductOption__c>();
        selectedProductOptions.clear();
        for(ProductOptionsWrapper wrapProductOptionObj : listProductOptionsWrapper) {
            if(wrapProductOptionObj.selected == true) {
                selectedProductOptions.add(wrapProductOptionObj.po);
            }
        }
        
        //Clone Selected Product Options
        for(SBQQ__ProductOption__c p : selectedProductOptions){
            newProd = p.clone(false, false, false, false); 
            
            clonedRecords.add(newProd);       
        }
        
        if (clonedRecords.size() > 0){
            insert clonedRecords;
            searchRecord();
        }
    }
    public class listProductOptionsWrapper1{
        public ProductOptionsWrapper[]  lpo {set;get;}  
         public integer blockNumber {get;set;}
        public listProductOptionsWrapper1(ProductOptionsWrapper[] accs, integer i)
        {
            system.debug('accs>>>'+accs);
            system.debug(i);
            lpo = accs;
            blockNumber = i;
        }
    }
    
    // This is our wrapper class used to delete records 
    public class ProductOptionsWrapper{        
        public SBQQ__ProductOption__c po {get; set;}
        public Boolean selected {get; set;}
        public ProductOptionsWrapper(SBQQ__ProductOption__c p) {
            po = p;
            selected = false;
        }
    }
    
    //Navigates To Create New Product OptionPage
    public PageReference AddProductOption(){
        saveProductOptions();
        
        Id productId = currentProduct.id;
        
        Product2 prodFam = [Select Family from Product2 where Id =: productId];
        System.debug('Product Family: ' + prodFam);
        String theme = UserInfo.getUiThemeDisplayed();
        
        if(prodFam.Family != 'Bundle'){
            PageReference ref;
            if(theme == 'Theme3'){
                ref = new Pagereference('/' + productId);
            }else{
                ref = new Pagereference('/apex/ProductVF?c__id=' +productId);
            }
            ref.setRedirect(true);
            return ref;
        }
        
        List<SBQQ__ProductFeature__c> feature = [Select Id From SBQQ__ProductFeature__c where SBQQ__ConfiguredSKU__c =: productId and Name = 'Materials'];
        List<SBQQ__Cost__c> prodCost = [SELECT Id FROM SBQQ__Cost__c WHERE SBQQ__Product__r.Id = : productId];            
        List<AggregateResult> ar = [Select max(SBQQ__Number__c) from SBQQ__ProductOption__c where SBQQ__ConfiguredSKU__c =: productId];
        
        decimal arTemp = ar[0].get('expr0')==null?0:(decimal)ar[0].get('expr0');
        lastNumber = arTemp.intvalue();
        
        Pagereference ref = new Pagereference('/apex/AddMaterials');
        
        String retUrlStr = '/apex/AdjustCPQMaterials?Id=' + productId;
        
        Integer ln = lastNumber + 1;
        
        String ftrId = feature[0].id;
        ref.getParameters().put('feature', ftrId);          
        
        String cost = prodCost[0].id;
        ref.getParameters().put('cost', cost);              
        
        ref.getParameters().put('retURL', returlstr);
        ref.getParameters().put('prodId', productId);
        ref.getParameters().put('number', String.valueOf(ln));
        
        ref.setRedirect(true);
        return ref;
    }
    
    // the product record you are adding values to
    public SBQQ__ProductOption__c prodOpt {
        get {
            if (prodOpt == null)
                prodOpt = new SBQQ__ProductOption__c();
            
            prodOpt.SBQQ__Number__c = Decimal.ValueOf(ApexPages.currentPage().getParameters().get('number'));
            prodOpt.SBQQ__ConfiguredSKU__c = ApexPages.currentPage().getParameters().get('prodId');
            prodOpt.SBQQ__Feature__c = ApexPages.currentPage().getParameters().get('feature');
            prodOpt.SBQQ__Quantity__c = 1;
            prodOpt.SBQQ__Selected__c = True;
            prodOpt.SBQQ__QuantityEditable__c = True;                   
            return prodOpt;
        }
        set;
    }
    
    //Save Product Option Return To Product
    public PageReference saveProductOption(){                                        
        insert prodOpt;
        
        Pagereference ref = new Pagereference(ApexPages.currentPage().getParameters().get('retUrl'));           
        ref.setRedirect(true);
        return ref;     
    }
    
    //cancel button is clicked
    public PageReference cancelProductOption() {
        Pagereference ref = new Pagereference(ApexPages.currentPage().getParameters().get('retUrl')); 
        ref.setRedirect(true);
        return ref;
    }
    
    //Navigates To Create New Product Page If Use Needs To Create One
    public PageReference AddProduct(){                        
        Pagereference ref = new Pagereference('/apex/CreateProductMaterial');
        
        String returlstr= ApexPages.currentPage().getParameters().get('retURL');
        String StrNumber= ApexPages.currentPage().getParameters().get('number');
        String feature= ApexPages.currentPage().getParameters().get('feature');
        String prodId= ApexPages.currentPage().getParameters().get('prodId');       
        String cost= ApexPages.currentPage().getParameters().get('cost');
        
        ref.getParameters().put('retURL', returlstr);
        ref.getParameters().put('prodId', prodId);
        ref.getParameters().put('feature', feature);
        ref.getParameters().put('number', StrNumber);
        ref.getParameters().put('cost', cost);
        
        ref.setRedirect(true);
        return ref;
    }
    
    //Set Default Values
    public Product2 prod {
        get {
            if (prod == null)
                prod = new Product2();
            prod.Family = 'Materials';
            prod.IsActive = True;
            prod.SBQQ__DefaultQuantity__c = 1;
            prod.SBQQ__ConfigurationType__c = 'Disabled';
            prod.SBQQ__OptionLayout__c = 'Sections';
            prod.SBQQ__OptionSelectionMethod__c = 'Add';
            prod.SBQQ__BlockPricingField__c = 'Quantity';
            prod.SBQQ__AssetAmendmentBehavior__c = 'Default';
            prod.SBQQ__AssetConversion__c = 'One per quote line';
            
            return prod;
        }
        set;
    }
    
    // the product option record you are adding values to
    public void productOption(){
        List<SBQQ__ProductOption__c> po = new List<SBQQ__ProductOption__c>();
        SBQQ__ProductOption__c prodOpt;
        prodOpt = new SBQQ__ProductOption__c(
            SBQQ__Number__c = Decimal.ValueOf(ApexPages.currentPage().getParameters().get('number')),
            SBQQ__ConfiguredSKU__c = ApexPages.currentPage().getParameters().get('prodId'),
            SBQQ__Feature__c = ApexPages.currentPage().getParameters().get('feature'),
            SBQQ__Quantity__c = 1,
            SBQQ__Selected__c = True,
            SBQQ__QuantityEditable__c = True,   
            SBQQ__OptionalSKU__c = prod.id);
        po.add(prodOpt);
        
        insert po;
    }
    
    //Get Cost From Visualforce Page
    public Decimal pCost{get;set;}
    
    //Get Sell Price From Visualforce Page
    public Decimal pSellPrice{get;set;}
    
    // save button is clicked
    public PageReference save() {
        
        insert prod; // inserts the new record into the database
        
        //Clone Costs
        List<SBQQ__Cost__c> prodCosts = new List<SBQQ__Cost__c>();
        List<SBQQ__Cost__c> prodCost = [SELECT Id, SBQQ__Active__c, CPQ_Sandbox_ID__c, SBQQ__Product__c, SBQQ__UnitCost__c FROM SBQQ__Cost__c WHERE Id =: ApexPages.currentPage().getParameters().get('cost')];
        for(SBQQ__Cost__c pc : prodCost){
            SBQQ__Cost__c pcCopy = pc.clone(false,true);
            pcCopy.SBQQ__UnitCost__c = pCost;
            pcCopy.SBQQ__Product__c = prod.Id;
            prodCosts.add(pcCopy);
        }
        
        insert prodCosts;
       List<Pricebook2> stdPriceBookRecId = [select id from Pricebook2 where  Name = 'Standard Price Book' AND isStandard=true ];
        //Add Standard Pricebook
        PricebookEntry standardPricebook = new PricebookEntry(
            UnitPrice = pSellPrice, 
            UseStandardPrice = false, 
            product2Id = prod.Id, 
            Pricebook2Id = '01s0000000000m7AAA',
           // Pricebook2Id = [Select Id from Pricebook2 where Name = 'Standard Price Book'].id, 
            isActive = True);
        insert standardPricebook; 
        
        //Add CPQ Pricebook
        PricebookEntry cpqPricebook = new PricebookEntry(
            UnitPrice = pSellPrice, 
            UseStandardPrice = false, 
            product2Id = prod.Id, 
           // Pricebook2Id = [Select Id from Pricebook2 where Name = 'CPQ Price Book'].id,
            Pricebook2Id = '01s39000000eD3iAAE', 
            isActive = True);
        insert cpqPricebook; 
        
        productOption(); //calls productoption class
        
        Pagereference ref = new Pagereference(ApexPages.currentPage().getParameters().get('retUrl'));
        ref.setRedirect(true); 
        return ref;
    }
    
    //cancel button is clicked takes user back to edit options screen
    public PageReference cancel() {
        Pagereference ref = new Pagereference(ApexPages.currentPage().getParameters().get('retUrl'));
        ref.setRedirect(true);
        return ref;
    }  
    public PageReference Beginning() { //user clicked beginning
      counter1 = 0;
        searchRecord();
      return null;
   }

   public PageReference Previous() { //user clicked previous button
      
       counter1 -= list_size;
        searchRecord();
      return null;
   }

   public PageReference Next() { //user clicked next button
          
      counter1 += list_size;
       searchRecord();
      return null;
   }

   public PageReference End() { //user clicked end
      counter1 = total_size - math.mod(total_size, list_size);
       searchRecord();
      return null;
   }

   public Boolean getDisablePrevious() { 
      //this will disable the previous and beginning buttons
      if (counter1>0) return false; else return true;
   }

   public Boolean getDisableNext() { //this will disable the next and end buttons
      if (counter1 + list_size < total_size) return false; else return true;
   }

   public Integer getTotal_size() {
      return total_size;
   }

   public Integer getPageNumber() {
      return counter1/list_size + 1;
   }

   public Integer getTotalPages() {
      if (math.mod(total_size, list_size) > 0) {
         return total_size/list_size + 1;
      } else {
         return (total_size/list_size);
      }
   }

}