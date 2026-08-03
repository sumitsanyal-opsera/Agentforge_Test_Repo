/**
 * AccountTriggerHandler
 * Handler class for AccountTrigger. Contains all business logic for Account trigger events.
 */
public with sharing class AccountTriggerHandler {

    // Custom exception class
    public class AccountTriggerHandlerException extends Exception {}

    /**
     * Handles before insert logic.
     * Stamps the Description field with the creation date if blank.
     *
     * @param newAccounts List of new Account records from Trigger.new
     */
    public void onBeforeInsert(List<Account> newAccounts) {
        try {
            String today = String.valueOf(Date.today());
            for (Account acc : newAccounts) {
                if (String.isBlank(acc.Description)) {
                    acc.Description = 'Account created on: ' + today;
                }
            }
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR,
                'AccountTriggerHandler.onBeforeInsert: ' + e.getMessage());
            throw new AccountTriggerHandlerException(
                'Error during before insert processing: ' + e.getMessage(), e);
        }
    }

    /**
     * Handles after insert logic.
     * Placeholder for post-insert processing (e.g. related record creation).
     *
     * @param newAccountMap Map of new Account records from Trigger.newMap
     */
    public void onAfterInsert(Map<Id, Account> newAccountMap) {
        try {
            System.debug(LoggingLevel.INFO,
                'AccountTriggerHandler.onAfterInsert: processed ' +
                newAccountMap.size() + ' record(s)');
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR,
                'AccountTriggerHandler.onAfterInsert: ' + e.getMessage());
            throw new AccountTriggerHandlerException(
                'Error during after insert processing: ' + e.getMessage(), e);
        }
    }
}