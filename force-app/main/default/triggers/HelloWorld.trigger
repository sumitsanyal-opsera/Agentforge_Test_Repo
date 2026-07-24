public class HelloWorldHandler {
    public static void handleBeforeUpdate(List<Lead> newLeads) {
        for(Lead l : newLeads) {
            l.FirstName = 'Hello';
            l.LastName = 'World';
        }
    }
}