// Write a trigger on the opportunity that will set the opportunity type as a new customer.

trigger UpdateOppType on Opportunity (before insert) {
    OpportunityUtil.updateOppType(Trigger.new);
}