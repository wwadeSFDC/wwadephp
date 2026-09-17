/**
 * Ops Copilot / Tenant Concierge door-unlock subagent action. Performs authenticated
 * callouts to the SmartRent (MuleSoft mock) API via the PHP_SmartRent_NC Named Credential.
 */
public with sharing class PHP_SmartRentService {

    public static final String ACTION_UNLOCK_DOOR = 'UNLOCK_DOOR';
    public static final String ACTION_DEACTIVATE_KEYFOB = 'DEACTIVATE_KEYFOB';

    public class SmartRentActionRequest {
        // Agent Builder deprecated the bare 'id' input type ("'id' is deprecated: Use object
        // instead"); an sObject-typed variable maps to a record reference input instead.
        @InvocableVariable(required=true)
        public Account accountId;

        @InvocableVariable(required=true)
        public String actionType;

        @InvocableVariable(required=true)
        public String unitIdentifier;
    }

    public class SmartRentActionResult {
        @InvocableVariable
        public Boolean success;

        @InvocableVariable
        public String responseMessage;
    }

    @InvocableMethod(label='PHP Execute SmartRent Action' description='Performs a door unlock or keyfob deactivation via the SmartRent API.')
    public static List<SmartRentActionResult> executeSmartRentAction(List<SmartRentActionRequest> requests) {
        List<SmartRentActionResult> results = new List<SmartRentActionResult>();

        for (SmartRentActionRequest request : requests) {
            results.add(performAction(request));
        }

        return results;
    }

    private static SmartRentActionResult performAction(SmartRentActionRequest request) {
        SmartRentActionResult result = new SmartRentActionResult();

        try {
            HttpRequest req = new HttpRequest();
            // TODO: confirm endpoint path with MuleSoft team once the mock contract is finalized.
            req.setEndpoint('callout:PHP_SmartRent_NC/api/v1/action');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setBody(JSON.serialize(new Map<String, Object>{
                'accountId' => request.accountId.Id,
                'actionType' => request.actionType,
                'unitIdentifier' => request.unitIdentifier
            }));

            Http http = new Http();
            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200) {
                Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                Boolean actionSucceeded = responseBody.containsKey('success') ? (Boolean) responseBody.get('success') : false;

                result.success = actionSucceeded;
                result.responseMessage = actionSucceeded
                    ? 'The requested action was completed successfully.'
                    : 'The requested action could not be completed at this time.';
            } else {
                result.success = false;
                result.responseMessage = 'The requested action could not be completed at this time.';
            }
        } catch (CalloutException ce) {
            System.debug(LoggingLevel.ERROR, 'PHP_SmartRentService callout error: ' + ce.getMessage());
            result.success = false;
            result.responseMessage = 'We were unable to reach the smart lock system. Please try again shortly.';
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'PHP_SmartRentService error: ' + e.getMessage());
            result.success = false;
            result.responseMessage = 'We were unable to complete the requested action. Please try again shortly.';
        }

        return result;
    }
}