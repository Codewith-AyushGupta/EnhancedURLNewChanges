declare module "@salesforce/apex/CustomLookupController.fetchRecords" {
  export default function fetchRecords(param: {objectName: any, filterField: any, searchString: any, value: any, queryfilterField: any, queryfilterFieldValue: any, fieldsToBeDisplayed: any, fieldsLabelToBeDisplayed: any}): Promise<any>;
}
declare module "@salesforce/apex/CustomLookupController.fetchAccounts" {
  export default function fetchAccounts(param: {accountName: any}): Promise<any>;
}
declare module "@salesforce/apex/CustomLookupController.fetchAccountAddress" {
  export default function fetchAccountAddress(param: {accountId: any}): Promise<any>;
}
