public class AppleWatchGoldHandler {
    public static void createTaskForHighValueOpportunities(List<Opportunity> opportunities) {
        List<Task> tasksToInsert = new List<Task>();
        
        for(Opportunity opp : opportunities) {
            if(opp.Amount > 50000) {
                Task t = new Task();
                t.Subject = 'Apple Watch Gold';
                t.Description = 'Send one ASAP';
                t.Priority = 'High';
                t.WhatId = opp.Id;
                tasksToInsert.add(t);
            }
        }
        
        if(!tasksToInsert.isEmpty() && Schema.sObjectType.Task.isCreateable()) {
            insert tasksToInsert;
        }
    }
}