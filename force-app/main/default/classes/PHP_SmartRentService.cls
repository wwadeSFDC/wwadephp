/**
 * Ops Copilot / Tenant Concierge door-unlock subagent action. The real SmartRent
 * (MuleSoft) integration was never finalized for this Capstone, so this simulates a
 * successful device response instead of making a callout.
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

        if (!ACTION_UNLOCK_DOOR.equalsIgnoreCase(request.actionType) && !ACTION_DEACTIVATE_KEYFOB.equalsIgnoreCase(request.actionType)) {
            result.success = false;
            result.responseMessage = 'The requested action could not be completed at this time.';
            return result;
        }

        System.debug(LoggingLevel.INFO, 'PHP_SmartRentService mock action ' + request.actionType
            + ' for unit ' + request.unitIdentifier + ' on account ' + request.accountId.Id);

        result.success = true;
        result.responseMessage = 'The requested action was completed successfully.';
        return result;
    }
}