@isTest(SeeAllData=True)
public class testPipelineModelController {

	public static testMethod void testPipelineModelController(){
             		
		Test.StartTest(); 
        
        	PageReference pageRef = Page.PipelineModel;
       	 	pageRef.getParameters().put('inputDate', '2018-01-01');
       		pageRef.getParameters().put('outputDate', '2018-12-31');
        	pageRef.getParameters().put('winRate', '50');
        	pageRef.getParameters().put('viabilityRating', '1');
        	pageRef.getParameters().put('confidenceRating', '1');
     	
        	Test.setCurrentPage(pageRef);
		
        	PipelineModelController testPipelineModel = new PipelineModelController();
        
        	//left Selected Values
        	//Test Stage Selection
        	testPipelineModel.leftselected = new List<String>(testPipelineModel.stageValues);        	
			testPipelineModel.selectclick();
        	testPipelineModel.getSelectedValues();
        
            //Test Facility Selection
        	testPipelineModel.leftselected_FAC = new List<String>(testPipelineModel.facilityValues);        	
			testPipelineModel.selectclick_FAC();
        	testPipelineModel.getSelectedValues_FAC();
        
            //Test Model Selection
        	testPipelineModel.leftselected_mod = new List<String>(testPipelineModel.modelValues);        	
			testPipelineModel.selectclick_mod();
        	testPipelineModel.getSelectedValues_mod();
        	
            //Test Mx Program Selection
        	testPipelineModel.leftselected_mx = new List<String>(testPipelineModel.mxPrgmValues);        	
			testPipelineModel.selectclick_mx();
        	testPipelineModel.getSelectedValues_mx();
        
        	testPipelineModel.runSearch();
        	testPipelineModel.exportToExcel();
        
        	//test Export
        	testPipelineModel.csv();
               
        	//Right Selected Values
        	//Test Stage Selection
        	testPipelineModel.rightselected = new List<String>(testPipelineModel.stageValues);
            testPipelineModel.unselectclick();
        	testPipelineModel.getunSelectedValues();        
        
        	//Test Facility Selection
        	testPipelineModel.rightselected_FAC = new List<String>(testPipelineModel.facilityValues); 
            testPipelineModel.unselectclick_FAC();
        	testPipelineModel.getunSelectedValues_FAC();        
              
        	//Test Model Selection
            testPipelineModel.rightselected_mod = new List<String>(testPipelineModel.modelValues);      
            testPipelineModel.unselectclick_mod();
        	testPipelineModel.getunSelectedValues_mod();
        	 
        	//Test Mx Program Selection
        	testPipelineModel.rightselected_mx = new List<String>(testPipelineModel.mxPrgmValues);    
            testPipelineModel.unselectclick_mx();
        	testPipeLineModel.getunSelectedValues_mx();

		Test.StopTest();
	}
}