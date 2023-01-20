declare module "@salesforce/apex/AnnouncementController.insertDetails" {
  export default function insertDetails(param: {announcementDetailsJSON: any, usersName: any}): Promise<any>;
}
declare module "@salesforce/apex/AnnouncementController.getAnnouncementsByUser" {
  export default function getAnnouncementsByUser(): Promise<any>;
}
declare module "@salesforce/apex/AnnouncementController.getUserNameOfKeyMessage" {
  export default function getUserNameOfKeyMessage(param: {keyMessageRecordId: any}): Promise<any>;
}
declare module "@salesforce/apex/AnnouncementController.getUserNameOfKeyMessages" {
  export default function getUserNameOfKeyMessages(param: {keyMessageRecordId: any}): Promise<any>;
}
declare module "@salesforce/apex/AnnouncementController.getUserNameOfKeyMessageReply" {
  export default function getUserNameOfKeyMessageReply(param: {username: any, record: any, recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/AnnouncementController.getMessages" {
  export default function getMessages(): Promise<any>;
}
declare module "@salesforce/apex/AnnouncementController.getReplyMessage" {
  export default function getReplyMessage(param: {currentRecordId: any}): Promise<any>;
}
declare module "@salesforce/apex/AnnouncementController.getReplyMessageOfLoggedInUser" {
  export default function getReplyMessageOfLoggedInUser(param: {currentRecordId: any}): Promise<any>;
}
