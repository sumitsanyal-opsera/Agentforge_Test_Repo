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
public inherited sharing class POCController {

    private static Boolean isContactAccessible;
    private static Boolean isContactUpdateable;

    static {
        isContactAccessible = Contact.sObjectType.getDescribe(SObjectDescribeOptions.DEFERRED).isAccessible();
        isContactUpdateable = Contact.sObjectType.getDescribe(SObjectDescribeOptions.DEFERRED).isUpdateable();
    }

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

        // Check CRUD permission
        if (!isContactAccessible) {
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

        // Check CRUD permission
        if (!isContactAccessible) {
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

        // Check CRUD permission
        if (!isContactUpdateable) {
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
            System.debug(LoggingLevel.ERROR, 'Error updating contact phone: ' + e.getMessage());
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

        // Check CRUD permission
        if (!isContactUpdateable) {
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
            System.debug(LoggingLevel.ERROR, 'Error during bulk update: ' + e.getMessage());
            return 0;
        }
    }

    /**
     * Fetches contacts with a limit on the number of records returned
     *
     * @param limitSize The maximum number of contacts to return
     * @return List of Contact records
     */
    public static List<Contact> getContacts(Integer limitSize) {
        // Check CRUD permission
        if (!isContactAccessible) {
            return new List<Contact>();
        }

        return [SELECT Id, LastName, Email, Phone FROM Contact LIMIT :limitSize];
    }

    /**
     * Updates the email address for a contact
     *
     * @param contactId The Id of the contact to update
     * @param newEmail The new email address to set
     */
    public static void updateContactEmail(Id contactId, String newEmail) {
        // Check CRUD permission
        if (!isContactUpdateable) {
            return;
        }

        Contact c = new Contact(Id = contactId, Email = newEmail);
        update c;
    }

    /**
     * Gets the total count of Contact records in the org
     *
     * @return The number of Contact records
     */
    public static Integer getContactCount() {
        // Check CRUD permission
        if (!isContactAccessible) {
            return 0;
        }

        return [SELECT COUNT() FROM Contact WHERE Id != null];
    }
}