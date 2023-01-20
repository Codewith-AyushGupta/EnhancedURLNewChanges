declare module "@salesforce/apex/AccountController.getAccounts" {
  export default function getAccounts(): Promise<any>;
}
declare module "@salesforce/apex/AccountController.saveReports" {
  export default function saveReports(param: {ReportRecord: any, deletedids: any}): Promise<any>;
}
declare module "@salesforce/apex/AccountController.getKerridgeRecord" {
  export default function getKerridgeRecord(): Promise<any>;
}
declare module "@salesforce/apex/AccountController.updateAccounts" {
  export default function updateAccounts(param: {editedAccountList: any}): Promise<any>;
}
