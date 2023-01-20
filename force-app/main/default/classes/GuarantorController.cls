public without sharing class GuarantorController {
    
    /****
* This method return the guarantors details by mapping that details into the wrappers
*/ 
    @AuraEnabled
    public static List<GuarantorsWrapper> getguarantorsForCreditApplicationForm(Id creditApplicationID){
        //Guarantors details 
        List<GuarantorsWrapper> lstguarantorDetailWrap = new List<GuarantorsWrapper>();
        
        List<Guarantor__c> lstguarantors = GuarantorSelector.getGuarantors(new Set<Id>{creditApplicationID});
        
        if(!lstguarantors.isEmpty()){
            for(Guarantor__c guarantor : lstguarantors){
                lstguarantorDetailWrap.add(guarantorWrapperFieldsMapping(guarantor));
            }
        }
        return lstguarantorDetailWrap;
    }
    
    /****
	* This method Delete the guarantor details 
	* called from agreement (Parent Obj)
	*/ 
    public static void deleteguarantorsRecord(Set<Id> guarantorIdForDelete){
        List<Guarantor__c> listOfGuarantor = GuarantorSelector.getIdsToDelete(new Set<Id>(guarantorIdForDelete));
        delete listOfGuarantor;
        
    }
    
    
    /***
* Upsert the guarantors
*called from agreement (Parent Obj)
*/ 
    @AuraEnabled
    public static void upsertguarantorsDetails(Id creditApplicationID, List<GuarantorsWrapper> lstguarantorWrap){
        List<Guarantor__c> guarantors = new List<Guarantor__c>();
        
        for(GuarantorsWrapper gWrap : lstguarantorWrap){
            guarantors.add(getguarantorsFromMappingObject(creditApplicationID, gWrap));
        }
        
        try{
            upsert guarantors;
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    
    /***
* get guarantors From Mapping Object 
*/ 
    public static Guarantor__c getguarantorsFromMappingObject(Id creditApplicationID, GuarantorsWrapper guarantorWrap){
        //Instance of credit application form 
        Guarantor__c guarantorDetail = new Guarantor__c();
        
        if(String.isNotBlank(guarantorWrap.guarantorId)){
            guarantorDetail.Id = guarantorWrap.guarantorId;
        }else{
            //add credit Application ID in principal record
            guarantorDetail.Credit_Application_Form__c = creditApplicationID;
        }
        
        guarantorDetail.Name = guarantorWrap.guarantorName;
        guarantorDetail.Guarantor_Date__c = guarantorWrap.guarantorDate;
        guarantorDetail.Guarantor_Email__c = guarantorWrap.guarantorEmail;
        guarantorDetail.Spouse_s_Name__c = guarantorWrap.spousesName;
        guarantorDetail.Spouse_Date__c = guarantorWrap.spousesDate;  
        guarantorDetail.Spouse_Email__c = guarantorWrap.spousesEmail;
        
        return guarantorDetail;
    }
    
    /**   
/*** this method save the guarantor details into wrapper from the Credit Apllication record ***/
    
    public static GuarantorsWrapper guarantorWrapperFieldsMapping(Guarantor__c guarantor){
        
        //instance of wrapper-CreditPrincipalWrapper 
        GuarantorsWrapper GuarantorInst = new GuarantorsWrapper();
        GuarantorInst.guarantorId = guarantor.Id;
        GuarantorInst.guarantorName=guarantor.Name;
        GuarantorInst.guarantorDate = guarantor.Guarantor_Date__c;
        GuarantorInst.guarantorEmail = guarantor.Guarantor_Email__c;
        GuarantorInst.spousesName = guarantor.Spouse_s_Name__c;
        GuarantorInst.spousesDate = guarantor.Spouse_Date__c;
        GuarantorInst.spousesEmail = guarantor.Spouse_Email__c;
        
        return GuarantorInst;
    }    
    
    //Wrapper class to handle the Guarantors Details
    public class GuarantorsWrapper{
        @AuraEnabled public String guarantorId {get;set;}
        @AuraEnabled public String guarantorName {get; set;}
        @AuraEnabled public Date guarantorDate {get; set;}
        @AuraEnabled public String guarantorEmail {get; set;}
        @AuraEnabled public String spousesName {get; set;}
        @AuraEnabled public Date spousesDate {get; set;}
        @AuraEnabled public String spousesEmail {get; set;}
        @AuraEnabled public boolean isDelete{get; set;}
        
        //constructor
        public GuarantorsWrapper(){
            isDelete = False;
        }
    }
}