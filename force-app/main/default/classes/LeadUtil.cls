public with sharing class LeadUtil {
    public static void updateLeadRating(List<Lead> listLeads) {
        for(Lead l : listLeads) {
            l.rating = 'hot';
        }
    }
}