import { LightningElement, api } from 'lwc';

export default class PhpHeroBanner extends LightningElement {
    @api headline = 'Find Your Perfect Home';
    @api subheadline = 'Premium apartments across California, Oregon & Washington';
    @api primaryButtonLabel = 'Browse Apartments';
    @api primaryButtonUrl = '/available-apartments';
    @api secondaryButtonLabel = 'Chat with a Leasing Agent';

    handleSecondaryClick() {
        // eslint-disable-next-line no-undef
        if (typeof embeddedservice_bootstrap !== 'undefined' && embeddedservice_bootstrap.utilAPI) {
            embeddedservice_bootstrap.utilAPI.launchChat();
        }
    }
}
