public without sharing class AnnouncementController {
    @AuraEnabled
    public static void insertDetails(string announcementDetailsJSON ,String usersName){
        System.debug('users name===>> '+usersName);
        Set<Id>groupIDs=new Set<Id>();
        Set<Id>userIDs=new Set<Id>();
        Map<Id, String> publicGroup=new Map<Id, String>();
        List<AnnouncementUser__c> announcementUsers=new List<AnnouncementUser__c>();
        List < String > userNameList = usersName.split( ',' );
        System.debug('strList name===>> '+userNameList);
        
        
        Announcement__c announcement =(Announcement__c) JSON.deserialize(announcementDetailsJSON, Announcement__c.class);
        
        String userString='';
        List<String> listData = (List<String>)JSON.deserialize(usersName,List<String>.class);
        System.debug('listData-------->'+listData);
        Announcement__c announcementInstance = new Announcement__c();
        announcementInstance.Message__c = announcement.Message__c; 
         
         try{
            insert announcementInstance;
             for(String ids:listData){
                 AnnouncementUser__c anno=new AnnouncementUser__c();
                 anno.User_Name__c=ids;
                 anno.AnnouncementId__c=announcementInstance.Id;
                 announcementUsers.add(anno);
             }
				insert announcementUsers;
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('AnnouncementController - insertDetails',e.getMessage(),e.getStackTraceString());

        }
        
    }
    
    @AuraEnabled
    public static List<Announcement__c> getAnnouncementsByUser(){
        //get current user name
        String userFname=UserInfo.getName().deleteWhitespace();
        Id userId = UserInfo.getUserId();
        System.debug('userID  '+userFname);
        //group IDs
        Set<Id> groupIDs=new Set<Id>();
        //announmentIDsgetAnnouncementsByUser
        Set<Id> announcementsId=new Set<Id>();
        for(AnnouncementUser__c ann:AnnouncementSelector.getAllAnnouncements()){
                    announcementsId.add(ann.AnnouncementId__c);
        }
        
        List<Announcement__c> announcements=new List<Announcement__c>();
        
        if(!announcementsId.isEmpty()){
            announcements=AnnouncementSelector.getAnnouncementsByUser(announcementsId);  //order by CreatedDate desc
        }
        
        
        try{
            return announcements;
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('AnnouncementController - getAnnouncementsByUser',e.getMessage(),e.getStackTraceString());
          return announcements;
        }
        
        
    }
    
    @AuraEnabled 
    public static List<Announcement__c> getUserNameOfKeyMessage(List<String> keyMessageRecordId){
        System.debug('keyMessageRecordId---'+keyMessageRecordId);
         Set<Id> recordIds=new Set<Id>();
        for(String ids:keyMessageRecordId){
            recordIds.add(ids);
        }
        List<Announcement__c> userIds=new List<Announcement__c>();
        
    
        try{
            userIds=AnnouncementSelector.getAnnouncementsByUser(recordIds);
               return userIds;
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('AnnouncementController - getMessages',e.getMessage(),e.getStackTraceString());
              return userIds;
        }
         
    }
    
    @AuraEnabled 
    public static List<Announcement__c> getUserNameOfKeyMessages(List<String> keyMessageRecordId){
        System.debug('keyMessageRecordId---'+keyMessageRecordId);
         Set<Id> recordIds=new Set<Id>();
        for(String ids:keyMessageRecordId){
            recordIds.add(ids);
        }
        List<Announcement__c> userIds=new List<Announcement__c>();
        
    
        try{
            userIds=AnnouncementSelector.getUserNameOfKeyMessages(recordIds);
               return userIds;
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('AnnouncementController - getMessages',e.getMessage(),e.getStackTraceString());
              return userIds;
        }
         
    }
    @AuraEnabled 
    public static string getUserNameOfKeyMessageReply(Id username,String record,String recordId){
        
        Announcement__c announcement =(Announcement__c) JSON.deserialize(record, Announcement__c.class);
        Reply_Message__c rpyMessage=new Reply_Message__c();
        rpyMessage.Reply_Message__c=announcement.Reply_message__c;
        rpyMessage.User__c=UserInfo.getUserId();
        rpyMessage.Announcement__c=recordId;
        try{
            insert rpyMessage;
            return 'successfull';
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('AnnouncementController - getUserNameOfKeyMessageReply',e.getMessage(),e.getStackTraceString());
            return e.getMessage();
        }
    }
    
    @AuraEnabled 
    public static List<Announcement__c> getMessages(){
        List<Announcement__c> announcementData=new List<Announcement__c>();
        announcementData=AnnouncementSelector.getMessages();
        try{
           return announcementData;
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('AnnouncementController - getMessages',e.getMessage(),e.getStackTraceString());
          return announcementData;
        }
        
    }
    
    @AuraEnabled
    public static List<Reply_Message__c> getReplyMessage(String currentRecordId){
        List<Reply_Message__c> replyMessage=new List<Reply_Message__c> ();
        replyMessage=AnnouncementSelector.getReplyMessage(currentRecordId);
      
        try{
           return replyMessage;
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('AnnouncementController - getReplyMessage',e.getMessage(),e.getStackTraceString());
        	 return replyMessage;
        }
    }
    
    @AuraEnabled
    public static List<Reply_Message__c> getReplyMessageOfLoggedInUser(String currentRecordId){
        List<Reply_Message__c> replyMessage=new List<Reply_Message__c>();
        replyMessage=AnnouncementSelector.getReplyMessageOfLoggedInUser(currentRecordId);
       
        try{
          return replyMessage;
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('AnnouncementController - getReplyMessageOfLoggedInUser',e.getMessage(),e.getStackTraceString());
        	  return replyMessage;
        }
    }
    
}