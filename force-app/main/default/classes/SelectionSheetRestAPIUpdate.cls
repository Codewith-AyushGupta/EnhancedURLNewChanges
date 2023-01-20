@RestResource(UrlMapping='/SelectionSheetUpdate/*')
global class SelectionSheetRestAPIUpdate {
    @HttpPost
    global static void updateSelectionSheet(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String strReq = req.requestBody.toString();
        String conId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        
        Selection_Sheet__c result = [SELECT Id,Name,Opportunity__c,Kerridge_Account_ID__c,SS_Line_Number__c,Product_name__c,Quantity__c,Status__c,UOM__c,
                                     Date_created_in_SSM__c,Date_last_modified_in_SSM__c,Selection_Sheet_ID__c
                                     FROM Selection_Sheet__c WHERE id = :conId];
        
        
        
        if(String.isNotBlank(strReq)){
            KerridgeOrdersRestAPIPayLoad respWrapper = KerridgeOrdersRestAPIPayLoad.parse(strReq);
            List<Selection_Sheet__c> lstSelectSheet = new List<Selection_Sheet__c>();
            
            for(KerridgeOrdersRestAPIPayLoad.SelectionSheet  data : respWrapper.SelectionSheet){
                
                result.Name=data.name;
             //   result.Opportunity__c = data.SalesforceId;
                result.Kerridge_Account_ID__c =data.ssmCustId;
                result.SS_Line_Number__c=data.ssLineNumber;
                result.Product_name__c=data.productName;
                result.Quantity__c=data.quantity;
                result.Status__c=data.status;
                result.UOM__c=data.uom;
                result.Date_created_in_SSM__c=data.dateCreatedInSSM;
                result.Date_last_modified_in_SSM__c=data.dateLastModifiedInSSM;
                result.Selection_Sheet_ID__c=data.selectId;                
                lstSelectSheet.add(result);
            }
            
            JSONGenerator jsonGen = JSON.createGenerator(true);
            
            if(lstSelectSheet.size()>0){
                update lstSelectSheet;
                //  jsonGen.writeStartObject();
                //  jsonGen.writeFieldName('kerridgeOrderLine');
                jsonGen.writeStartArray();
                for(Selection_Sheet__c kOrderLine :lstSelectSheet){
                    jsonGen.writeStartObject();
                    jsonGen.writeStringField('kerridgeOrderLineName',kOrderLine.Name);
                    jsonGen.writeStringField('Salesforce_Id',kOrderLine.Id);
                    jsonGen.writeEndObject();
                }
                jsonGen.writeEndArray();
                // jsonGen.writeEndObject();
            } 
            String jsonData = jsonGen.getAsString();
            system.debug('josnData'+jsonData);
            res.responseBody = Blob.valueOf(jsonData); 
        }else{
            res.responseBody = Blob.valueOf('Invalid  Request Body or Request body is Empty');
        }
    } 
}