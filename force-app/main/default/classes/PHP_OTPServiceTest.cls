@IsTest
private class PHP_OTPServiceTest {

    private static Account createTenantPersonAccount(String lastName) {
        Id personAccountRecordTypeId = [
            SELECT Id
            FROM RecordType
            WHERE SObjectType = 'Account' AND IsPersonType = true
            LIMIT 1
        ].Id;

        Account tenant = new Account(
            RecordTypeId = personAccountRecordTypeId,
            LastName = lastName,
            PersonMobilePhone = '5551234567'
        );
        insert tenant;

        tenant = [SELECT Id, PersonContactId, PersonMobilePhone FROM Account WHERE Id = :tenant.Id];
        System.assertNotEquals(null, tenant.PersonContactId, 'Expected PersonContactId to be populated for a Person Account.');

        return tenant;
    }

    private static PHP_OTPService.OTPResult generate(Id accountId) {
        PHP_OTPService.OTPRequest request = new PHP_OTPService.OTPRequest();
        request.action = PHP_OTPService.ACTION_GENERATE;
        request.accountId = new Account(Id = accountId);
        return PHP_OTPService.execute(new List<PHP_OTPService.OTPRequest>{ request })[0];
    }

    private static PHP_OTPService.OTPResult validate(Id accountId, String submittedCode) {
        PHP_OTPService.OTPRequest request = new PHP_OTPService.OTPRequest();
        request.action = PHP_OTPService.ACTION_VALIDATE;
        request.accountId = new Account(Id = accountId);
        request.submittedCode = submittedCode;
        return PHP_OTPService.execute(new List<PHP_OTPService.OTPRequest>{ request })[0];
    }

    @IsTest
    static void testGenerateOTP_success() {
        Account tenant = createTenantPersonAccount('Tenant1');

        Test.startTest();
        PHP_OTPService.OTPResult result = generate(tenant.Id);
        Test.stopTest();

        System.assertEquals(true, result.success);
        System.assertNotEquals(null, result.code);
        System.assertEquals(6, result.code.length());
        System.assert(Pattern.compile('^[0-9]{6}$').matcher(result.code).matches(), 'Expected a 6-digit numeric code.');
    }

    @IsTest
    static void testValidateOTP_validCode() {
        Account tenant = createTenantPersonAccount('Tenant2');
        String code = generate(tenant.Id).code;

        Test.startTest();
        PHP_OTPService.OTPResult result = validate(tenant.Id, code);
        Test.stopTest();

        System.assertEquals(true, result.isValid);
    }

    @IsTest
    static void testValidateOTP_invalidCode() {
        Account tenant = createTenantPersonAccount('Tenant3');
        generate(tenant.Id);

        Test.startTest();
        PHP_OTPService.OTPResult result = validate(tenant.Id, '000000');
        Test.stopTest();

        System.assertEquals(false, result.isValid);
    }

    @IsTest
    static void testValidateOTP_expiredCode() {
        Account tenant = createTenantPersonAccount('Tenant4');

        Integer originalTtl = PHP_OTPService.otpTtlMinutes;
        PHP_OTPService.otpTtlMinutes = -1;
        String code = generate(tenant.Id).code;
        PHP_OTPService.otpTtlMinutes = originalTtl;

        Test.startTest();
        PHP_OTPService.OTPResult result = validate(tenant.Id, code);
        Test.stopTest();

        System.assertEquals(false, result.isValid);
        System.assert(result.message.containsIgnoreCase('expired'), 'Expected an expiry message.');
    }

    @IsTest
    static void testValidateOTP_maxAttempts() {
        Account tenant = createTenantPersonAccount('Tenant5');
        String code = generate(tenant.Id).code;

        Test.startTest();

        PHP_OTPService.OTPResult lastResult;
        for (Integer i = 0; i < 3; i++) {
            lastResult = validate(tenant.Id, '000000');
        }

        System.assertEquals(false, lastResult.isValid);
        System.assert(lastResult.message.containsIgnoreCase('Too many failed attempts'), 'Expected a lock message on the 3rd failed attempt.');

        PHP_OTPService.OTPResult fourthResult = validate(tenant.Id, code);

        Test.stopTest();

        System.assertEquals(false, fourthResult.isValid);
        System.assert(fourthResult.message.containsIgnoreCase('Too many failed attempts'), 'Expected the 4th attempt to remain locked even with the correct code.');
    }
}