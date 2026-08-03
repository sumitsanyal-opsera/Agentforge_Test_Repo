/**
 * ContactValidatorTest
 * Test class for ContactValidator
 */
@isTest
public class ContactValidatorTest {
    
    /**
     * Test successful validation with valid Contact
     */
    @isTest
    static void testValidateContactSuccess() {
        Contact validContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@example.com',
            Phone = '555-123-4567',
            MobilePhone = '555-987-6543'
        );
        
        Boolean result = ContactValidator.validateContact(validContact);
        System.assertEquals(true, result, 'Valid contact should pass validation');
    }
    
    /**
     * Test validation fails when LastName is missing
     */
    @isTest
    static void testValidateContactMissingLastName() {
        Contact contact = new Contact(
            FirstName = 'John',
            Email = 'john.doe@example.com'
        );
        
        Boolean result = ContactValidator.validateContact(contact);
        System.assertEquals(false, result, 'Contact without LastName should fail validation');
    }
    
    /**
     * Test validation fails when contact is null
     */
    @isTest
    static void testValidateContactNull() {
        Boolean result = ContactValidator.validateContact(null);
        System.assertEquals(false, result, 'Null contact should fail validation');
    }
    
    /**
     * Test validation with invalid email format
     */
    @isTest
    static void testValidateContactInvalidEmail() {
        Contact contact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'invalid-email-format'
        );
        
        Boolean result = ContactValidator.validateContact(contact);
        System.assertEquals(false, result, 'Contact with invalid email should fail validation');
    }
    
    /**
     * Test validation with valid email format
     */
    @isTest
    static void testValidateContactValidEmail() {
        Contact contact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@example.com'
        );
        
        Boolean result = ContactValidator.validateContact(contact);
        System.assertEquals(true, result, 'Contact with valid email should pass validation');
    }
    
    /**
     * Test validation with invalid phone format
     */
    @isTest
    static void testValidateContactInvalidPhone() {
        Contact contact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Phone = 'abc-def-ghij'
        );
        
        Boolean result = ContactValidator.validateContact(contact);
        System.assertEquals(false, result, 'Contact with invalid phone should fail validation');
    }
    
    /**
     * Test validation with valid phone format (with separators)
     */
    @isTest
    static void testValidateContactValidPhone() {
        Contact contact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Phone = '555-123-4567'
        );
        
        Boolean result = ContactValidator.validateContact(contact);
        System.assertEquals(true, result, 'Contact with valid phone should pass validation');
    }
    
    /**
     * Test validation with valid international phone format
     */
    @isTest
    static void testValidateContactValidInternationalPhone() {
        Contact contact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Phone = '+1-555-123-4567'
        );
        
        Boolean result = ContactValidator.validateContact(contact);
        System.assertEquals(true, result, 'Contact with valid international phone should pass validation');
    }
    
    /**
     * Test validation with invalid MobilePhone
     */
    @isTest
    static void testValidateContactInvalidMobilePhone() {
        Contact contact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            MobilePhone = '12345'
        );
        
        Boolean result = ContactValidator.validateContact(contact);
        System.assertEquals(false, result, 'Contact with invalid mobile phone should fail validation');
    }
    
    /**
     * Test validation of contact list
     */
    @isTest
    static void testValidateContactList() {
        List<Contact> contacts = new List<Contact>();
        
        Contact validContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@example.com'
        );
        
        Contact invalidContact = new Contact(
            FirstName = 'Jane',
            Email = 'jane.doe@example.com'
        );
        
        contacts.add(validContact);
        contacts.add(invalidContact);
        
        Map<Id, Boolean> results = ContactValidator.validateContactList(contacts);
        System.assertEquals(2, results.size(), 'Should return validation results for 2 contacts');
    }
    
    /**
     * Test validation of empty contact list
     */
    @isTest
    static void testValidateEmptyContactList() {
        Map<Id, Boolean> results = ContactValidator.validateContactList(new List<Contact>());
        System.assertEquals(0, results.size(), 'Empty list should return empty results map');
    }
    
    /**
     * Test validation with FirstName too long
     */
    @isTest
    static void testValidateContactFirstNameTooLong() {
        Contact contact = new Contact(
            FirstName = 'A'.repeat(256),
            LastName = 'Doe'
        );
        
        Boolean result = ContactValidator.validateContact(contact);
        System.assertEquals(false, result, 'Contact with FirstName > 255 chars should fail validation');
    }
    
    /**
     * Test validation with minimal required fields
     */
    @isTest
    static void testValidateContactMinimalFields() {
        Contact contact = new Contact(
            LastName = 'Doe'
        );
        
        Boolean result = ContactValidator.validateContact(contact);
        System.assertEquals(true, result, 'Contact with only LastName should pass validation');
    }
}
