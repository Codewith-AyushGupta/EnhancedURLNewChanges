public class sendPreferredVendorRPFController {
    @auraEnabled
    public static String sendEmailWithPreferredVendorRPFLink(Id contactID){
        
        List<Contact> contacts = ContactSelector.getContacts(new Set<Id>{contactID});
        System.debug('---------contacts-----'+contacts);
        if(contacts.isEmpty()){
            throw new AuraHandledException('No Contact Found.');
        }
        
        if(String.isBlank(contacts[0].Email)){
            throw new AuraHandledException('Email Address not found.');
        }
        System.debug('-----------contacts[0].Email--------'+contacts[0].Email);
        try{
            //call send email method
            if(!Test.isRunningTest())
                sendEmail(contacts[0]);
            System.debug('---------ccontacts[0]-----'+contacts[0]);
            //return the contact Name
            return contacts[0].FirstName + ' ' + contacts[0].LastName;
        }catch(Exception ex){
            ExceptionUtils.createExceptionLog('sendEmailWithPreferredVendorFormLink',ex.getMessage(),ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }   
        
    }
    
    /***
* This method send the email based on salesforce contact email
*/ 
    public static void sendEmail(Contact con){
        
        System.debug('-----------con--------'+con.Email);
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        //Set list of people who should get the email
        List<String> sendTo = new List<String>();
        
        sendTo.add(con.Email);
        mail.setToAddresses(sendTo);
        
        //Set email content
        mail.setSubject('Preferred Vendor RPF');
        String body = 'Hello ' + (String.isBlank( con.FirstName) ? '' :  (con.FirstName + ' ')) + con.LastName + ', ';
        body += '<br/>'; 
        body += 'Thank you for your interest in becoming one of Louisville Tile’s Preferred Partners. Please click the link below to complete the requested form.';
       	body += '<br/>';
        body += '<br/>';
        body += '<a href='+''+System.Label.Preferred_Vendor_RPF_link+''+'?contactid='+ con.Id +'>Click Here</a>'+' '+' to open the Preferred Vendor RPF ';
        body += '<br/>'; 
        body += '<br/>'; 
        body += 'Thanks,';
        body += '<br/>'; 
       // body +=UserInfo.getName(); 
        
        mail.setHtmlBody(body);
        
        //Add your email to the master list
        mails.add(mail);
        
        //Send all emails in the master list
        try{
            if(!Test.isRunningTest())
                Messaging.sendEmail(mails);
        }catch(Exception ex){
            ExceptionUtils.createExceptionLog(' - sendEmail',ex.getMessage(),ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
    } 
    @AuraEnabled
    public static List<Contact> getContactRecord(Id recordId){
                List<Contact> contacts = ContactSelector.getContacts(new Set<Id>{recordId});
        return contacts;

    }

}