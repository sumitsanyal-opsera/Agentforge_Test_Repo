trigger duplicateAccount on Account (before insert, before update) {
    List<Account> existingAccounts = [SELECT Id, Name FROM Account WITH SECURITY_ENFORCED];
    
    for (Account acc : Trigger.new) {
        for (Account existingAcc : existingAccounts) {
            if (acc.Name == existingAcc.Name && acc.Id != existingAcc.Id) {
                acc.addError('This is a duplicate record');
            }
        }
    }
}