// Write a trigger on opportunity that will set the stage name to “prospecting” and the close date to 15 days from today, Whenever the opportunity is modified.

trigger UpdateOppStageNameCloseDate on Opportunity (before update) {
    OpportunityUtil.updateOppStageNameCloseDate(Trigger.new);
}