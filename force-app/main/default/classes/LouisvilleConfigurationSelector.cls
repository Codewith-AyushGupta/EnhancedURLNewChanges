public class LouisvilleConfigurationSelector {
    
    public static List<LouisvilleConfiguration__mdt>  getValuesFromdeveloperName(Set<String> sString){
        List<LouisvilleConfiguration__mdt> louisvilleConfiguration = new List<LouisvilleConfiguration__mdt>();
        List<LouisvilleConfiguration__mdt> reversedlouisvilleConfiguration = new List<LouisvilleConfiguration__mdt>();
        louisvilleConfiguration = [select Value__c,MasterLabel,DeveloperName from LouisvilleConfiguration__mdt where DeveloperName IN :sString];
        for(Integer i = louisvilleConfiguration.size() - 1; i >= 0; i--){
            reversedlouisvilleConfiguration.add(louisvilleConfiguration[i]);
        }
        
        return reversedlouisvilleConfiguration;
    }
    
    public static List<LouisvilleConfiguration__mdt> getRecordsByCategory(Set<String> categories){
        return [SELECT Name__c,Value__c
                	FROM LouisvilleConfiguration__mdt 
                	WHERE Category__c IN: categories];
    }
}