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