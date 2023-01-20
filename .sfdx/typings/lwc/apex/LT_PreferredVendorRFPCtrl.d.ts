declare module "@salesforce/apex/LT_PreferredVendorRFPCtrl.getContactsByContactIds" {
  export default function getContactsByContactIds(param: {contactID: any}): Promise<any>;
}
declare module "@salesforce/apex/LT_PreferredVendorRFPCtrl.getPickListValues" {
  export default function getPickListValues(param: {objectName: any, fieldName: any}): Promise<any>;
}
declare module "@salesforce/apex/LT_PreferredVendorRFPCtrl.fetchExistingPreferredVendorData" {
  export default function fetchExistingPreferredVendorData(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/LT_PreferredVendorRFPCtrl.savePrefferdVendorData" {
  export default function savePrefferdVendorData(param: {masterSectionWrapper: any, currectSection: any, preferredVendorId: any, lstcontentVersionId: any}): Promise<any>;
}
declare module "@salesforce/apex/LT_PreferredVendorRFPCtrl.shareUploadFile" {
  export default function shareUploadFile(param: {contentVersionIds: any, pvRecordId: any}): Promise<any>;
}
declare module "@salesforce/apex/LT_PreferredVendorRFPCtrl.getUploadedFiles" {
  export default function getUploadedFiles(param: {preferredVendorRecordId: any}): Promise<any>;
}
declare module "@salesforce/apex/LT_PreferredVendorRFPCtrl.deleteUploadedFile" {
  export default function deleteUploadedFile(param: {contentDocLinkId: any}): Promise<any>;
}
declare module "@salesforce/apex/LT_PreferredVendorRFPCtrl.submitPreferredVendorForm" {
  export default function submitPreferredVendorForm(param: {preferredVendorRecordId: any}): Promise<any>;
}
