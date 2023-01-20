public class HomePageMarketingController {
@AuraEnabled
    public static List<LouisvilleConfiguration__mdt> getLinks(){
        Set<String> categorynames = new Set<String>();
        categorynames.add(louisvilleTileConstants.Marketing);
        return LouisvilleConfigurationSelector.getRecordsByCategory(categorynames);
    }
}