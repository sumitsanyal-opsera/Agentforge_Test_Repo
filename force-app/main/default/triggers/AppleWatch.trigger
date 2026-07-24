trigger AppleWatch on Opportunity (after insert) {
    List<Task> tasksToInsert = new List<Task>();

    for (Opportunity opp : Trigger.new) {
        Task t = new Task();
        t.Subject = 'Apple Watch Promo';
        t.Description = 'Send them one ASAP';
        t.Priority = 'High';
        t.WhatId = opp.Id;
        tasksToInsert.add(t);
    }

    if (!tasksToInsert.isEmpty() && Schema.sObjectType.Task.isCreateable()) {
        insert tasksToInsert;
    }
}