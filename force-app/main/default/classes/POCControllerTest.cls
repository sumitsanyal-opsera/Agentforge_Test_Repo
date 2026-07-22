@isTest
public class POCControllerTest {
    
    @isTest
    static void testGetPOCMessage() {
        Test.startTest();
        String message = POCController.getPOCMessage();
        Test.stopTest();
        
        System.assertEquals('POC Controller is working!', message);
    }
    
    @isTest
    static void testGetCurrentTimestamp() {
        Test.startTest();
        DateTime timestamp = POCController.getCurrentTimestamp();
        Test.stopTest();
        
        System.assertNotEquals(null, timestamp);
    }
    
    @isTest
    static void testValidateString() {
        Test.startTest();
        Boolean result1 = POCController.validateString('test');
        Boolean result2 = POCController.validateString('');
        Test.stopTest();
        
        System.assertEquals(true, result1);
        System.assertEquals(false, result2);
    }
}