public class HomePageWonOppController {
@AuraEnabled
    public static List<LouisvilleConfiguration__mdt> getLinks(){
        Set<String> categorynames = new Set<String>();
        categorynames.add(louisvilleTileConstants.WON_OPPORTUNITY_LINKS);
        return LouisvilleConfigurationSelector.getRecordsByCategory(categorynames);
    } 
}