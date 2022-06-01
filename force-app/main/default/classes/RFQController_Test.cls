@isTest
public class RFQController_Test {

    @isTest
    public static void testMethod1(){
      string  firstName = 'Test';
        string LastName = 't';
        string email = 'xyz@xyz12.com';
        string company= 'Brike';
        string phoneNum = '12345678';
        string city = 'Hyd';
        string state = 'Telangana';
        string country = 'India';
        string Descrip = 'Test class from request for quote';
       
        RFQController.createRFQRecord( firstName,lastName,email,company, phoneNum,city,state,country,Descrip);
    }
    
}