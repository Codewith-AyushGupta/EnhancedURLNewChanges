public class CreditApplicationUserEmailAlert implements Database.Batchable<sobject>, Schedulable  {
    
    //schedule class
    public void execute(SchedulableContext SC) {
        database.executeBatch(new CreditApplicationUserEmailAlert(), 1); 
    }
    
    
    public Database.QueryLocator start(Database.BatchableContext BC){ 
        Set<String> applicationStatuses = new Set<String>();
        applicationStatuses.add(CreditApplicationContstants.Application_Status_Opened_To_Customer);
        applicationStatuses.add(CreditApplicationContstants.Application_In_Progress);
        
        String query = 'SELECT Id, Email_Notification__c, Contact__c, Contact__r.Email  FROM Credit_Application_Form__c WHERE Email_Notification__c = true AND Application_Status__c IN :applicationStatuses';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Credit_Application_Form__c> lstApplications){
        try{
            List<String> values=new List<String>();
            
            List<OrgWideEmailAddress> owea = new List<OrgWideEmailAddress>();
            
            List<LouisvilleConfiguration__mdt> louisvilleConfigList =new List<LouisvilleConfiguration__mdt>();
            
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            louisvilleConfigList=[SELECT Id,
                              Name__c,
                              Value__c
                              FROM LouisvilleConfiguration__mdt 
                              WHERE DeveloperName='CreditApplicationReminderEmail'];
            
           system.debug('louisvilleConfig ==> '+louisvilleConfigList);
            
            if(!louisvilleConfigList.isEmpty()){
                for(LouisvilleConfiguration__mdt louisConfig: louisvilleConfigList){
                    values.add(louisConfig.Value__c);
                }
                
                owea = [SELECT Id, 
                        Address, 
                        DisplayName 
                        FROM OrgWideEmailAddress
                        WHERE Address=:values];
            }
          
            
            
            //Query email tempalte
            EmailTemplate emailTemplate =[SELECT Id,
                                          Subject,
                                          Description,
                                          HtmlValue,
                                          DeveloperName,
                                          Body 
                                          FROM EmailTemplate
                                          WHERE DeveloperName = :CreditApplicationContstants.EmailTemplate_Credit_Application_Template];
            
            
            
            for(Credit_Application_Form__c creditApplication : lstApplications){
                Messaging.SingleEmailMessage mail =  new  Messaging.SingleEmailMessage();  
                mail.setTargetObjectId(creditApplication.Contact__c);// This is the ID of rel 
                mail.setSaveAsActivity(false);
                mail.setWhatId(creditApplication.Id);// This is the record ID
                //Get templete id for set the templete.                
                mail.setTemplateId(emailTemplate.Id);// This is template ID
               
                if (owea != null) {
				mail.setOrgWideEmailAddressId(owea.get(0).Id);
				}
                
                //add email to list of emails
                mails.add(mail);
            }
            //send emails
            Messaging.sendEmail(mails);
        }catch(Exception ex){
            ExceptionUtils.createExceptionLogV2('CreditApplicationUserEmailAlert - execute',ex.getMessage(),ex.getStackTraceString());
        }
        
        
    }
    
    public void finish(Database.BatchableContext BC){
    }
    
}