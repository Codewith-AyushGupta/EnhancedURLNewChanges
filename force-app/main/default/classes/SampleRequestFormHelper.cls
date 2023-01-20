public class SampleRequestFormHelper {
    
    public static void handleBeforeInsert(List<Sample_Request_Form__c> sampleRequestForms){
        updateOwner(sampleRequestForms);   
    }
    
    private static void updateOwner(List<Sample_Request_Form__c> sampleRequestForms){
        List<Group> sampleRequestFormQueue = [select Id from Group where Type = 'Queue' and name = 'Sample Request Form Queue'];
        Id recordTypeId = Schema.SObjectType.Sample_Request_Form__c.getRecordTypeInfosByName().get('Decor24 Samples').getRecordTypeId();
         Id WebsiterecordTypeId = Schema.SObjectType.Sample_Request_Form__c.getRecordTypeInfosByDeveloperName().get('Website_Samples').getRecordTypeId();
        for(Sample_Request_Form__c sampleRequestForm : sampleRequestForms){    
                   
            if(sampleRequestForm.Sample_Request_Form_Status__c.containsIgnoreCase('Submitted')
                && !sampleRequestFormQueue.isEmpty()
                && sampleRequestForm.RecordtypeId == recordTypeId || sampleRequestForm.RecordtypeId == WebsiterecordTypeId){
                
                sampleRequestForm.OwnerId = sampleRequestFormQueue[0].Id;
            }
        }
    }
    
    public static void handleBeforeUpdate(Map<Id,Sample_Request_Form__c> oldSampleRequestFormById,List<Sample_Request_Form__c> sampleRequestForms){
        performValidationAndStatusUpdateAndCopyApprovalCommentsOnRecord(oldSampleRequestFormById,sampleRequestForms);   
    }
    
    public static void performValidationAndStatusUpdateAndCopyApprovalCommentsOnRecord(Map<Id,Sample_Request_Form__c> oldSampleRequestFormById,
                                                List<Sample_Request_Form__c> sampleRequestForms){
        
        List<Group> sampleRequestFormQueue = [select Id from Group where Type = 'Queue' and name = 'Sample Request Form Queue'];
        Id recordTypeId = Schema.SObjectType.Sample_Request_Form__c.getRecordTypeInfosByDeveloperName().get('Decor24_Samples').getRecordTypeId();
        Id WebsiterecordTypeId = Schema.SObjectType.Sample_Request_Form__c.getRecordTypeInfosByDeveloperName().get('Website_Samples').getRecordTypeId();
        Set<Id> approvedSampleRequestIds = new Set<Id>();
        System.debug('WebsiterecordTypeId   '+WebsiterecordTypeId);
        System.debug('sampleRequestFormQueue   '+sampleRequestFormQueue[0].Id);
        for(Sample_Request_Form__c sampleRequestForm : sampleRequestForms){            
            Sample_Request_Form__c oldRecord = oldSampleRequestFormById.get(sampleRequestForm.Id);    
                   
            if(sampleRequestForm.Sample_Request_Form_Status__c != oldRecord.Sample_Request_Form_Status__c
                && sampleRequestForm.Sample_Request_Form_Status__c.containsIgnoreCase('Submitted')
                && !sampleRequestFormQueue.isEmpty()
                && sampleRequestForm.RecordtypeId == recordTypeId || sampleRequestForm.RecordtypeId == WebsiterecordTypeId){
                
                sampleRequestForm.OwnerId = sampleRequestFormQueue[0].Id;
            }
                    
           
           /* if(sampleRequestForm.Sample_Request_Form_Status__c != oldRecord.Sample_Request_Form_Status__c
                && sampleRequestForm.Sample_Request_Form_Status__c != null
                && sampleRequestForm.Sample_Type__c == null
                && sampleRequestForm.Sample_Request_Form_Status__c.containsIgnoreCase('Approved')){                   
               sampleRequestForm.addError('Please open sample request form and select sample type');
            }
            
            else {*/
                if(sampleRequestForm.Sample_Request_Form_Status__c != oldRecord.Sample_Request_Form_Status__c
                    && sampleRequestForm.Sample_Request_Form_Status__c.containsIgnoreCase('Approved')){
                    approvedSampleRequestIds.add(sampleRequestForm.Id);
                }
                            
               /* if(sampleRequestForm.Sample_Request_Form_Status__c != oldRecord.Sample_Request_Form_Status__c
                    && sampleRequestForm.Sample_Request_Form_Status__c.containsIgnoreCase('Approved')
                    && sampleRequestForm.Sample_Type__c == 'Stock Sample'){
                    system.debug('\n--settig With warehouse team--');
                    sampleRequestForm.Sample_Request_Form_Status__c = 'With warehouse team';
                }
                if(sampleRequestForm.Sample_Request_Form_Status__c != oldRecord.Sample_Request_Form_Status__c
                    && sampleRequestForm.Sample_Request_Form_Status__c.containsIgnoreCase('Approved')
                    && sampleRequestForm.Sample_Type__c == 'Special Order'){
                    system.debug('\n--settig with Purchase Team--');
                    sampleRequestForm.Sample_Request_Form_Status__c = 'With Purchase team';
                }
            }*/
        }
        system.debug('\n--approvedSampleRequestIds--'+approvedSampleRequestIds);
        
        if(!approvedSampleRequestIds.isEmpty()){
            // query Sample Request    
            Map<Id,Sample_Request_Form__c> sampleRequestWithApprovalComments = 
                new SampleFormsSelector().getRecordWithApprovalComments(approvedSampleRequestIds);
            system.debug('\n--sampleRequestWithApprovalComments--'+sampleRequestWithApprovalComments);
            
            for(Sample_Request_Form__c sampleRequestForm : sampleRequestForms){            
                Sample_Request_Form__c oldRecord = oldSampleRequestFormById.get(sampleRequestForm.Id);    
                
                system.debug('\n--new status--'+sampleRequestForm.Sample_Request_Form_Status__c);
                system.debug('\n--old status--'+oldRecord.Sample_Request_Form_Status__c);
               /* if(sampleRequestForm.Sample_Request_Form_Status__c != oldRecord.Sample_Request_Form_Status__c
                    && (sampleRequestForm.Sample_Request_Form_Status__c.containsIgnoreCase('With warehouse team')
                        || sampleRequestForm.Sample_Request_Form_Status__c.containsIgnoreCase('With Purchase team'))){*/                
                    
                    if(sampleRequestWithApprovalComments.containsKey(sampleRequestForm.Id)
                        && sampleRequestWithApprovalComments.get(sampleRequestForm.Id).ProcessSteps != null
                        && !sampleRequestWithApprovalComments.get(sampleRequestForm.Id).ProcessSteps.isEmpty()){
                        system.debug('\n--comments--'+sampleRequestWithApprovalComments.get(sampleRequestForm.Id).ProcessSteps);
                        sampleRequestForm.Approval_Comments__c = sampleRequestWithApprovalComments.get(sampleRequestForm.Id).ProcessSteps[0].Comments;
                    }
              //  }            
            }
        }
    }
}