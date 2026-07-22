
/**
 * POCController
 * 
 * Demonstrates basic Contact SOQL operations using standard fields:
 * Id, Email, Phone, AccountId
 * 
 * Includes methods to:
 * - Fetch contacts by email address
 * - Update contact phone numbers
 */
public class POCController {
    
    /**
     * Fetches a contact record by email address
     * 
     * @param email The email address to search for
     * @return Contact record if found, null otherwise
     */
    public static Contact getContactByEmail(String email) {
        // Validate input
        if (email.isBlank()) {
            return null;
        }
        
        // Query contact using email field
        List<Contact> contacts = [
            SELECT Id, Email, Phone, AccountId
            FROM Contact
            WHERE Email = :email
            LIMIT 1
        ];
        
        // Return first match or null if no results
        return contacts.isEmpty() ? null : contacts[0];
    }
    
    /**
     * Fetches all contacts for a specific AccountId
     * 
     * @param accountId The Account Id to filter contacts by
     * @return List of Contact records
     */
    public static List<Contact> getContactsByAccount(Id accountId) {
        // Validate input
        if (accountId == null) {
            return new List<Contact>();
        }
        
        // Query contacts by AccountId
        return [
            SELECT Id, Email, Phone, AccountId
            FROM Contact
            WHERE AccountId = :accountId
        ];
    }
    
    /**
     * Updates the phone number for a contact
     * 
     * @param contactId The Id of the contact to update
     * @param newPhone The new phone number to set
     * @return true if update was successful, false otherwise
     */
    public static Boolean updateContactPhone(Id contactId, String newPhone) {
        // Validate inputs
        if (contactId == null || newPhone.isBlank()) {
            return false;
        }
        
        try {
            // Create contact record with fields to update
            Contact contactToUpdate = new Contact(
                Id = contactId,
                Phone = newPhone
            );
            
            // Perform update
            update contactToUpdate;
            return true;
        } catch (DmlException e) {
            // Log error and return false on failure
            System.debug('Error updating contact phone: ' + e.getMessage());
            return false;
        }
    }
    
    /**
     * Batch updates phone numbers for multiple contacts
     * 
     * @param contactPhoneMap Map of ContactId to new Phone number
     * @return Number of successfully updated contacts
     */
    public static Integer bulkUpdateContactPhones(Map<Id, String> contactPhoneMap) {
        // Validate input
        if (contactPhoneMap == null || contactPhoneMap.isEmpty()) {
            return 0;
        }
        
        List<Contact> contactsToUpdate = new List<Contact>();
        
        // Build list of contacts to update
        for (Id contactId : contactPhoneMap.keySet()) {
            contactsToUpdate.add(new Contact(
                Id = contactId,
                Phone = contactPhoneMap.get(contactId)
            ));
        }
        
        try {
            // Perform bulk update
            update contactsToUpdate;
            return contactsToUpdate.size();
        } catch (DmlException e) {
            // Log error and return 0 on failure
            System.debug('Error during bulk update: ' + e.getMessage());
            return 0;
        }
public class POCController {
    
    public static List<Contact> getContacts(Integer limitSize) {
        return [SELECT Id, LastName, Email, Phone FROM Contact LIMIT :limitSize];
    }
    
    public static void updateContactEmail(Id contactId, String newEmail) {
        Contact c = new Contact(Id = contactId, Email = newEmail);
        update c;
    }
    
    public static Integer getContactCount() {
        return [SELECT COUNT() FROM Contact];
    }
}