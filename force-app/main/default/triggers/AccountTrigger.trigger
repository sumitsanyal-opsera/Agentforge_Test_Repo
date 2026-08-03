/**
 * AccountTrigger
 * Trigger on the Account object — delegates all logic to AccountTriggerHandler.
 * Fires on: before insert, after insert.
 */
trigger AccountTrigger on Account (before insert, after insert) {

    AccountTriggerHandler handler = new AccountTriggerHandler();

    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            handler.onBeforeInsert(Trigger.new);
        }
    }

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            handler.onAfterInsert(Trigger.newMap);
        }
    }
}