public without sharing class CreditApplicationFormController {
    
    @auraEnabled
    public static String sendVerificationCodeEmail(Id contactID){
        try{
            //List of contacts
            List<Contact> contacts = ContactSelector.getContacts(new Set<Id>{contactID});
            
            if(contacts.isEmpty()){
                throw new AuraHandledException('No Contact Found.');
            }
            
            if(String.isBlank(contacts[0].Email)){
                throw new AuraHandledException('Email Address not found.');
            }
            
            //generate verification code
            String vCode = generateVerificationCode();
            
            //call send email method
            sendEmail(contacts[0], vCode);
            
            return vCode;
        }catch(Exception ex){
            ExceptionUtils.createExceptionLog('CreditApplicationFormController - sendVerificationCodeEmail',ex.getMessage(),ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
        
    }
    
    /**
* This method generates the 6-digit verfication code
*/ 
    public static String generateVerificationCode(){
        Integer len = 6;
        Blob blobKey = crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        String vCode = key.substring(0,len);
        
        return vCode;
    }
    
    /***
* This method send the email based on salesforce contact email with verfication code
* verfication code will use for verfication when user open the Credit Apllication Form.
*/ 
    public static void sendEmail(Contact con, String verificationCode){
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        //Set list of people who should get the email
        List<String> sendTo = new List<String>();
        
        sendTo.add(con.Email);
        mail.setToAddresses(sendTo);
        
        //Set email content
        mail.setSubject('Credit Application Form');
        String body = 'Dear ' + con.FirstName + ' ' + con.LastName + ', ';
        body += '<br/>'; 
        body += '<br/>'; 
        body += 'Verification Code : '+verificationCode;
        body += '<br/>';
        mail.setHtmlBody(body);
        
        
        //Add your email to the master list
        mails.add(mail);
        
        //Send all emails in the master list
        try{
            if(!Test.isRunningTest()){
                Messaging.sendEmail(mails);
            }
            
        }catch(Exception ex){
            ExceptionUtils.createExceptionLog('CreditApplicationFormController - sendEmail',ex.getMessage(),ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
        
    }
    
    //For Getting isSubmitted field value to lock credit Form
    @AuraEnabled
    public static boolean getIsSubmittedValue(Id contactId){
        try{
            boolean bool = false;
            List<Credit_Application_Form__c> creditInstance = CreditApplicationFormSelector.getCreditApplications(new Set<Id>{contactId});
            if(!creditInstance.isEmpty()
               && (creditInstance[0].Application_Status__c == CreditApplicationContstants.Application_Status_Sent_To_Customer)
              ){
                  creditInstance[0].Application_Status__c = CreditApplicationContstants.Application_Status_Opened_To_Customer;
                  update creditInstance[0]; 
              }else if(!creditInstance.isEmpty()
                       && creditInstance[0].Application_Status__c != CreditApplicationContstants.Application_Status_Sent_To_Customer
                       && creditInstance[0].Application_Status__c != CreditApplicationContstants.Application_Status_Opened_To_Customer
                       && creditInstance[0].Application_Status__c != CreditApplicationContstants.Application_In_Progress
                      ){
                          bool = true;
                      }
            
            
            return bool;
        }catch(Exception ex){
            ExceptionUtils.createExceptionLog('CreditApplicationFormController - getIsSubmittedValue',ex.getMessage(),ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
    }
     @AuraEnabled
     public static List<Credit_Application_Form__c> getCreditAppValue(Id contactId){
        try{
           
            List<Credit_Application_Form__c> creditInstance = CreditApplicationFormSelector.getCreditApplicationsData(new Set<Id>{contactId});
            
            
            return creditInstance;
        }catch(Exception ex){
            ExceptionUtils.createExceptionLog('CreditApplicationFormController - getIsSubmittedValue',ex.getMessage(),ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
    }
}