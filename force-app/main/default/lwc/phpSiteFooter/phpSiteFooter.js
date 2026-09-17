import { LightningElement, api } from 'lwc';

export default class PhpSiteFooter extends LightningElement {
    @api tagline = 'Premium Living Across California, Oregon & Washington';
    @api serviceAreaText = 'Serving 50+ communities across the West Coast';
    @api copyrightText = '© 2026 Pacific Haven Properties. All Rights Reserved.';

    quickLinks = [
        { label: 'Home', url: '/' },
        { label: 'Available Apartments', url: '/available-apartments' },
        { label: 'Maintenance Request', url: '/contactsupport' },
        { label: 'Contact Us', url: '/contactsupport' }
    ];
}
