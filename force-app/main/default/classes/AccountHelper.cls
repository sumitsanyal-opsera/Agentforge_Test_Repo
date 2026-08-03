/**
 * Helper for fetching Account records and logging their details.
 */
public with sharing class AccountHelper {

    // Custom exception for AccountHelper errors
    public class AccountHelperException extends Exception {}

    /**
     * Fetches Accounts the running user can read, ordered by Name.
     *
     * @return Sanitised list of Account records
     * @throws AccountHelperException if access check fails or SOQL fails
     */
    public static List<Account> fetchAccounts() {
        try {
            SecurityUtil.checkObjectAccess(Account.SObjectType, System.AccessType.READABLE);

            List<Account> accounts = [
                SELECT Id, Name, Industry, Type, Phone, Website, BillingCity, BillingState
                FROM Account
                ORDER BY Name
                LIMIT 200
            ];

            return (List<Account>) SecurityUtil.stripInaccessible(
                System.AccessType.READABLE, accounts
            );
        } catch (System.NoAccessException e) {
            System.debug(LoggingLevel.ERROR, 'AccountHelper.fetchAccounts: insufficient access — ' + e.getMessage());
            throw new AccountHelperException('Insufficient permissions to read Account records: ' + e.getMessage(), e);
        } catch (System.QueryException e) {
            System.debug(LoggingLevel.ERROR, 'AccountHelper.fetchAccounts: SOQL failed — ' + e.getMessage());
            throw new AccountHelperException('Failed to query Account records: ' + e.getMessage(), e);
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'AccountHelper.fetchAccounts: unexpected error — ' + e.getMessage());
            throw new AccountHelperException('Unexpected error in fetchAccounts: ' + e.getMessage(), e);
        }
    }

    /**
     * Fetches Accounts and prints each record's details to the debug log.
     */
    public static void fetchAndPrintAccountDetails() {
        try {
            List<Account> accounts = fetchAccounts();
            System.debug(LoggingLevel.INFO, 'AccountHelper: fetched ' + accounts.size() + ' account(s)');
            for (Account acc : accounts) {
                printAccountDetails(acc);
            }
        } catch (AccountHelperException e) {
            System.debug(LoggingLevel.ERROR, 'AccountHelper.fetchAndPrintAccountDetails: ' + e.getMessage());
            throw e;
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'AccountHelper.fetchAndPrintAccountDetails: unexpected error — ' + e.getMessage());
            throw new AccountHelperException('Unexpected error in fetchAndPrintAccountDetails: ' + e.getMessage(), e);
        }
    }

    /**
     * Prints a single Account's details to the debug log.
     *
     * @param acc Account record to log
     */
    public static void printAccountDetails(Account acc) {
        if (acc == null) {
            System.debug(LoggingLevel.WARN, 'AccountHelper: cannot print null Account');
            throw new AccountHelperException('Cannot print details for a null Account record.');
        }
        try {
            System.debug(LoggingLevel.INFO, formatAccountDetails(acc));
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'AccountHelper.printAccountDetails: ' + e.getMessage());
            throw new AccountHelperException('Failed to print Account details: ' + e.getMessage(), e);
        }
    }

    private static String formatAccountDetails(Account acc) {
        return 'Account{' +
            'Id=' + acc.Id +
            ', Name=' + acc.Name +
            ', Industry=' + acc.Industry +
            ', Type=' + acc.Type +
            ', Phone=' + acc.Phone +
            ', Website=' + acc.Website +
            ', BillingCity=' + acc.BillingCity +
            ', BillingState=' + acc.BillingState +
            '}';
    }
}