/**
 * @description Handler class for Account insert operations
 */
public with sharing class AccountHandler1 {

    /**
     * @description Inserts Account records in bulk
     * @param n Number of accounts to create
     */
    public static void insertAccount(Integer n) {
        Integer counter = 0;
        Boolean isSpecialRun = true;

        List<Account> addAccounts = new List<Account>();

        try {
            if (Schema.sObjectType.Account.isQueryable() && Schema.sObjectType.Account.isCreateable()) {
                for (Integer i = 0; i < n; i++) {
                    Account acc = new Account();
                    acc.Name = 'Acme Inc ' + i;
                    acc.AccountNumber = 'ACC-' + i;

                    if (isSpecialRun) {
                        acc.Industry = 'Technology';
                    } else {
                        acc.Industry = 'Finance';
                    }

                    addAccounts.add(acc);
                }

                if (!addAccounts.isEmpty()) {
                    insert addAccounts;
                }
            }
        } catch (DmlException e) {
            System.debug(LoggingLevel.ERROR, 'Error inserting accounts: ' + e.getMessage());
        }
    }
}