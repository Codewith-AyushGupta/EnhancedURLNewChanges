public class HomePageOrderController {
@AuraEnabled
    public static List<LouisvilleConfiguration__mdt> getLinks(){
        Set<String> categorynames = new Set<String>();
        categorynames.add(louisvilleTileConstants.ORDER_LINKS);
        return LouisvilleConfigurationSelector.getRecordsByCategory(categorynames);
    } 
}