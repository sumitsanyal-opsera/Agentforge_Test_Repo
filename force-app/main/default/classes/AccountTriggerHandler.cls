/**
 * AccountTriggerHandler
 * Bulkified handler class for AccountTrigger.
 * All SOQL and DML operations are performed outside of loops.
 */
public with sharing class AccountTriggerHandler {

    // Custom exception class
    public class AccountTriggerHandlerException extends Exception {}

    /**
     * Handles before insert logic — bulk stamps Description field.
     * No SOQL or DML inside the loop.
     *
     * @param newAccounts List of new Account records from Trigger.new
     */
    public void onBeforeInsert(List<Account> newAccounts) {
        try {
            String today = String.valueOf(Date.today());
            List<Account> accountsToUpdate = new List<Account>();

            for (Account acc : newAccounts) {
                if (String.isBlank(acc.Description)) {
                    acc.Description = 'Account created on: ' + today;
                    accountsToUpdate.add(acc);
                }
            }

            System.debug(LoggingLevel.INFO,
                'AccountTriggerHandler.onBeforeInsert: stamped Description on ' +
                accountsToUpdate.size() + ' record(s)');

        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR,
                'AccountTriggerHandler.onBeforeInsert: ' + e.getMessage());
            throw new AccountTriggerHandlerException(
                'Error during before insert processing: ' + e.getMessage(), e);
        }
    }

    /**
     * Handles after insert logic — bulk fetches related data and processes in Map.
     * Single SOQL query outside loop, single DML operation.
     *
     * @param newAccountMap Map of new Account records from Trigger.newMap
     */
    public void onAfterInsert(Map<Id, Account> newAccountMap) {
        try {
            // Collect all Account IDs in bulk
            Set<Id> accountIds = newAccountMap.keySet();

            // Single SOQL query outside the loop
            List<Account> accounts = [
                SELECT Id, Name, Description, Industry, Type
                FROM Account
                WHERE Id IN :accountIds
            ];

            // Build a map for O(1) lookups
            Map<Id, Account> accountDetailsMap = new Map<Id, Account>(accounts);

            // Process records in bulk — no DML inside loop
            List<Task> tasksToInsert = new List<Task>();
            for (Id accId : accountIds) {
                Account acc = accountDetailsMap.get(accId);
                if (acc != null) {
                    Task followUpTask = new Task(
                        Subject     = 'Follow up with ' + acc.Name,
                        WhatId      = acc.Id,
                        ActivityDate = Date.today().addDays(7),
                        Status      = 'Not Started',
                        Priority    = 'Normal'
                    );
                    tasksToInsert.add(followUpTask);
                }
            }

            // Single DML operation outside the loop
            if (!tasksToInsert.isEmpty()) {
                insert tasksToInsert;
                System.debug(LoggingLevel.INFO,
                    'AccountTriggerHandler.onAfterInsert: created ' +
                    tasksToInsert.size() + ' follow-up task(s)');
            }

        } catch (DmlException e) {
            System.debug(LoggingLevel.ERROR,
                'AccountTriggerHandler.onAfterInsert DML error: ' + e.getMessage());
            throw new AccountTriggerHandlerException(
                'DML error during after insert processing: ' + e.getMessage(), e);
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR,
                'AccountTriggerHandler.onAfterInsert: ' + e.getMessage());
            throw new AccountTriggerHandlerException(
                'Error during after insert processing: ' + e.getMessage(), e);
        }
    }
}
