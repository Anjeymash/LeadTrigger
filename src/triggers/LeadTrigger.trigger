/**
* Created by mashkovskiya on 11/23/2018.
*/

trigger LeadTrigger on Lead (after insert, after update) {
    if (trigger.isAfter) {
        if (trigger.isInsert || trigger.isUpdate) {
            LeadTriggerHandler.CampaignMemberAssignment(trigger.new);
        }
    }
}