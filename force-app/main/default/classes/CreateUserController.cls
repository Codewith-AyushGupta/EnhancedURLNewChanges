public class CreateUserController {
    public static Id createUser(){
        String random = String.valueof(DateTime.now().getTime());
        
        Profile profile = [SELECT Id FROM Profile WHERE Name='Sales Representative - Contractor'];
        
        User user = new User();
        user.Email = 'random@random.com'+random;
        user.UserName = 'admin@random.com'+random;
        user.LastName = 'random'+random;
        user.Alias = 'random';
        user.ProfileId = profile.Id;
        user.EmailEncodingKey='UTF-8';
        user.LanguageLocaleKey='en_US';
        user.LocaleSidKey='en_US';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        insert user;
        return user.id;
    }
}