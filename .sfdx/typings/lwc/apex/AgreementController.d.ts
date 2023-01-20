declare module "@salesforce/apex/AgreementController.getAgreementDetailsForCreditApplicationForm" {
  export default function getAgreementDetailsForCreditApplicationForm(param: {contactID: any}): Promise<any>;
}
declare module "@salesforce/apex/AgreementController.upsertAgreementDetails" {
  export default function upsertAgreementDetails(param: {contactID: any, agreementWrap: any}): Promise<any>;
}
declare module "@salesforce/apex/AgreementController.uploadAggrementDocument" {
  export default function uploadAggrementDocument(param: {creditApplicationID: any, fileName: any, contentType: any, base64Data: any}): Promise<any>;
}
declare module "@salesforce/apex/AgreementController.SaveFile" {
  export default function SaveFile(param: {parentId: any, fileName: any, base64Data: any, contentType: any, mapTitleVsConDocLink: any}): Promise<any>;
}
declare module "@salesforce/apex/AgreementController.getAllPicklistValues" {
  export default function getAllPicklistValues(): Promise<any>;
}
