@IsTest
private class PHPApartmentGalleryControllerTest {

    private static Apt_Location__c createLocation(String neighborhood, String city, String state) {
        Apt_Location__c location = new Apt_Location__c(
            Name = neighborhood,
            City__c = city,
            State__c = state
        );
        insert location;
        return location;
    }

    private static Apartment__c createApartment(Apt_Location__c location, String name, Decimal bedrooms, Decimal monthlyRent, Boolean available, Date availableDate) {
        Apartment__c apartment = new Apartment__c(
            Name = name,
            Apt_Location__c = location.Id,
            Bedrooms__c = bedrooms,
            Monthly_Rent__c = monthlyRent,
            Security_Deposit__c = monthlyRent,
            Square_Footage__c = 750,
            Available__c = available,
            Available_Date__c = availableDate
        );
        insert apartment;
        return apartment;
    }

    @IsTest
    static void testGetAvailableApartments_noFilters() {
        Apt_Location__c location = createLocation('Marina District', 'San Francisco', 'California');
        createApartment(location, 'Unit 1A', 1, 2200, true, Date.today());
        createApartment(location, 'Unit 1B', 2, 3200, true, Date.today());
        createApartment(location, 'Unit 1C', 1, 2400, false, Date.today());

        Test.startTest();
        List<PHPApartmentGalleryController.ApartmentCard> results = PHPApartmentGalleryController.getAvailableApartments(null, null, null, null);
        Test.stopTest();

        System.assertEquals(2, results.size(), 'Only available units should be returned.');
    }

    @IsTest
    static void testGetAvailableApartments_filtersByStateBedroomsAndRent() {
        Apt_Location__c caLocation = createLocation('Marina District', 'San Francisco', 'California');
        Apt_Location__c orLocation = createLocation('Pearl District', 'Portland', 'Oregon');

        createApartment(caLocation, 'CA Studio', 0, 1800, true, Date.today());
        createApartment(caLocation, 'CA 1BR Over Budget', 1, 5000, true, Date.today());
        createApartment(orLocation, 'OR 1BR', 1, 1900, true, Date.today());

        Test.startTest();
        List<PHPApartmentGalleryController.ApartmentCard> results = PHPApartmentGalleryController.getAvailableApartments('California', 'Studio', 2000, 6);
        Test.stopTest();

        System.assertEquals(1, results.size());
        System.assertEquals('CA Studio', results[0].name);
        System.assertEquals('California', results[0].state);
        System.assertEquals('San Francisco', results[0].city);
    }

    @IsTest
    static void testGetAvailableApartments_respectsMaxResults() {
        Apt_Location__c location = createLocation('Marina District', 'San Francisco', 'California');
        for (Integer i = 0; i < 5; i++) {
            createApartment(location, 'Unit ' + i, 1, 2000, true, Date.today().addDays(i));
        }

        Test.startTest();
        List<PHPApartmentGalleryController.ApartmentCard> results = PHPApartmentGalleryController.getAvailableApartments(null, null, null, 2);
        Test.stopTest();

        System.assertEquals(2, results.size());
    }

    @IsTest
    static void testGetAvailableApartments_noMatches() {
        Apt_Location__c location = createLocation('Marina District', 'San Francisco', 'California');
        createApartment(location, 'Unit 1A', 1, 2200, true, Date.today());

        Test.startTest();
        List<PHPApartmentGalleryController.ApartmentCard> results = PHPApartmentGalleryController.getAvailableApartments('Washington', null, null, null);
        Test.stopTest();

        System.assertEquals(0, results.size());
    }
}