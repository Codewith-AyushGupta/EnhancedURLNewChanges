public class HomePageOpportunitiesController {
 @AuraEnabled
    public static List<LouisvilleConfiguration__mdt> getLinks(){
        Set<String> categorynames = new Set<String>();
        categorynames.add(louisvilleTileConstants.OPPORTUNITY_LINKS);
        return LouisvilleConfigurationSelector.getRecordsByCategory(categorynames);
    } 
}