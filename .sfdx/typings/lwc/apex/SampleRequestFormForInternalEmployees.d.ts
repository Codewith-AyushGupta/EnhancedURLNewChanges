declare module "@salesforce/apex/SampleRequestFormForInternalEmployees.fetchOnLoadConfigration" {
  export default function fetchOnLoadConfigration(): Promise<any>;
}
declare module "@salesforce/apex/SampleRequestFormForInternalEmployees.getExistingRecordById" {
  export default function getExistingRecordById(param: {sampleRequestFormId: any}): Promise<any>;
}
declare module "@salesforce/apex/SampleRequestFormForInternalEmployees.getStates" {
  export default function getStates(): Promise<any>;
}
declare module "@salesforce/apex/SampleRequestFormForInternalEmployees.saveAsDraft" {
  export default function saveAsDraft(param: {sampleRequestFormDetailsJSON: any, sampleItemsJSON: any}): Promise<any>;
}
declare module "@salesforce/apex/SampleRequestFormForInternalEmployees.createNewRecord" {
  export default function createNewRecord(param: {sampleRequestFormDetailsJSON: any, sampleItemsJSON: any, SelectedProduct: any}): Promise<any>;
}
declare module "@salesforce/apex/SampleRequestFormForInternalEmployees.queryProductDetailsFromProductId" {
  export default function queryProductDetailsFromProductId(param: {ProductId: any}): Promise<any>;
}
declare module "@salesforce/apex/SampleRequestFormForInternalEmployees.queryProductDetailsFromManufactureItemId" {
  export default function queryProductDetailsFromManufactureItemId(param: {manufactureItemId: any}): Promise<any>;
}
declare module "@salesforce/apex/SampleRequestFormForInternalEmployees.getUploadFile" {
  export default function getUploadFile(param: {sampleRequestFormId: any}): Promise<any>;
}
declare module "@salesforce/apex/SampleRequestFormForInternalEmployees.uploadFileDocument" {
  export default function uploadFileDocument(param: {sampleRequestFormId: any, fileName: any, contentType: any, base64Data: any}): Promise<any>;
}
declare module "@salesforce/apex/SampleRequestFormForInternalEmployees.fetchSelectedProducts" {
  export default function fetchSelectedProducts(param: {selectedProductIds: any}): Promise<any>;
}
