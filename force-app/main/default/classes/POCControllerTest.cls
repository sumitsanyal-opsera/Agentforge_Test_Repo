@IsTest
private class POCControllerTest {
    
    @TestSetup
    static void setupTestData() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 5; i++) {
            contacts.add(new Contact(
                FirstName = 'Test',
                LastName = 'Contact' + i,
                Email = 'contact' + i + '@example.com',
                Phone = '555-000' + i,
                AccountId = testAccount.Id
            ));
        }
        insert contacts;
    }
    
    private static User createTestUser() {
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser@example.com.test',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id
        );
        insert testUser;
        return testUser;
    }
    
    @IsTest
    static void testQueryContactsByAccountId() {
        User testUser = createTestUser();
        
        System.runAs(testUser) {
            Account testAccount = [SELECT Id FROM Account LIMIT 1];
            
            Test.startTest();
            List<Contact> contacts = POCController.getContactsByAccountId(testAccount.Id);
            Test.stopTest();
            
            Assert.areEqual(5, contacts.size(), 'Expected 5 contacts for the test account');
            Assert.isNotNull(contacts[0].Id, 'Contact Id should not be null');
        }
    }
    
    @IsTest
    static void testQueryContactsByEmail() {
        User testUser = createTestUser();
        
        System.runAs(testUser) {
            Test.startTest();
            List<Contact> contacts = POCController.getContactsByEmail('contact0@example.com');
            Test.stopTest();
            
            Assert.areEqual(1, contacts.size(), 'Expected 1 contact with email contact0@example.com');
            Assert.areEqual('contact0@example.com', contacts[0].Email, 'Email should match');
        }
    }
    
    @IsTest
    static void testUpdateContactPhone() {
        User testUser = createTestUser();
        
        System.runAs(testUser) {
            Contact testContact = [SELECT Id, Phone FROM Contact WHERE Email = 'contact1@example.com' LIMIT 1];
            String newPhone = '555-9999';
            
            Test.startTest();
            POCController.updateContactPhone(testContact.Id, newPhone);
            Test.stopTest();
            
            Contact updatedContact = [SELECT Phone FROM Contact WHERE Id = :testContact.Id];
            Assert.areEqual(newPhone, updatedContact.Phone, 'Phone should be updated to ' + newPhone);
        }
    }
    
    @IsTest
    static void testUpdateContactEmail() {
        User testUser = createTestUser();
        
        System.runAs(testUser) {
            Contact testContact = [SELECT Id, Email FROM Contact WHERE Email = 'contact2@example.com' LIMIT 1];
            String newEmail = 'newemail@example.com';
            
            Test.startTest();
            POCController.updateContactEmail(testContact.Id, newEmail);
            Test.stopTest();
            
            Contact updatedContact = [SELECT Email FROM Contact WHERE Id = :testContact.Id];
            Assert.areEqual(newEmail, updatedContact.Email, 'Email should be updated to ' + newEmail);
        }
    }
    
    @IsTest
    static void testGetAllContacts() {
        User testUser = createTestUser();
        
        System.runAs(testUser) {
            Test.startTest();
            List<Contact> allContacts = POCController.getAllContacts();
            Test.stopTest();
            
            Assert.areEqual(5, allContacts.size(), 'Expected 5 total contacts');
        }
    }
    
    @IsTest
    static void testQueryContactById() {
        User testUser = createTestUser();
        
        System.runAs(testUser) {
            Contact testContact = [SELECT Id FROM Contact LIMIT 1];
            
            Test.startTest();
            Contact retrievedContact = POCController.getContactById(testContact.Id);
            Test.stopTest();
            
            Assert.isNotNull(retrievedContact, 'Contact should be retrieved by Id');
            Assert.areEqual(testContact.Id, retrievedContact.Id, 'Retrieved contact Id should match');
        }
    }
    
    @IsTest
    static void testUpdateMultipleContacts() {
        User testUser = createTestUser();
        
        System.runAs(testUser) {
            List<Contact> contacts = [SELECT Id FROM Contact LIMIT 3];
            List<Contact> contactsToUpdate = new List<Contact>();
            
            for (Contact c : contacts) {
                c.Phone = '555-8888';
                contactsToUpdate.add(c);
            }
            
            Test.startTest();
            POCController.updateContacts(contactsToUpdate);
            Test.stopTest();
            
            List<Contact> updatedContacts = [SELECT Phone FROM Contact WHERE Id IN :contactsToUpdate];
            Assert.areEqual(3, updatedContacts.size(), 'Expected 3 contacts to be updated');
            for (Contact c : updatedContacts) {
                Assert.areEqual('555-8888', c.Phone, 'All contact phones should be updated');
            }
        }
    }
}