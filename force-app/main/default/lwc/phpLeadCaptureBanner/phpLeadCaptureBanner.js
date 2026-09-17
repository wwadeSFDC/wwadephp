import { LightningElement, api } from 'lwc';

export default class PhpLeadCaptureBanner extends LightningElement {
    @api headingText = 'Ready to find your next home? Our leasing team is here to help.';
    @api buttonLabel = 'Start a Conversation';

    handleClick() {
        // eslint-disable-next-line no-undef
        if (typeof embeddedservice_bootstrap !== 'undefined' && embeddedservice_bootstrap.utilAPI) {
            embeddedservice_bootstrap.utilAPI.launchChat();
        }
    }
}
