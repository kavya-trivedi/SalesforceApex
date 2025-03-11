trigger AccountEventListener on Account (before insert, after insert, before update, after update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            //DO SOMETHING
        }
    }
    else if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            //DO SOMETHING
        }
    }
}