public class TestTriggerHandler {
    public static void handleBeforeInsert(List<Contact> contacts) {
        for (Contact con : contacts) {
            if (con.Description == null) {
                con.Description = 'New Contact Created';
            }
        }
    }
}