@IsTest
private class AccountServiceTest {

    @TestSetup
    static void createTestData() {

        List<Account> accounts = new List<Account>{
            new Account(
                Name = 'Enterprise Inc',
                AnnualRevenue = 15000000
            ),
            new Account(
                Name = 'Mid Market Ltd',
                AnnualRevenue = 2500000
            ),
            new Account(
                Name = 'Small Business',
                AnnualRevenue = 500000
            ),
            new Account(
                Name = 'No Revenue'
            )
        };

        insert accounts;
    }

    @IsTest
    static void testUpdateAccountRating() {

        User testUser = new User(
            Alias = 'test',
            Email = 'test@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile LIMIT 1].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testuser@accountservicetest.com'
        );
        insert testUser;

        System.runAs(testUser) {
            Set<Id> accountIds = new Set<Id>();

            List<Account> allAccounts = [SELECT Id FROM Account];
            for (Account acc : allAccounts) {
                accountIds.add(acc.Id);
            }

            System.Test.startTest();
            AccountService.updateAccountRating(accountIds);
            System.Test.stopTest();

            Map<String, Account> accountMap = new Map<String, Account>();

            List<Account> updatedAccounts = [
                SELECT Name, Rating
                FROM Account
            ];
            for (Account acc : updatedAccounts) {
                accountMap.put(acc.Name, acc);
            }

            System.assertNotEquals(null, accountMap.get('Enterprise Inc'), 'Enterprise Inc account should exist');
            System.assertEquals('Hot', accountMap.get('Enterprise Inc').Rating, 'Enterprise Inc should have Hot rating');

            System.assertNotEquals(null, accountMap.get('Mid Market Ltd'), 'Mid Market Ltd account should exist');
            System.assertEquals('Warm', accountMap.get('Mid Market Ltd').Rating, 'Mid Market Ltd should have Warm rating');

            System.assertNotEquals(null, accountMap.get('Small Business'), 'Small Business account should exist');
            System.assertEquals('Cold', accountMap.get('Small Business').Rating, 'Small Business should have Cold rating');

            System.assertNotEquals(null, accountMap.get('No Revenue'), 'No Revenue account should exist');
            System.assertEquals('Cold', accountMap.get('No Revenue').Rating, 'No Revenue should have Cold rating');
        }
    }

    @IsTest
    static void testGetTotalRevenue() {

        User testUser = new User(
            Alias = 'test',
            Email = 'test@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile LIMIT 1].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testuser2@accountservicetest.com'
        );
        insert testUser;

        System.runAs(testUser) {
            Set<Id> accountIds = new Set<Id>();

            List<Account> allAccounts = [SELECT Id FROM Account];
            for (Account acc : allAccounts) {
                accountIds.add(acc.Id);
            }

            System.Test.startTest();
            Decimal totalRevenue = AccountService.getTotalRevenue(accountIds);
            System.Test.stopTest();

            System.assertEquals(
                18000000,
                totalRevenue,
                'Total revenue should equal the sum of all AnnualRevenue values.'
            );
        }
    }

    @IsTest
    static void testEmptyInput() {

        User testUser = new User(
            Alias = 'test',
            Email = 'test@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile LIMIT 1].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testuser3@accountservicetest.com'
        );
        insert testUser;

        System.runAs(testUser) {
            System.Test.startTest();

            AccountService.updateAccountRating(new Set<Id>());

            Decimal revenue = AccountService.getTotalRevenue(new Set<Id>());

            System.Test.stopTest();

            System.assertEquals(
                0,
                revenue,
                'Revenue should be zero when no Account Ids are provided.'
            );
        }
    }
}