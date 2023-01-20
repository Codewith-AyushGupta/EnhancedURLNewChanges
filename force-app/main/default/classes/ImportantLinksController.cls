public without sharing class ImportantLinksController {
     
    @AuraEnabled
    public static List<LouisvilleConfiguration__mdt> getLinks(){
        Set<String> devNames = new Set<String>();
        //devnames.add('Website_Sample_Request_Link');
        //devnames.add('Decor_24_Sample_Request_Link');
       devnames.add('Internal_Form_Sample_Request_Link');
        return LouisvilleConfigurationSelector.getValuesFromdeveloperName(devNames);
    }
}