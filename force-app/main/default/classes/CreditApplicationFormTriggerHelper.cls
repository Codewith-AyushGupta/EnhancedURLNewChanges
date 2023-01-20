public class CreditApplicationFormTriggerHelper {

    // flag for skip the trigger
    public static boolean skipCreditTrigger = false;
    
    // this is the method is used to set the status in review if there is change in the trigger
    // and the previous status is submitted
    public static void handleBeforeUpdate(List<Credit_Application_Form__c> listOfCreditAppForm, 
                                        Map<Id,Credit_Application_Form__c> oldCreditApplication){
        
        changeStatus(listOfCreditAppForm, oldCreditApplication);
        
    }
    
    private static void changeStatus(List<Credit_Application_Form__c> listOfCreditAppForm, 
                                        Map<Id,Credit_Application_Form__c> oldCreditApplication){
                                            system.debug('in change status');
        
        // for each record which is updated
        for(Credit_Application_Form__c crditApplication : listOfCreditAppForm){
            
            // getting the old record
            Credit_Application_Form__c oldCredit = oldCreditApplication.get(crditApplication.Id);
            system.debug('\n--old status--'+oldCredit.Application_Status__c);
            system.debug('\n--new status--'+crditApplication.Application_Status__c);
            
            // if old status is submit and there is no change in the status then status to in review
            if(oldCredit.Application_Status__c == 'Submitted'
                && oldCredit.Application_Status__c == crditApplication.Application_Status__c){
                crditApplication.Application_Status__c = 'In Review';
            } 
        }
    } 
}