trigger contactTrigger on Contact (after insert, after update, after delete) {
    contactTriggerHandler.handleTrigger();
}