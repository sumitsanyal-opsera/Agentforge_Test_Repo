@isTest
public class POCControllerTest {
    
    @testSetup
    static void setupTestData() {
        Contact c = new Contact(LastName = 'Test Contact', Email = 'test@example.com');
        insert c;
    }
    
    @isTest
    static void testGetContacts() {
        List<Contact> contacts = POCController.getContacts(10);
        System.assertNotEquals(null, contacts);
    }
    
    @isTest
    static void testUpdateContactEmail() {
        Contact c = [SELECT Id FROM Contact LIMIT 1];
        POCController.updateContactEmail(c.Id, 'newemail@example.com');
        Contact updated = [SELECT Email FROM Contact WHERE Id = :c.Id];
        System.assertEquals('newemail@example.com', updated.Email);
    }
    
    @isTest
    static void testGetContactCount() {
        Integer count = POCController.getContactCount();
        System.assertNotEquals(0, count);
    }
}