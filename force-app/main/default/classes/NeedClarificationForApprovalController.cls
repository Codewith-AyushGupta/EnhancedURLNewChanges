public class NeedClarificationForApprovalController {
    
    @AuraEnabled
    public static void upsertNeedClarificationComments(Id creditApplicationID, string ApproverComments){
        try{
            List<Credit_Application_Form__c> listCreditApp = new List<Credit_Application_Form__c>();
            List<Credit_Application_Form__c> creditInstance = CreditApplicationFormSelector.getCreditApplicationsByIds(new Set<Id>{creditApplicationID});
            
            
            for(Credit_Application_Form__c credIns : creditInstance){
                credIns.Application_Status__c = CreditApplicationContstants.Application_In_Progress;
                credIns.Credit_manager_Comments__c = String.isBlank(credIns.Credit_manager_Comments__c) ? ApproverComments : (credIns.Credit_manager_Comments__c +' ' + ApproverComments);
                listCreditApp.add(credIns);
            }
            
            update listCreditApp;
            
            List<Credit_Application_Form__c> listApplications = CreditApplicationFormSelector.getCreditApplicationsByIds(new Set<Id>{creditApplicationID});
            sendEmail(listApplications);
        }catch(Exception ex){
            ExceptionUtils.createExceptionLogV2('needClarificationForApprovalController - upsertNeedClarificationComments',ex.getMessage(),ex.getStackTraceString());
        	throw new AuraHandledException(ex.getMessage());
        }
        
    }
    
    
    
    /***
* This method send the email based on credit application email
*/ 
    public static void sendEmail(List<Credit_Application_Form__c> lstApplications){
        //to add email address
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            for(Credit_Application_Form__c creditApplication : lstApplications){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                //Set list of people who should get the email
                List<String> sendTo = new List<String>();
                
                sendTo.add(creditApplication.Primary_Contact_Email__c);
                mail.setToAddresses(sendTo);
                
                //Set email content
                mail.setSubject('Your credit application '+creditApplication.Name+'' +' Need clarification');
                String body = 'Hello '   + creditApplication.Contact_Name_For_Credit__c + ', ';
                body += '<br/>'; 
                body += '<br/>'; 
                body += 'With reference to your credit applicaiton no '+creditApplication.Name;
                body += '<br/>';
                body += 'Louisville Tile credit department need following clarification. Please provide the same';
                body += '<br/>'; 
                 body += '<br/>'; 
                body += creditApplication.Credit_manager_Comments__c;
                body += '<br/>'; 
                body += '<br/>'; 
                body += '<a href='+''+System.Label.Credit_Application_Form_URL+''+'?contactid='+ creditApplication.Contact__c +'>Click Here</a>'+' to open credit form';
                body += '<br/>'; 
                body += '<br/>'; 
                body += 'Thanks,';  
                body += '<br/>';
                body += 'Credit Department';
                body += '<br/>';
                body += 'Louisville Tile';
                body += '<br/>';
                
                mail.setHtmlBody(body);
                
                //Add your email to the master list
                mails.add(mail);
                
            }
    
            //send emails
            if(!Test.isRunningTest()){
                Messaging.sendEmail(mails);
            }        
    }
    
}