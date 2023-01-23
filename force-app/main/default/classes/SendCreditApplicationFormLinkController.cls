public class SendCreditApplicationFormLinkController {
   
    @auraEnabled
    public static ContactWrapper getContactNameAndEmail(Id contactID){
        List<Contact> contacts = ContactSelector.getContacts(new Set<Id>{contactID});
        if(contacts.isEmpty()){
            throw new AuraHandledException('No Contact Found.');
        }
        
        if(String.isBlank(contacts[0].Email)){
            throw new AuraHandledException('Email Address not found.');
        }
        
        try{
            
            //instance of contact wrapper
            ContactWrapper conWrap = new ContactWrapper();
            conWrap.creditApplication = new ApplicationWrapper();
            
            List<Credit_Application_Form__c> creditApplications = CreditApplicationFormSelector.getCreditApplications(new Set<Id>{contactID});
            // check form already exist or not
            if(!creditApplications.isEmpty()){
                conWrap.formExist = true;
                //get the application detail
                conWrap.creditApplication.creditApplicationId = creditApplications[0].Id;
                conWrap.creditApplication.branch = creditApplications[0].BRANCH__c;
                conWrap.creditApplication.priceCode = creditApplications[0].PRICE_CODE__c;
                conWrap.creditApplication.salesman = creditApplications[0].SALESMAN__c;
                conWrap.creditApplication.customerType = creditApplications[0].CUSTOMER_TYPE__c;
                conWrap.creditApplication.shipVia = creditApplications[0].Ship_VIA__c;
                conWrap.creditApplication.truckRoute = creditApplications[0].Truck_Route__c;
                conWrap.creditApplication.stop = creditApplications[0].Stop__c;
                conWrap.creditApplication.deliveryCharge = creditApplications[0].Delivery_Charge__c;
                conWrap.creditApplication.wareHouse = creditApplications[0].Warehouse__c;
                
            }
            
            for(Contact con: contacts){
                if(String.isBlank(con.FirstName)){
                    conWrap.contactName = con.LastName;
                }
                else{
                    conWrap.contactName = con.FirstName+' '+ con.LastName;
                }
                conWrap.email= con.Email;
                
            }
            return conWrap;
        }catch(Exception ex){
            ExceptionUtils.createExceptionLog('SendCreditApplicationFormLinkController - getContactNameAndEmail',ex.getMessage(),ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
        
    }
    
    
    @AuraEnabled
    public static void upsertCreditApplication(Id contactID, ApplicationWrapper creditAppWrapper){
        try{
            Credit_Application_Form__c creditApplication = new Credit_Application_Form__c();
            if(creditAppWrapper.creditApplicationId != null){
                creditApplication.Id = creditAppWrapper.creditApplicationId;
            }else{
                creditApplication.Contact__c = contactID;
                creditApplication.Application_Status__c = CreditApplicationContstants.Application_Status_Sent_To_Customer;
                creditApplication.Application_Sent_By__c = UserInfo.getUserId();// user which sending the email to customer
            }
            
            creditApplication.BRANCH__c = creditAppWrapper.branch;
            creditApplication.PRICE_CODE__c = creditAppWrapper.priceCode;
            creditApplication.SALESMAN__c = creditAppWrapper.salesman;
            creditApplication.CUSTOMER_TYPE__c = creditAppWrapper.customerType;
            creditApplication.Ship_VIA__c = creditAppWrapper.shipVia;
            creditApplication.Truck_Route__c = creditAppWrapper.truckRoute;
            creditApplication.Stop__c = creditAppWrapper.stop;
            creditApplication.Delivery_Charge__c = creditAppWrapper.deliveryCharge;
            creditApplication.Warehouse__c = creditAppWrapper.wareHouse;
            
            upsert creditApplication;
        }catch(Exception ex){
            ExceptionUtils.createExceptionLog('SendCreditApplicationFormLinkController - upsertCreditApplication',ex.getMessage(),ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
        
        
    }
    
    public class ContactWrapper{
        
        @AuraEnabled public string contactName {get; set;}
        @AuraEnabled public string email {get; set;}
        @AuraEnabled public boolean formExist {get; set;}
        @AuraEnabled public ApplicationWrapper creditApplication {get; set;}
        
        public ContactWrapper(){
            creditApplication = new ApplicationWrapper();
        }
    }
    
    
    public class ApplicationWrapper{
        @AuraEnabled public Id creditApplicationId {get; set;}
        @AuraEnabled public string branch {get; set;}
        @AuraEnabled public string priceCode {get; set;}
        @AuraEnabled public string salesman {get; set;}
        @AuraEnabled public string customerType {get; set;}
        @AuraEnabled public string shipVia {get; set;}
        @AuraEnabled public string truckRoute {get; set;}
        @AuraEnabled public string stop {get; set;}
        @AuraEnabled public string deliveryCharge {get; set;}
        @AuraEnabled public string wareHouse {get; set;}
    }
    
    
    
    @auraEnabled
    public static String sendEmailWithCreditApplicationFormLink(Id contactID){
        
        List<Contact> contacts = ContactSelector.getContacts(new Set<Id>{contactID});
        
        if(contacts.isEmpty()){
            throw new AuraHandledException('No Contact Found.');
        }
        
        if(String.isBlank(contacts[0].Email)){
            throw new AuraHandledException('Email Address not found.');
        }
        try{
            
            /*
            //call send email method
            if(!Test.isRunningTest()){
             Contact con=new Contact();
            con.send_creditApplication__c=true;
            con.Id=contactID;
            update con;   
            }
            */
           if(!Test.isRunningTest()) 
              sendEmail(contacts[0]);
            
            //return the contact Name
            return contacts[0].FirstName + ' ' + contacts[0].LastName;
        }catch(Exception ex){
            ExceptionUtils.createExceptionLog('SendCreditApplicationFormLinkController - sendEmailWithCreditApplicationFormLink',ex.getMessage(),ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }   
        
    }
    
    /***
* This method send the email based on salesforce contact email
*/ 
    public static void sendEmail(Contact con){
        // to get Owner name 
        User user = [SELECT Name, MobilePhone FROM User WHERE Id=:con.OwnerId];
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        //Set list of people who should get the email
        List<String> sendTo = new List<String>();
        
        sendTo.add(con.Email);
        mail.setToAddresses(sendTo);
        
        //Set email content
        mail.setSubject('Credit Application Form');
        String body = 'Hello ' + (String.isBlank( con.FirstName) ? '' :  (con.FirstName + ' ')) + con.LastName + ', ';
        body += '<br/>'; 
        body += 'Thank you for your interest in opening a credit account with Louisville Tile! ';
        body += 'Please follow the link below to complete our application. It is important to complete all sections of the application so that your information can be reviewed and processed in a timely manner.';
        body += ' Please also make sure to read all terms and conditions of the account and sign where indicated by an officer of the company.';
        body += '<br/>';
        body += '<br/>'; 
        body += 'If you are exempt from sales tax, please provide a copy of your certificate(s) with application.'; 
        body += '<br/>';
        body += '<br/>'; 
        body += 'We look forward to doing business with you, and should you have any questions regarding the status of your application, please contact' +' '+ user.MobilePhone + '';
        body += '<br/>'; 
        body += '<br/>';
        body += '<a href='+''+System.Label.Credit_Application_Form_URL+''+'?contactid='+ con.Id +'>Click Here</a>'+' '+' to open the credit application form';
        body += '<br/>'; 
        body += '<br/>'; 
        body += 'Sincerely,';
        
        
        mail.setHtmlBody(body);
        
        //Add your email to the master list
        mails.add(mail);
       
        
        //Send all emails in the master list
        try{
            if(!Test.isRunningTest())
                Messaging.sendEmail(mails);
        }catch(Exception ex){
            
            ExceptionUtils.createExceptionLog('SendCreditApplicationFormLinkController - sendEmail',ex.getMessage(),ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
        
    }
    
}