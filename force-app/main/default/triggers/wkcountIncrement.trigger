public class WkCountIncrementHandler {
    public static void handleWkCountIncrement(List<Account> newAccounts) {
        for (Account acc : newAccounts) {
            if (acc.Name != null && acc.wk_count__c >= 1) {
                acc.wk_count__c = acc.wk_count__c + 1;
            } else {
                acc.wk_count__c = 1;
            }
        }
    }
}