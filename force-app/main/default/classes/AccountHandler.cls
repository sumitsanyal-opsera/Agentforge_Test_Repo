/**
 * @description Handles Account insertion with bulk record creation.
 */
public with sharing class AccountHandler {
    /**
     * @description Inserts multiple Account records up to the specified count.
     * @param n The number of accounts to create
     */
    public static void insertAccount(Integer n){
        Integer counter=1;
        List<Account> addAccounts=new List<Account>();
        while(counter<n){
            Account store=new Account();
            store.Name='Acme Inc n'+ counter;
            store.AccountNumber='A000n'+counter;
            addAccounts.add(store);
            counter=counter+1;
        }
        if(Schema.sObjectType.Account.isCreateable()){
            insert addAccounts;
        }
    }
}