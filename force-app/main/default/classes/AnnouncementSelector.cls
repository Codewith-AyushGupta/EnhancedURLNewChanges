public class AnnouncementSelector {
    
    public static List<Announcement__c> getAnnouncementsByUser(Set<Id> announcementsId){
        return [SELECT ID,Name, Message__c,Reply_message__c,CreatedDate,Sender_Name__c,CreatedById,Receiver__c,
                           (Select Id,Name,Reply_Message__c From Reply_Messages__r where User__c=:UserInfo.getUserId())
                           FROM Announcement__c 
                           WHERE Id IN:announcementsId ];
    }
    public static List<Announcement__c> getUserNameOfKeyMessages(Set<Id> keyMessageRecordId){
        return [select Id,Name,Receiver__c,Message__c,CreatedById from Announcement__c Where Id IN: keyMessageRecordId];
    }
    public static List<Announcement__c> getMessages(){
        List<Announcement__c> announcementData=[select Id,Name,Receiver__c,Message__c,CreatedById, CreatedDate,(Select Id,Name,User__r.FirstName From Reply_Messages__r) from Announcement__c Where CreatedById =:UserInfo.getUserId()];
        return announcementData;
    }
     public static List<Reply_Message__c> getReplyMessage(String currentRecordId){
        List<Reply_Message__c> replyMessage=[select Id,Name,Reply_Message__c,Announcement__c, CreatedDate,Announcement__r.Message__c,User__r.FirstName from Reply_Message__c WHERE Announcement__c =:currentRecordId];
        return replyMessage;
    }
    public static List<Reply_Message__c> getReplyMessageOfLoggedInUser(String currentRecordId){
        List<Reply_Message__c> replyMessage=[select Id,Name,Reply_Message__c,Announcement__c, CreatedDate,Announcement__r.Message__c,User__r.FirstName from Reply_Message__c WHERE Announcement__c =:currentRecordId AND User__c =: UserInfo.getUserId()];
        return replyMessage;
    }
    public static List<AnnouncementUser__c> getAllAnnouncements(){
        List<AnnouncementUser__c> announcements=[SELECT Id,AnnouncementId__c FROM AnnouncementUser__c Where User_Name__c=: UserInfo.getUserId()];
        return announcements;
    }
}