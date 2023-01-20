public class UserSelector {
public static Map<Id,User> getUsersByUserIds(Set<Id> ids){
        return new Map<Id,User>([SELECT Id,User_Branch__c 
                                 FROM User 
                                 WHERE Id IN :ids]);
    }
}