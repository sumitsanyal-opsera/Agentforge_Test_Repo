trigger AddRelatedRecord on Account(after insert, after update) {
    List<Opportunity> oppList = new List<Opportunity>();

    // Get the related opportunities for the accounts in this trigger
    /*Map<Id,Account> acctsWithOpps = new Map<Id,Account>(
[SELECT Id,(SELECT Id FROM Opportunity) FROM Account WHERE Id IN :Trigger.New WITH USER_MODE]);*/

    // Add an opportunity for each account if it doesn't already have one.
    // Iterate through each account.
    List<Account> accountsWithoutOpps = [Select Id,Name from Account where Id IN:Trigger.new AND ID Not IN(Select AccountId from Opportunity) WITH SECURITY_ENFORCED];
    for(Account a : accountsWithoutOpps) {
        //System.debug('acctsWithOpps.get(a.Id).Opportunities.size()=' + acctsWithOpps.get(a.Id).Opportunities.size());
        // Check if the account already has a related opportunity.
        // if (acctsWithOpps.get(a.Id).Opportunities.size() == 0) {
        // If it doesn't, add a default opportunity
        oppList.add(new Opportunity(Name=a.Name + ' Opportunity',
                                    StageName='Prospecting',
                                    CloseDate=System.today().addMonths(1),
                                    Discount_Percent__c=12,
                                    AccountId=a.Id));
    }
    if (oppList.size() > 0) {
        Database.insert(oppList, false, AccessLevel.USER_MODE);
    }
}