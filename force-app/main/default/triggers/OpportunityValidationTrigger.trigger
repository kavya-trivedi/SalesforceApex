// If any of the conditions are violated, the trigger should add the appropriate custom error messages to the Opportunity record.

// Close Date Validation: Opportunities cannot have a Close Date in the past. If an Opportunity’s Close Date is in the past, display an error message stating, “Opportunity cannot have a Close Date in the past.”

// Stage Transition Lock: Opportunities cannot move from “Prospecting” directly to “Closed Won.” If an Opportunity tries to make this transition, show an error message saying, “Opportunity cannot transition directly from Prospecting to Closed Won.”

// Minimum Amount for “Closed Won”: Opportunities in the “Closed Won” stage must have an Amount greater than or equal to $10,000.

// Also, Store the latest error message in the Parent Account Record in the field named "Opportunity Error"

trigger OpportunityValidationTrigger on Opportunity (before update) {
    Map<Id, Opportunity> oldOppMap = Trigger.oldMap;
    List<Account> relatedAcc = [SELECT Id, Opportunity_Error__c FROM Account];
    List<Account> accountsToUpdate = new List<Account>();
    for (Opportunity o : Trigger.new) {
        try {
            if (o.CloseDate < Date.today()) {
                o.addError('Opportunity cannot have a Close Date in the past');
            }
            
            Opportunity oldOpp = oldOppMap.get(o.Id);
            if(oldOpp.StageName == 'Prospecting' && o.StageName == 'Closed Won') {
                o.addError('Opportunity cannot transition directly from Prospecting to Closed Won');
            }
    
            if(o.StageName == 'Closed Won' && o.Amount < 10000) {
                o.addError('Opportunities in the “Closed Won” stage must have an Amount greater than or equal to $10,000');
            }
        } catch (Exception e) {
            System.debug(e);
        }
    }
    if(!accountsToUpdate.isEmpty()) {
        update accountsToUpdate;
    }
}