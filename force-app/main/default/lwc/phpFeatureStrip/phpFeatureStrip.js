import { LightningElement, api } from 'lwc';

export default class PhpFeatureStrip extends LightningElement {
    @api icon1 = '🏠';
    @api title1 = '50+ Premium Properties';
    @api text1 = 'Locations across CA, OR & WA';
    @api icon2 = '⭐';
    @api title2 = 'Tenant First Philosophy';
    @api text2 = 'We put residents at the center of everything';
    @api icon3 = '🔧';
    @api title3 = '24/7 Maintenance Support';
    @api text3 = 'Fast, reliable response when you need it';
}
