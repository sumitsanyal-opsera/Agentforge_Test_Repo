/**
 * Service class for Account-related operations.
 * Handles account rating updates based on annual revenue and revenue calculations.
 */
public with sharing class AccountService {

    /**
     * Updates Account Rating based on Annual Revenue
     * >= 10M  -> Hot
     * >= 1M   -> Warm
     * < 1M    -> Cold
     * @param accountIds Set of Account IDs to update
     */
    public static void updateAccountRating(Set<Id> accountIds) {

        if (accountIds == null || accountIds.isEmpty()) {
            return;
        }

        List<Account> accountsToUpdate = [
            SELECT Id, AnnualRevenue, Rating
            FROM Account
            WHERE Id IN :accountIds
            WITH SECURITY_ENFORCED
        ];

        for (Account acc : accountsToUpdate) {

            if (acc.AnnualRevenue == null) {
                acc.Rating = 'Cold';
            }
            else if (acc.AnnualRevenue >= 10000000) {
                acc.Rating = 'Hot';
            }
            else if (acc.AnnualRevenue >= 1000000) {
                acc.Rating = 'Warm';
            }
            else {
                acc.Rating = 'Cold';
            }
        }

        if (!accountsToUpdate.isEmpty()) {
            if (Schema.sObjectType.Account.isUpdateable()) {
                update accountsToUpdate;
            }
        }
    }

    /**
     * Returns the total Annual Revenue for the given Accounts
     * @param accountIds Set of Account IDs to sum revenue for
     * @return Decimal total annual revenue for the accounts
     */
    public static Decimal getTotalRevenue(Set<Id> accountIds) {

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