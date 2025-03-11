// Write a trigger on Lead that will update rating as hot, whenever a new Lead record is created.

trigger UpdateLeadRating on Lead (before insert) {
    if(Trigger.isInsert) {
        LeadUtil.updateLeadRating(Trigger.new);
    }
}