Schema.DescribeFieldResult statusF = Case.Status.getDescribe();
Schema.DescribeFieldResult typeF = Case.Type.getDescribe();
Schema.DescribeFieldResult originF = Case.Origin.getDescribe();
Schema.DescribeFieldResult priorityF = Case.Priority.getDescribe();

for (Schema.PicklistEntry e : statusF.getPicklistValues()) {
    System.debug('STATUS|' + e.getValue() + '|' + e.isActive() + '|' + e.isDefaultValue());
}
for (Schema.PicklistEntry e : typeF.getPicklistValues()) {
    System.debug('TYPE|' + e.getValue() + '|' + e.isActive());
}
for (Schema.PicklistEntry e : originF.getPicklistValues()) {
    System.debug('ORIGIN|' + e.getValue() + '|' + e.isActive());
}
for (Schema.PicklistEntry e : priorityF.getPicklistValues()) {
    System.debug('PRIORITY|' + e.getValue() + '|' + e.isActive());
}
