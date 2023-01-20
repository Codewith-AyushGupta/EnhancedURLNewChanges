public without sharing class HomePageMainComponentController {
    
    @AuraEnabled
    public static Map<String,Integer> fetchOnLoadConfigration(){
              
        Map<String, Integer> configrations = GetRecordByCurrentUser.getRecordSize();
        return configrations;
    }
}