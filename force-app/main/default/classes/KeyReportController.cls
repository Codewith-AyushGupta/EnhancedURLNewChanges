public class KeyReportController {
    
    @AuraEnabled
    public static List<KeyReport__mdt> getReports(){
        List<KeyReport__mdt> keyReports = new List<KeyReport__mdt>();
        keyReports = [SELECT Id,MasterLabel,Value__c FROM KeyReport__mdt];
        return keyReports;
    }
    
    @AuraEnabled
    public static void saveUserCofig(String userConfigJSON){
        List<User_Configuration__c> usersConfigList=new List<User_Configuration__c>();
     
        User_Configuration__c userConfiguration  =(User_Configuration__c) JSON.deserialize(userConfigJSON, User_Configuration__c.class);
        User_Configuration__c userConfig = new User_Configuration__c();
        userConfig.Display_Name__c = userConfiguration.Display_Name__c;
        userConfig.User__c = userConfiguration.User__c;
        userConfig.URL_Link__c = userConfiguration.URL_Link__c;
        usersConfigList.add(userConfig);
        
        if(!usersConfigList.isEmpty()){
           insert userConfig;
        }
    }
}