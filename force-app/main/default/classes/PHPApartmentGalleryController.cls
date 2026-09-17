/**
 * Backs the phpApartmentGallery LWC on the Pacific Haven Properties Experience Cloud site.
 * Exposed to guest users, so every query is read-only and scoped to available units.
 */
public with sharing class PHPApartmentGalleryController {

    public class ApartmentCard {
        @AuraEnabled public String id;
        @AuraEnabled public String name;
        @AuraEnabled public String locationName;
        @AuraEnabled public String city;
        @AuraEnabled public String state;
        @AuraEnabled public Decimal bedrooms;
        @AuraEnabled public Decimal monthlyRent;
        @AuraEnabled public Decimal securityDeposit;
        @AuraEnabled public Decimal squareFootage;
        @AuraEnabled public Date availableDate;
    }

    @AuraEnabled(cacheable=true)
    public static List<ApartmentCard> getAvailableApartments(String state, String bedrooms, Decimal maxRent, Integer maxResults) {
        Integer resultLimit = (maxResults != null && maxResults > 0) ? maxResults : 6;

        List<String> whereClauses = new List<String>{ 'Available__c = true' };
        Map<String, Object> binds = new Map<String, Object>{ 'resultLimit' => resultLimit };

        if (String.isNotBlank(state) && state != 'All') {
            whereClauses.add('Apt_Location__r.State__c = :state');
            binds.put('state', state);
        }

        Integer bedroomCount = parseBedrooms(bedrooms);
        if (bedroomCount != null) {
            whereClauses.add('Bedrooms__c = :bedroomCount');
            binds.put('bedroomCount', bedroomCount);
        }

        if (maxRent != null && maxRent > 0) {
            whereClauses.add('Monthly_Rent__c <= :maxRent');
            binds.put('maxRent', maxRent);
        }

        String query = 'SELECT Id, Name, Apt_Location__r.Name, Apt_Location__r.City__c, Apt_Location__r.State__c, ' +
            'Bedrooms__c, Monthly_Rent__c, Security_Deposit__c, Available_Date__c, Square_Footage__c ' +
            'FROM Apartment__c WHERE ' + String.join(whereClauses, ' AND ') +
            ' ORDER BY Available_Date__c ASC NULLS LAST LIMIT :resultLimit';

        List<Apartment__c> apartments = Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);

        List<ApartmentCard> cards = new List<ApartmentCard>();
        for (Apartment__c apt : apartments) {
            ApartmentCard card = new ApartmentCard();
            card.id = apt.Id;
            card.name = apt.Name;
            card.locationName = apt.Apt_Location__r != null ? apt.Apt_Location__r.Name : null;
            card.city = apt.Apt_Location__r != null ? apt.Apt_Location__r.City__c : null;
            card.state = apt.Apt_Location__r != null ? apt.Apt_Location__r.State__c : null;
            card.bedrooms = apt.Bedrooms__c;
            card.monthlyRent = apt.Monthly_Rent__c;
            card.securityDeposit = apt.Security_Deposit__c;
            card.squareFootage = apt.Square_Footage__c;
            card.availableDate = apt.Available_Date__c;
            cards.add(card);
        }

        return cards;
    }

    private static Integer parseBedrooms(String bedrooms) {
        if (String.isBlank(bedrooms) || bedrooms == 'All') {
            return null;
        }
        if (bedrooms == 'Studio') {
            return 0;
        }
        String digits = bedrooms.replaceAll('[^0-9]', '');
        return String.isNotBlank(digits) ? Integer.valueOf(digits) : null;
    }
}
