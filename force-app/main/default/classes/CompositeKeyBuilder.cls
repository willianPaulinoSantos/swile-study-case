public with sharing class CompositeKeyBuilder {
     public static String buildKey(Lead lead) {
        return normalize(lead.country_code__c + lead.product_interest__c + lead.employee_range__c);
    }

   /* public static String buildKey(Opportunity opp) {
        return normalize(opp.country_code__c + opp.product_interest__c + opp.employee_range__c);
        TO DO
    }*/

    public static String buildKey(Commercial_Team__c team) {
        return normalize(team.country_code__c + team.product_interest__c + team.Employee_Range__c);
    }

    private static String normalize(String rawKey) {
        if (String.isBlank(rawKey)) {
            return  '';
        }
        
        return rawKey.replaceAll('\\s+', '').toLowerCase();
    }
}