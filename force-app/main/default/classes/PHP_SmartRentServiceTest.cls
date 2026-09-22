@IsTest
private class PHP_SmartRentServiceTest {

    private static Account createTenantPersonAccount(String lastName) {
        Id personAccountRecordTypeId = [
            SELECT Id
            FROM RecordType
            WHERE SObjectType = 'Account' AND IsPersonType = true
            LIMIT 1
        ].Id;

        Account tenant = new Account(
            RecordTypeId = personAccountRecordTypeId,
            LastName = lastName
        );
        insert tenant;

        tenant = [SELECT Id, PersonContactId FROM Account WHERE Id = :tenant.Id];
        System.assertNotEquals(null, tenant.PersonContactId, 'Expected PersonContactId to be populated for a Person Account.');

        return tenant;
    }

    @IsTest
    static void testUnlockDoor_success() {
        Account tenant = createTenantPersonAccount('SmartRentTenant1');

        PHP_SmartRentService.SmartRentActionRequest request = new PHP_SmartRentService.SmartRentActionRequest();
        request.accountId = new Account(Id = tenant.Id);
        request.actionType = PHP_SmartRentService.ACTION_UNLOCK_DOOR;
        request.unitIdentifier = 'UNIT-101';

        Test.startTest();
        List<PHP_SmartRentService.SmartRentActionResult> results = PHP_SmartRentService.executeSmartRentAction(
            new List<PHP_SmartRentService.SmartRentActionRequest>{ request }
        );
        Test.stopTest();

        System.assertEquals(true, results[0].success);
        System.assertNotEquals(null, results[0].responseMessage);
    }

    @IsTest
    static void testDeactivateKeyfob_success() {
        Account tenant = createTenantPersonAccount('SmartRentTenant2');

        PHP_SmartRentService.SmartRentActionRequest request = new PHP_SmartRentService.SmartRentActionRequest();
        request.accountId = new Account(Id = tenant.Id);
        request.actionType = PHP_SmartRentService.ACTION_DEACTIVATE_KEYFOB;
        request.unitIdentifier = 'UNIT-101';

        Test.startTest();
        List<PHP_SmartRentService.SmartRentActionResult> results = PHP_SmartRentService.executeSmartRentAction(
            new List<PHP_SmartRentService.SmartRentActionRequest>{ request }
        );
        Test.stopTest();

        System.assertEquals(true, results[0].success);
    }

    @IsTest
    static void testUnknownAction_failure() {
        Account tenant = createTenantPersonAccount('SmartRentTenant3');

        PHP_SmartRentService.SmartRentActionRequest request = new PHP_SmartRentService.SmartRentActionRequest();
        request.accountId = new Account(Id = tenant.Id);
        request.actionType = 'SOME_UNSUPPORTED_ACTION';
        request.unitIdentifier = 'UNIT-101';

        Test.startTest();
        List<PHP_SmartRentService.SmartRentActionResult> results = PHP_SmartRentService.executeSmartRentAction(
            new List<PHP_SmartRentService.SmartRentActionRequest>{ request }
        );
        Test.stopTest();

        System.assertEquals(false, results[0].success);
        System.assertNotEquals(null, results[0].responseMessage);
    }
}
