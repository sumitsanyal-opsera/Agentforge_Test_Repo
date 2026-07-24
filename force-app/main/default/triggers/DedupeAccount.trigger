public class DedupeAccountHandler {
    public static void createDedupeCase(List<Account> accounts) {
        List<Case> casesToInsert = new List<Case>();
        
        for(Account acc : accounts) {
            Case c = new Case();
            c.Subject = 'Dedupe this account';
            c.AccountId = acc.Id;
            casesToInsert.add(c);
        }
        
        if(!casesToInsert.isEmpty() && Schema.sObjectType.Case.isCreateable()) {
            insert casesToInsert;
        }
    }
}