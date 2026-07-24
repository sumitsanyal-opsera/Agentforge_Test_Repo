trigger countContactonAccount on Contact (after insert, after update, after delete) {
    Set<Id> accountIds = new Set<Id>();
    
    if (Trigger.isInsert || Trigger.isUpdate) {
        for (Contact con : Trigger.new) {
            if (con.AccountId != null) {
                accountIds.add(con.AccountId);
            }
        }
    }
    
    if (Trigger.isDelete) {
        for (Contact con : Trigger.old) {
            if (con.AccountId != null) {
                accountIds.add(con.AccountId);
            }
        }
    }
    
    if (!accountIds.isEmpty()) {
        List<Account> accList = [
            SELECT Id, Name, (SELECT Id, Name FROM Contact)
            FROM Account
            WHERE Id IN :accountIds
            WITH SECURITY_ENFORCED
        ];
        
        for (Account acc : accList) {
            acc.Count_Contact__c = acc.Contacts.size();
        }
        
        if (!accList.isEmpty()) {
            Database.update(accList, false, AccessLevel.USER_MODE);
        }
    }
}