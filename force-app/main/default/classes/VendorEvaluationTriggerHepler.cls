public class VendorEvaluationTriggerHepler {
    
    public static void isBeforehelper(List<VendorEvaluation__c> VendorEvaluations){
      beforeInsertCheckQuarter(VendorEvaluations);
        beforeInsertCheckYear(VendorEvaluations);
        
    }
    public static void isBeforeUpdatehelper(List<VendorEvaluation__c> VendorEvaluations,Map<Id,VendorEvaluation__c> mapOfIdAndVendorEvaluation){
        beforeInsertCheckYear(VendorEvaluations);
        beforeUpdateCheckQuarter(VendorEvaluations,mapOfIdAndVendorEvaluation);
 }

        public static void beforeInsertCheckYear(List<VendorEvaluation__c> VendorEvaluations){
            String currentYears = String.valueOf(Date.Today().Year());
            for(VendorEvaluation__c ve:VendorEvaluations){
                if(ve.Year__c != currentYears){
                  ve.Year__c.addError('Please select Current Year');   
                }
            }
            
        }
    public static void beforeInsertCheckQuarter(List<VendorEvaluation__c> VendorEvaluations){
        System.debug('--------mapOfIdAndVendorEvaluation----'+VendorEvaluations);
        Integer Month = Date.Today().Month();
        List<String> Q1=new List<String>{'Q1'};
        List<String> Q2=new List<String>{'Q1','Q2'};
        List<String> Q3=new List<String>{'Q1','Q2','Q3'};
        List<String> Q4=new List<String>{'Q1','Q2','Q3','Q4'};
        System.debug('---Month----'+Month);
        System.debug('------Q1----'+Q1);
        System.debug('------Q2----'+Q2);
        System.debug('------Q3----'+Q3);
        System.debug('------Q4----'+Q4);
        for(VendorEvaluation__c ve:VendorEvaluations){
            if(Month ==1 || Month ==2 ||Month ==3 ) {
              if(!Q1.contains(ve.Quarter__c)){
              ve.Quarter__c.addError('Please select Quater 1'); 
            }  
            }
           if(Month ==4 || Month ==5 ||Month ==6 ) {
              if(!Q2.contains(ve.Quarter__c)){
              ve.Quarter__c.addError('Please select Quater 1 Or Quater 2'); 
            }  
            } 
            if(Month ==7 || Month ==8 ||Month ==9 ) {
              if(!Q3.contains(ve.Quarter__c)){
              ve.Quarter__c.addError('Please select Quater1 Or Quater 2 Or Quater 3'); 
            }  
            } 
            
    }
}
    public static void beforeUpdateCheckQuarter(List<VendorEvaluation__c> VendorEvaluations,Map<Id,VendorEvaluation__c> mapOfIdAndVendorEvaluation){
        System.debug('--------mapOfIdAndVendorEvaluation----'+VendorEvaluations);
        Integer Month = Date.Today().Month();
        List<String> Q1=new List<String>{'Q1'};
        List<String> Q2=new List<String>{'Q1','Q2'};
        List<String> Q3=new List<String>{'Q1','Q2','Q3'};
        List<String> Q4=new List<String>{'Q1','Q2','Q3','Q4'};
        System.debug('---Month----'+Month);
        System.debug('------Q1----'+Q1);
        System.debug('------Q2----'+Q2);
        System.debug('------Q3----'+Q3);
        System.debug('------Q4----'+Q4);
        for(VendorEvaluation__c ve:VendorEvaluations){
            if(ve.Quarter__c != mapOfIdAndVendorEvaluation.get(ve.Id).Quarter__c){
                if(Month ==1 || Month ==2 ||Month ==3 ) {
              if(!Q1.contains(ve.Quarter__c)){
              ve.Quarter__c.addError('Please select Quater 1'); 
            } 
            }
             
            
           if(Month ==4 || Month ==5 ||Month ==6 ) {
              if(!Q2.contains(ve.Quarter__c)){
              ve.Quarter__c.addError('Please select Quater 1 Or Quater 2'); 
            }  
            } 
            if(Month ==7 || Month ==8 ||Month ==9 ) {
              if(!Q3.contains(ve.Quarter__c)){
              ve.Quarter__c.addError('Please select Quater1 Or Quater 2 Or Quater 3'); 
            }  
            } 
            }       
    }
}
}