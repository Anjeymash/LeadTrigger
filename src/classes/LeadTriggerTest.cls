/**
 * Created by mashkovskiya on 12/3/2018.
 */
@isTest(SeeAllData=false)
public class LeadTriggerTest {

    @testSetup static void setup() {
        Campaign parentCampaign = new Campaign(Name = 'Other',
            startDate = Date.newInstance(2018, 1, 1),
            endDate = Date.newInstance(2018, 12, 31));
        insert parentCampaign;
        Campaign parentCam = [
            SELECT id, name
            FROM Campaign
            WHERE Name = 'Other'
            LIMIT 1
        ];
        Campaign childCampaign1 = new Campaign(Name = 'December', ParentId = parentCam.id,
            startDate = Date.newInstance(2018, 12, 1),
            endDate = Date.newInstance(2018, 12, 31));
        insert childCampaign1;

        Campaign childCampaign2 = new Campaign(Name = 'November', ParentId = parentCam.id,
            startDate = Date.newInstance(2018, 11, 1),
            endDate = Date.newInstance(2018, 11, 30));
        insert childCampaign2;
    }
    @isTest
    public static void campaignMemberAssignmentTest() {
        List<Lead> leadList = new List<Lead>();
        Boolean isSuccess = true;
        leadList.add(new Lead(LastName = 'TestName', LeadSource = 'Other', Company = 'TestCompany'));
        Test.startTest();
        Database.SaveResult[] srList = Database.insert(leadList, false);
        Test.stopTest();
        for (Database.SaveResult sr : srList) {
            if (!sr.isSuccess()) {
                isSuccess = false;
            }
        }
        System.assertEquals(true, isSuccess);
    }
    @isTest
    public static void errorCampaignMemberAssignmentTest() {
        List<Lead> leadList = new List<Lead>();
        Boolean isSuccess = true;
        leadList.add(new Lead(LastName = 'TestName', LeadSource = 'NullValue', Company = 'TestCompany'));
        Test.startTest();
        Database.SaveResult[] srList = Database.insert(leadList, false);
        Test.stopTest();
        for (Database.SaveResult sr : srList) {
            if (!sr.isSuccess()) {
                isSuccess = false;
            }
        }
        System.assertEquals(false, isSuccess);
    }
}