public class RegisterJobCmpController {
    @AuraEnabled
    public static list<OpportunityLineItem> getOpportunityLineItembyOpportunityId(String oppId){
        list<OpportunityLineItem> opliList=new list<OpportunityLineItem>();
   
         try{
             opliList=opportunityLineItemSelector.getOpportunityLineItemByOpportunity(new Set<Id>{oppId});
             return opliList;
            
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('RegisterJobCmpController - getOpportunityLineItembyOpportunityId',e.getMessage(),e.getStackTraceString());
             return opliList;
        }
        
    }
    @AuraEnabled  
    public static Integer getOpportunityLineItemSizebyOpportunityId(String oppId){
        list<OpportunityLineItem> opliList=new list<OpportunityLineItem>();
          try{
              opliList=opportunityLineItemSelector.getOpportunityLineItemSizebyOpportunityId(new Set<Id>{oppId});
             return opliList.size();
            
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('RegisterJobCmpController - getOpportunityLineItemSizebyOpportunityId',e.getMessage(),e.getStackTraceString());
             return opliList.size();
        }
    }
     @AuraEnabled    
    public static boolean updateOpportunityLineItems( List <OpportunityLineItem > updatedOpportunityLineItems ) {    
            
        try {  
          
            update updatedOpportunityLineItems;  
            return true;  
              
        } catch(Exception e) {  
          
            return false;  
              
        } 
    }
    @auraEnabled
    public static String sendRegistrationEmail(Id oppId, String JsonOpportunityLineItem){
        System.debug('oppId----'+oppId);
        System.debug('JsonOpportunityLineItem-----'+JsonOpportunityLineItem);
        List<OpportunityLineItem> opliList = (List<OpportunityLineItem>) JSON.deserialize(JsonOpportunityLineItem, List<OpportunityLineItem>.class);
        List<Opportunity> opportunities = OpportunitySelector.getOpportunitiesById(new Set<Id>{oppId});
        System.debug('-------opportunities----'+opportunities[0]);
        if(opportunities.isEmpty()){
            throw new AuraHandledException('No Opportunity Found.');
        }
        
        if(String.isBlank(opportunities[0].owner.Name)){
            throw new AuraHandledException('Email Address not found.');
        }
        try{
            //call send email method
            if(!Test.isRunningTest())
                sendEmail(opportunities[0],opliList);
            for(Opportunity opp:opportunities){
                //opp.Project_Registration__c	='In Process';
                opp.Register_Job_Send_Email__c=true;
            }
            update opportunities;
            for(Opportunity opp1:opportunities){
                opp1.Project_Registration__c	='In Process';
                //opp1.Register_Job_Send_Email__c=true;
            }
            update opportunities;
            //return the contact Name
            return 'SuccessFully Send Email';
        }catch(Exception ex){
            ExceptionUtils.createExceptionLog('Error',ex.getMessage(),ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }   
        
    }
    
    /***
* This method send the email based on salesforce contact email
*/ 
    public static void sendEmail(Opportunity opp,List<OpportunityLineItem> opliList){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        //Set list of people who should get the email
        List<String> sendTo = new List<String>();
        List<String> ccAddresses = new List<String>();
        String emails=opp.Owner.Email;
        System.debug('----Email-'+emails);
        
        sendTo.add(Label.Register_Job_Email);
        ccAddresses.add(emails);
        ccAddresses.add(Label.Register_Job_Cc_email);
        mail.setToAddresses(sendTo);
        mail.setccAddresses(ccAddresses);
        
        //Set email content
        mail.setSubject('Project Registration request for '+opp.owner.Name+'');
        String body = '';
        body += '<br/>'; 
        body += '&#9726; <b>Opportunity Name-</b> '+ opp.Name;
       	body += '<br/>';
        body +='&#9726; <b>Opportunity Owner -</b> '+opp.owner.Name;
        //body += '<a href='+''+System.Label.Preferred_Vendor_RPF_link+''+'?contactid='+ con.Id +'>Click Here</a>'+' '+' to open the Preferred Vendor RPF ';
        body += '<dl>';
        body +='<dt>&#9726; <b>Job Information:</b></dt>'; 
       
        if(opp.Project_Name__c != null){
          body += '<dd>&bull; <b>Project Name- </b>'+opp.Project_Name__c+'</dd>'; 
        }else{
          body += '<dd>&bull; <b>Project Name- </b>'+ +'</dd>'; 
        }
        
        body += '<dd><dl>'; 
        body +='<dt>&bull; <b>Location</b></dt>';
        if(opp.City__c != null){
           body +='<dd>&#9675; <b>City- </b>'+opp.City__c+'</dd>'; 
        }else{
          body +='<dd>&#9675; <b>City- </b>'+ +'</dd>';  
        }
        if(opp.State__c != null){
           body +='<dd>&#9675; <b>State- </b>'+opp.State__c+'</dd>'; 
        }else{
          body +='<dd>&#9675; <b>State- </b>'+ +'</dd>';  
        }
        body +='</dl></dd>';
        body += '<dd>&bull; <b>Close Date- </b>'+formatDate(opp.CloseDate)+'</dd>'; 
        body += '<dd>&bull; <b>Stage- </b>'+opp.StageName+'</dd>'; 
        body += '</dl>';
	    body += '<dl>';
        body +='<dt>&#9726; <b>Product Table:</b></dt>'; 
        body += '<dd>';
        body += '<table border="1" style="border-collapse: collapse;text-align: center" ><tr><th style="padding: 15px;">Product Name</th><th style="padding: 15px;" >Quantity</th><th style="padding: 15px;">Register Job</th><th style="padding: 15px;">Sales Price </th><th style="padding: 15px;">Color</th></tr>';

    //iterate over list and output columns/data into table rows...
    for(OpportunityLineItem opli: opliList){

        String ProductName = opli.Product2.Name; if(opli.Product2.Name == null){ProductName = '';}
        String quantity = String.valueOf(opli.Quantity); if(opli.Quantity == null){quantity = '';}
		String registerJob = String.valueOf(opli.Register_Job__c); 
		 String listprice = String.valueOf(opli.ListPrice);        
        String color = String.valueOf(opli.product2.Color__c); if(opli.product2.Color__c == null){color = '';} 
        if(opli.Register_Job__c == true)
        {
            registerJob = '&#10004;';
        }else{
            registerJob = '';
        }
        body += '<tr><td>' + ProductName + '</td><td>'+quantity+'</td><td>'+registerJob+'</td><td>'+listprice+'</td><td>'+color+'</td></tr>';
    }

    //close table...
    body += '</table>';
        body +='</dd>';
        body +='</dl>';
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
            ExceptionUtils.createExceptionLog('sendEmail',ex.getMessage(),ex.getStackTraceString());
            throw new AuraHandledException(ex.getMessage());
        }
    }
    public static String formatDate(Date d) {
    return  d.month()+'/' + d.day()+'/'+d.year();
}
}