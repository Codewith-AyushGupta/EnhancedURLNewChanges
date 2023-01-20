@isTest
private class LeadTriggerHelperTest {

    @isTest
    private static void updatePrimaryBranchTest(){
       Branch__c branch = new Branch__c(Name = 'Test Branch');
        insert branch;
        
        Profile pf= [Select Id from profile where Name='System Administrator'];         
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User user=new User(firstname = 'ABC', 
                           lastName = 'XYZ', 
                           email = uniqueName + '@test' + orgId + '.org', 
                           Username = uniqueName + '@test' + orgId + '.org', 
                           EmailEncodingKey = 'ISO-8859-1', 
                           Alias = uniqueName.substring(18, 23), 
                           TimeZoneSidKey = 'America/Los_Angeles', 
                           LocaleSidKey = 'en_US', 
                           LanguageLocaleKey = 'en_US', 
                           ProfileId = pf.Id,
                           Branch_Id__c = branch.Id
                          );        
        
        insert user;
        
        List<RecordType> rtypes = [Select Name, Id From RecordType 
                                   where sObjectType='Lead' and isActive=true and Name='Professional'];        
        Lead lead = new Lead(recordtypeId = rtypes[0].Id,
                                lastName='Test Lead',Title='Title',Company='Company',
                                Contact_Name__c='TestContact',Account_Cat__c='Dealer',Status='Open',
                               Project_Summary__c='Project_Summary__c',Rating='Hot',Preferred_method_of_contact__c='Text');
        System.runAs(user){
            insert lead;
            update lead;
        }  
    }
}