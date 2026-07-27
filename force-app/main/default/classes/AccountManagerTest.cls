@IsTest
private class AccountManagerTest {

    @TestSetup
    // Apex Test Class
    static void createTestData() {

        List<Account> accounts = new List<Account>{
            new Account(
                Name = 'Enterprise Account',
                AnnualRevenue = 15000000
            ),
            new Account(
                Name = 'Channel Account',
                AnnualRevenue = 2500000
            ),
            new Account(
                Name = 'Startup Account',
                AnnualRevenue = 500000
            ),
            new Account(
                Name = 'New Prospect'
            )
        };

        insert accounts;
    }

    @IsTest
    static void testUpdateAccountType() {

        List<Profile> profiles = [SELECT Id FROM Profile LIMIT 1];
        User testUser = new User(
            ProfileId = profiles[0].Id,
            LastName = 'Test',
            Email = 'test@example.com',
            Username = 'testuser' + System.now().getTime() + '@example.com',
            Alias = 'tst',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );

        insert testUser;

        System.runAs(testUser) {
            List<Account> allAccounts = [SELECT Id FROM Account];
            Set<Id> accountIds = new Set<Id>();

            for (Account acc : allAccounts) {
                accountIds.add(acc.Id);
            }

            System.Test.startTest();
            AccountManager.updateAccountType(accountIds);
            System.Test.stopTest();

            Map<String, Account> accountMap = new Map<String, Account>();

            for (Account acc : [
                SELECT Name, Type
                FROM Account
            ]) {
                accountMap.put(acc.Name, acc);
            }

            System.assertNotEquals(
                null,
                accountMap.get('Enterprise Account'),
                'Enterprise Account should exist'
            );
            System.assertEquals(
                'Customer - Direct',
                accountMap.get('Enterprise Account').Type,
                'Enterprise Account Type should be Customer - Direct'
            );

            System.assertNotEquals(
                null,
                accountMap.get('Channel Account'),
                'Channel Account should exist'
            );
            System.assertEquals(
                'Customer - Channel',
                accountMap.get('Channel Account').Type,
                'Channel Account Type should be Customer - Channel'
            );

            System.assertNotEquals(
                null,
                accountMap.get('Startup Account'),
                'Startup Account should exist'
            );
            System.assertEquals(
                'Prospect',
                accountMap.get('Startup Account').Type,
                'Startup Account Type should be Prospect'
            );

            System.assertNotEquals(
                null,
                accountMap.get('New Prospect'),
                'New Prospect should exist'
            );
            System.assertEquals(
                'Prospect',
                accountMap.get('New Prospect').Type,
                'New Prospect Type should be Prospect'
            );
        }
    }

    @IsTest
    static void testGetTotalRevenue() {

        List<Profile> profiles = [SELECT Id FROM Profile LIMIT 1];
        User testUser = new User(
            ProfileId = profiles[0].Id,
            LastName = 'Test',
            Email = 'test2@example.com',
            Username = 'testuser2' + System.now().getTime() + '@example.com',
            Alias = 'tst2',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );

        insert testUser;

        System.runAs(testUser) {
            List<Account> allAccounts = [SELECT Id FROM Account];
            Set<Id> accountIds = new Set<Id>();

            for (Account acc : allAccounts) {
                accountIds.add(acc.Id);
            }

            System.Test.startTest();
            Decimal totalRevenue = AccountManager.getTotalRevenue(accountIds);
            System.Test.stopTest();

            System.assertEquals(
                18000000,
                totalRevenue,
                'Total revenue should equal the sum of all AnnualRevenue values.'
            );
        }
    }

    @IsTest
    // Dummy Comment Addition
    static void testEmptyInput() {

        List<Profile> profiles = [SELECT Id FROM Profile LIMIT 1];
        User testUser = new User(
            ProfileId = profiles[0].Id,
            LastName = 'Test',
            Email = 'test3@example.com',
            Username = 'testuser3' + System.now().getTime() + '@example.com',
            Alias = 'tst3',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );

        insert testUser;

        System.runAs(testUser) {
            System.Test.startTest();

            AccountManager.updateAccountType(new Set<Id>());

            Decimal revenue = AccountManager.getTotalRevenue(new Set<Id>());

            System.Test.stopTest();

            System.assertEquals(
                0,
                revenue,
                'Revenue should be zero when no Account Ids are provided.'
            );
        }
    }
}