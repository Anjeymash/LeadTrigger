/**
 * Created by mashkovskiya on 12/3/2018.
 */

public with sharing class LeadTriggerHandler {

    public static void CampaignMemberAssignment(List<Lead> leads) {
        List <CampaignMember> members = new List <CampaignMember>();
        Set <String> leadSources = new Set<String>();
        for (Lead lead : leads) {
            leadSources.add(lead.LeadSource);
        }
        List<Campaign> compaigns = [
            SELECT id, startDate, endDate, Parent.name
            FROM Campaign
            WHERE Parent.name IN :leadSources
        ];
        for (Lead lead : leads) {
            CampaignMember cm = null;
            for (Campaign cam : compaigns) {

                if ((lead.LeadSource == cam.Parent.name) &&
                    (lead.createdDate >= cam.startDate) &&
                    (lead.createdDate <= cam.endDate)) {
                    cm = new CampaignMember(campaignId = cam.id, leadId = lead.id);
                }
            }
            if (cm != null) {
                members.add(cm);
            } else {
                lead.addError('Parent Campaign for ' + lead.LeadSource + ' does not exist');
            }
        }
        insert members;
    }
}