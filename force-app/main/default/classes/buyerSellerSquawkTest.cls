@isTest
public class buyerSellerSquawkTest {
@isTest
  public static void createMasterQuoteTest() {
      Product_Line__c pl = TestDataGenerator.createProductLine();      
      Account acc = TestDataGenerator.createAccount();
      Aircraft__c arc = TestDataGenerator.createAircraft(pl.id, acc.id);
      Equipment__c eqp = TestDataGenerator.createEquipment(pl.id, acc.id, arc.id);
      Opportunity opp = TestDataGenerator.instantiateOpportunity();
      product2 prod = TestDataGenerator.createProduct();
      
      string uid = Userinfo.getUserId();
      id ids = Userinfo.getUserId();
      list<id> linkedids = new list<id>();
      linkedids.add(ids);
      
      MPM4_BASE__Milestone1_Project__c proj = TestDataGenerator.instantiateProject(acc.id, opp.Id, arc.Id, eqp.Id, opp.InputDate__c, opp.OutputDate__c,uid , uid, uid, uid, uid, uid, uid, uid);
      
      list<id> projlist = new list<id>();
      projlist.add(proj.id);
      
      BuyerSellerSquawks bss=new BuyerSellerSquawks();
      BuyerSellerSquawks.getBuyerProjectQuoteLines(projlist);
      BuyerSellerSquawks.getSellerProjectQuoteLines(projlist);
  }
    
}