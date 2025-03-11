// Write a trigger so that whenever an opportunity name is modified, create a task for the owner of the record.
trigger OnUpdateOppCreateTask on Opportunity (after update) {
    OpportunityUtil.onUpdateOppCreateTask(Trigger.new, Trigger.oldMap);
}