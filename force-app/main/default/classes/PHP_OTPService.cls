/**
 * Tenant Concierge OTP service. A single invocable action, discriminated by
 * OTPRequest.action, generates and validates one-time-passcodes sent to a tenant
 * Person Account's PersonMobilePhone. The platform allows only one @InvocableMethod
 * per Apex class, so generate/validate are dispatched from one entry point rather than
 * exposed as two separate invocable methods.
 *
 * The OTP code, expiry, and failed-attempt count are persisted on OTP_Session__c
 * (one row per Account) rather than held in memory, since the GENERATE and VALIDATE
 * actions run as separate Apex transactions when invoked from an Agent/Flow — a
 * transaction-scoped static map would never be visible to the later VALIDATE call.
 */
public with sharing class PHP_OTPService {

    public static final String ACTION_GENERATE = 'GENERATE';
    public static final String ACTION_VALIDATE = 'VALIDATE';

    private static final Integer OTP_LENGTH = 6;
    @TestVisible
    private static Integer otpTtlMinutes = 5;
    private static final Integer MAX_ATTEMPTS = 3;

    public class OTPRequest {
        @InvocableVariable(required=true)
        public String action;

        // Agent Builder deprecated the bare 'id' input type ("'id' is deprecated: Use object
        // instead"); an sObject-typed variable maps to a record reference input instead.
        @InvocableVariable(required=true)
        public Account accountId;

        @InvocableVariable
        public String submittedCode;
    }

    public class OTPResult {
        @InvocableVariable
        public Boolean success;

        @InvocableVariable
        public String code;

        @InvocableVariable
        public Boolean isValid;

        @InvocableVariable
        public String message;
    }

    @InvocableMethod(label='PHP OTP Service' description='Generates or validates a one-time passcode for tenant authentication.')
    public static List<OTPResult> execute(List<OTPRequest> requests) {
        List<OTPResult> results = new List<OTPResult>();

        for (OTPRequest request : requests) {
            if (ACTION_GENERATE.equalsIgnoreCase(request.action)) {
                results.add(generateOTP(request));
            } else if (ACTION_VALIDATE.equalsIgnoreCase(request.action)) {
                results.add(validateOTP(request));
            } else {
                OTPResult result = new OTPResult();
                result.success = false;
                result.message = 'Unknown OTP action requested.';
                results.add(result);
            }
        }

        return results;
    }

    private static OTPResult generateOTP(OTPRequest request) {
        OTPResult result = new OTPResult();

        try {
            Account tenant = [
                SELECT Id, PersonMobilePhone
                FROM Account
                WHERE Id = :request.accountId.Id AND IsPersonAccount = true
                WITH SYSTEM_MODE
                LIMIT 1
            ];

            String code = generateSixDigitCode();

            List<OTP_Session__c> existingSessions = [
                SELECT Id
                FROM OTP_Session__c
                WHERE Account__c = :tenant.Id
                WITH SYSTEM_MODE
            ];
            if (!existingSessions.isEmpty()) {
                delete as system existingSessions;
            }

            OTP_Session__c session = new OTP_Session__c(
                Account__c = tenant.Id,
                Code__c = code,
                Expires_At__c = Datetime.now().addMinutes(otpTtlMinutes),
                Failed_Attempts__c = 0,
                Locked__c = false
            );
            insert as system session;

            sendOTP(tenant.PersonMobilePhone, code);

            result.success = true;
            result.code = code;
            result.message = 'A verification code has been sent.';
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'PHP_OTPService.generateOTP error: ' + e.getMessage());
            result.success = false;
            result.code = null;
            result.message = 'We were unable to send a verification code. Please try again.';
        }

        return result;
    }

    private static OTPResult validateOTP(OTPRequest request) {
        OTPResult result = new OTPResult();

        try {
            List<OTP_Session__c> sessions = [
                SELECT Id, Code__c, Expires_At__c, Failed_Attempts__c, Locked__c
                FROM OTP_Session__c
                WHERE Account__c = :request.accountId.Id
                WITH SYSTEM_MODE
                LIMIT 1
            ];

            if (sessions.isEmpty()) {
                result.isValid = false;
                result.message = 'No verification code was found for this session. Please request a new code.';
                return result;
            }

            OTP_Session__c session = sessions[0];

            if (session.Locked__c) {
                result.isValid = false;
                result.message = 'Too many failed attempts. Please request a new code.';
            } else if (Datetime.now() > session.Expires_At__c) {
                result.isValid = false;
                result.message = 'This verification code has expired. Please request a new code.';
            } else if (session.Code__c == request.submittedCode) {
                result.isValid = true;
                result.message = 'Verification successful.';
                session.Failed_Attempts__c = 0;
                update as system session;
            } else {
                session.Failed_Attempts__c = (session.Failed_Attempts__c == null ? 0 : session.Failed_Attempts__c) + 1;

                if (session.Failed_Attempts__c >= MAX_ATTEMPTS) {
                    session.Locked__c = true;
                    result.message = 'Too many failed attempts. Please request a new code.';
                } else {
                    result.message = 'The code entered is incorrect. Please try again.';
                }

                result.isValid = false;
                update as system session;
            }
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'PHP_OTPService.validateOTP error: ' + e.getMessage());
            result.isValid = false;
            result.message = 'We were unable to verify your code. Please try again.';
        }

        return result;
    }

    private static String generateSixDigitCode() {
        Integer randomNumber = Math.mod(Math.abs(Crypto.getRandomInteger()), 1000000);
        return String.valueOf(randomNumber).leftPad(OTP_LENGTH, '0');
    }

    private static void sendOTP(String mobilePhone, String code) {
        // Mock send for Capstone: SMS infrastructure is not wired up yet.
        System.debug(LoggingLevel.INFO, 'Sending OTP ' + code + ' to ' + mobilePhone);
    }
}