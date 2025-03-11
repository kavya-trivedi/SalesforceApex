public with sharing class OpportunityUtil {

    // TASK 3: Write a trigger on opportunity that will set the stage name to “prospecting” and the close date to 15 days from today, Whenever the opportunity is modified.
    public static void updateOppStageNameCloseDate(List<Opportunity> listOpps) {
        for(Opportunity o : listOpps) {
            o.StageName = 'Prospecting';
            o.CloseDate = Date.today() - 15;
        }
    }

    // TASK 4: Write a trigger on the opportunity that will set the opportunity type as a new customer.
    public static void updateOppType(List<Opportunity> listOpps) {
        for(Opportunity o : listOpps) {
            o.Type = 'New Customer';
        }
    }

    // TASK 6: Write a trigger so that whenever an opportunity name is modified, create a task for the owner of the record.
    public static void onUpdateOppCreateTask(List<Opportunity> newOpps, Map<Id, Opportunity> oldOppMap) {
        List<Task> taskList = new List<Task>();
        for(Opportunity o : newOpps) {
            Opportunity oldOpp = oldOppMap.get(o.Id);
            if(oldOpp.Name != o.name) {
                taskList.add(new Task(OwnerId = o.OwnerId, Subject = 'Call', WhatId = o.Id));
            }
        }
        if(!taskList.isEmpty()) {
            insert taskList;
        }
    }
}
