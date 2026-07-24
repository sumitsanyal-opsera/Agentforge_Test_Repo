/**
 * @description Updates and manages Account information based on Annual Revenue and other criteria.
 */
public with sharing class AccountManager {

    /**
     * @description Updates the Account Type based on Annual Revenue.
     * @param accountIds Set of Account IDs to update
     */
    public static void updateAccountType(Set<Id> accountIds) {

        if (accountIds == null || accountIds.isEmpty()) {
            return;
        }

        List<Account> accountsToUpdate = [
            SELECT Id, AnnualRevenue, Type
            FROM Account
            WHERE Id IN :accountIds
            WITH SECURITY_ENFORCED
        ];

        for (Account acc : accountsToUpdate) {

            if (acc.AnnualRevenue == null) {
                acc.Type = 'Prospect';
            } else if (acc.AnnualRevenue >= 10000000) {
                acc.Type = 'Customer - Direct';
            } else if (acc.AnnualRevenue >= 1000000) {
                acc.Type = 'Customer - Channel';
            } else {
                acc.Type = 'Prospect';
            }
        }

        if (!accountsToUpdate.isEmpty()) {
            if (Schema.sObjectType.Account.isUpdateable()) {
                update accountsToUpdate;
            }
        }
    }

    /**
     * @description Returns the total Annual Revenue of the given Accounts.
     * @param accountIds Set of Account IDs to calculate revenue for
     * @return Decimal The total Annual Revenue of the provided Accounts
     */
    public static Decimal getTotalRevenue(Set<Id> accountIds) {

        if (accountIds == null || accountIds.isEmpty()) {
            return 0;
        }

        Decimal totalRevenue = 0;

        for (Account acc : [
            SELECT AnnualRevenue
            FROM Account
            WHERE Id IN :accountIds
            WITH SECURITY_ENFORCED
        ]) {
            if (acc.AnnualRevenue != null) {
                totalRevenue += acc.AnnualRevenue;
            }
        }

        return totalRevenue;
    }
}