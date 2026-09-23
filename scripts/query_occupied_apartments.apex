List<Apartment__c> apts = [
    SELECT Id, Name, Account__c, Account__r.Name, Account__r.PersonMobilePhone,
           Apt_Location__c, Apt_Location__r.Name
    FROM Apartment__c
    WHERE Occupied__c = true
    ORDER BY Apt_Location__c, Name
];
for (Apartment__c a : apts) {
    String accId = a.Account__c;
    String accName = a.Account__r != null ? a.Account__r.Name : '';
    String propId = a.Apt_Location__c;
    String propName = a.Apt_Location__r != null ? a.Apt_Location__r.Name : '';
    System.debug('ROW|' + a.Id + '|' + a.Name + '|' + accId + '|' + accName + '|' + propId + '|' + propName);
}
System.debug('ROWCOUNT|' + apts.size());
