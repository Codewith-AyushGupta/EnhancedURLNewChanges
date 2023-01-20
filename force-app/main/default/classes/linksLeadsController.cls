public class linksLeadsController {
    @AuraEnabled
    public static List<LouisvilleConfiguration__mdt> getLinks(){
        Set<String> categorynames = new Set<String>();
        categorynames.add(louisvilleTileConstants.LEAD_LINKS);
        return LouisvilleConfigurationSelector.getRecordsByCategory(categorynames);
    }      
}