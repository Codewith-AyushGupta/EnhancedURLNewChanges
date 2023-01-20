@RestResource(UrlMapping='/SelectionSheet/*')
global class SelectionSheetRestAPI {
    @HttpPost
    global static void creatingSelectionSheet(){
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String strReq = req.requestBody.toString();
        System.debug('req'+req.requestBody.toString());
        
        if(String.isNotBlank(strReq)){
            KerridgeOrdersRestAPIPayLoad respWrapper = KerridgeOrdersRestAPIPayLoad.parse(strReq);
            System.debug('respWrapper'+respWrapper);
            
            List<Selection_Sheet__c> lstSelSheet = new List<Selection_Sheet__c>();
            List<Product2> lstPro = new List<Product2>();
            for(KerridgeOrdersRestAPIPayLoad.SelectionSheet  data : respWrapper.SelectionSheet){
                Selection_Sheet__c selectSheet = new Selection_Sheet__c();
                selectSheet.Name=data.name;
               	selectSheet.Opportunity__c = data.SalesforceId;
                selectSheet.Kerridge_Account_ID__c =data.ssmCustId;
                selectSheet.SS_Line_Number__c=data.ssLineNumber;
                selectSheet.Product_name__c=data.productName;
                selectSheet.Quantity__c=data.quantity;
                selectSheet.Status__c=data.status;
                selectSheet.UOM__c=data.uom;
                selectSheet.Date_created_in_SSM__c=data.dateCreatedInSSM;
                selectSheet.Date_last_modified_in_SSM__c=data.dateLastModifiedInSSM;
                selectSheet.Selection_Sheet_ID__c=data.selectId;
                
                lstSelSheet.add(selectSheet);
            }
            
            JSONGenerator jsonGen = JSON.createGenerator(true);
            
            if(lstSelSheet.size()>0){
                insert lstSelSheet;            
                //  jsonGen.writeStartObject();
                //  jsonGen.writeFieldName('kerridgeOrders');
                jsonGen.writeStartArray();
                for(Selection_Sheet__c objSS :lstSelSheet){  
                    jsonGen.writeStartObject();
                    jsonGen.writeStringField('Name',objSS.Name);
                    jsonGen.writeStringField('Salesforce_Id',objSS.Id);
                    jsonGen.writeEndObject();
                }
                jsonGen.writeEndArray();
                // jsonGen.writeEndObject();
            }
            String jsonData = jsonGen.getAsString();
            system.debug('josnData'+jsonData);
            
            res.responseBody = Blob.valueOf(jsonData);        
        }
        else{
            res.responseBody = Blob.valueOf('Invalid  Request Body or Request body is Empty'); 
        }
    }
}