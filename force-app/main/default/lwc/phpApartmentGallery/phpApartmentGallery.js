import { LightningElement, api, wire } from 'lwc';
import getAvailableApartments from '@salesforce/apex/PHPApartmentGalleryController.getAvailableApartments';

const BEDROOM_OPTIONS = [
    { label: 'All', value: 'All' },
    { label: 'Studio', value: 'Studio' },
    { label: '1 Bedroom', value: '1BR' },
    { label: '2 Bedroom', value: '2BR' },
    { label: '3 Bedroom', value: '3BR' }
];

const STATE_OPTIONS = [
    { label: 'All', value: 'All' },
    { label: 'California', value: 'California' },
    { label: 'Oregon', value: 'Oregon' },
    { label: 'Washington', value: 'Washington' }
];

const CURRENCY_FORMATTER = new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD', maximumFractionDigits: 0 });
const DATE_FORMATTER = new Intl.DateTimeFormat('en-US', { month: 'short', day: 'numeric', year: 'numeric' });

export default class PhpApartmentGallery extends LightningElement {
    @api heading = 'Featured Apartments';
    @api maxResults = 6;
    @api featuredOnly = false;
    @api showFilters = false;
    @api filterState = 'All';
    @api filterBedrooms = 'All';
    @api filterMaxRent;

    stateOptions = STATE_OPTIONS;
    bedroomOptions = BEDROOM_OPTIONS;

    committedState = this.filterState || 'All';
    committedBedrooms = this.filterBedrooms || 'All';
    committedMaxRent = this.filterMaxRent;

    pendingState = this.committedState;
    pendingBedrooms = this.committedBedrooms;
    pendingMaxRent = this.committedMaxRent;

    apartments = [];
    isLoading = true;
    hasError = false;
    selectedApartment;

    @wire(getAvailableApartments, {
        state: '$committedState',
        bedrooms: '$committedBedrooms',
        maxRent: '$committedMaxRent',
        maxResults: '$maxResults'
    })
    wiredApartments({ data, error }) {
        this.isLoading = false;
        if (data) {
            this.hasError = false;
            this.apartments = data.map((apt) => ({
                ...apt,
                formattedRent: apt.monthlyRent != null ? CURRENCY_FORMATTER.format(apt.monthlyRent) : 'Contact for pricing',
                formattedDeposit: apt.securityDeposit != null ? CURRENCY_FORMATTER.format(apt.securityDeposit) : null,
                formattedDate: apt.availableDate ? DATE_FORMATTER.format(this.parseDate(apt.availableDate)) : 'Now',
                bedroomLabel: this.bedroomLabel(apt.bedrooms),
                locationLabel: [apt.city, apt.state].filter(Boolean).join(', ')
            }));
        } else if (error) {
            this.hasError = true;
            this.apartments = [];
        }
    }

    get effectiveHeading() {
        return this.heading;
    }

    get hasResults() {
        return this.apartments.length > 0;
    }

    get showEmptyState() {
        return !this.isLoading && !this.hasError && !this.hasResults;
    }

    get gridClass() {
        return this.featuredOnly ? 'php-apartment-grid php-apartment-grid_featured' : 'php-apartment-grid';
    }

    handleStateChange(event) {
        this.pendingState = event.detail.value;
    }

    handleBedroomsChange(event) {
        this.pendingBedrooms = event.detail.value;
    }

    handleMaxRentChange(event) {
        const value = event.detail.value;
        this.pendingMaxRent = value ? Number(value) : undefined;
    }

    handleSearch() {
        this.isLoading = true;
        this.committedState = this.pendingState;
        this.committedBedrooms = this.pendingBedrooms;
        this.committedMaxRent = this.pendingMaxRent;
    }

    handleLearnMore(event) {
        const id = event.currentTarget.dataset.id;
        this.selectedApartment = this.apartments.find((apt) => apt.id === id);
    }

    handleCloseModal() {
        this.selectedApartment = undefined;
    }

    handleOpenChat() {
        // eslint-disable-next-line no-undef
        if (typeof embeddedservice_bootstrap !== 'undefined' && embeddedservice_bootstrap.utilAPI) {
            embeddedservice_bootstrap.utilAPI.launchChat();
        }
    }

    bedroomLabel(bedrooms) {
        if (bedrooms == null) {
            return 'Studio';
        }
        return bedrooms === 0 ? 'Studio' : `${bedrooms} BR`;
    }

    parseDate(isoDate) {
        const [year, month, day] = isoDate.split('-').map(Number);
        return new Date(year, month - 1, day);
    }
}
