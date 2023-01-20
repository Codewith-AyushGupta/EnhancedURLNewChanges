@isTest
public class UserSelectorTest {
    @isTest
    static void getUsersByUserIdsTest(){
      Set<Id> userIds = new Map<Id, User>([select id from User]).keySet();
		Map<Id,User>  pBiddersById=UserSelector.getUsersByUserIds(userIds);
    }
}