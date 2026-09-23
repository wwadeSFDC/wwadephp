import { LightningElement, api } from 'lwc';

export default class PhpStatsTiles extends LightningElement {
    @api value1 = '50+';
    @api label1 = 'Communities';
    @api value2 = '3';
    @api label2 = 'States';
    @api value3 = 'Premium';
    @api label3 = 'Amenities';
    @api value4 = '24/7';
    @api label4 = 'Support';
}