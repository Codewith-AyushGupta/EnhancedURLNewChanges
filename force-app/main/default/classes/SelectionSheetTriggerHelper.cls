public class SelectionSheetTriggerHelper {
    
    public static void isbeforeInsert(List<Selection_Sheet__c> selectionSheet_lineItems){
        try{
            getselectionSheetLineItems(selectionSheet_lineItems);
        } catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('SelectionSheetTriggerHelper - isbeforeInsert',e.getMessage(),e.getStackTraceString());
        }
    }
    
    public static void selectionSheetsAfterInsert(List<Selection_Sheet__c> sheets){
        set<Id> opportunityIds=new set<Id>();
        Map<Id,opportunityLineItem> mapOfProductIdAndopportunityLineItem=new Map<Id,opportunityLineItem>();
        Map<Id,Selection_Sheet__c> mapOfProductIdAndSelectionSheet=new Map<Id,Selection_Sheet__c>();
        Map<Id,set<String>> mapOfOpportunityIdAndSelectionSheetStatus=new Map<Id,set<String>>();
        Map<Id,Opportunity> MapOfselectsheetsAndOpportunity=new Map<Id,Opportunity>();
        Map<Id,List<Selection_Sheet__c>> mapOfOppIdAndSSsize= new Map<Id,List<Selection_Sheet__c>>();
        Map<Id,List<opportunityLineItem>> mapOfOppIdAndOppLineitems= new Map<Id,List<opportunityLineItem>>();
        Integer selectionsheetSize=0;
        for(Selection_Sheet__c selectionsheet:sheets){
            if(selectionsheet.Status__c !=null && selectionsheet.Opportunity__c != null){
                opportunityIds.add(selectionsheet.Opportunity__c);
            }
        }
        List<opportunityLineItem> opLineItems=opportunityLineItemSelector.getOpportunityLineItemByIds(opportunityIds);
        //System.debug('opLineItems-----'+opLineItems);
        for(opportunityLineItem opLine:opLineItems){
            if(opLine.Product2Id!=null){
                mapOfProductIdAndopportunityLineItem.put(opLine.Product2Id,opLine);
            }
            if(opLine.OpportunityId!=null){
                mapOfProductIdAndopportunityLineItem.put(opLine.Product2Id,opLine);
           
            if(mapOfOppIdAndOppLineitems.containskey(opLine.OpportunityId)){
                List<opportunityLineItem> olne=mapOfOppIdAndOppLineitems.get(opLine.OpportunityId);
                olne.add(opLine);
            }else{
                mapOfOppIdAndOppLineitems.put(opLine.OpportunityId,new List<opportunityLineItem>{opLine});
            }
            }
        }
        //System.debug('mapOfProductIdAndopportunityLineItem----'+mapOfProductIdAndopportunityLineItem);
        List<Selection_Sheet__c> selectionSheets=SelectionSheetSelector.getSelectionSheetByOpportunityIds(opportunityIds);
        System.debug('selectionSheets------'+selectionSheets);
        for(Selection_Sheet__c sheet:selectionSheets){
            if(sheet.Product__c!=null){
                mapOfProductIdAndSelectionSheet.put(sheet.Product__c,sheet);
            }
        }
        System.debug('mapOfProductIdAndSelectionSheet-----'+mapOfProductIdAndSelectionSheet);
        for(Id prodId:mapOfProductIdAndopportunityLineItem.keyset()){
            if(mapOfProductIdAndSelectionSheet.containsKey(prodId)){
                
               //System.debug('mapOfProductIdAndSelectionSheet.containsKey(prodId)===='+mapOfProductIdAndSelectionSheet.containsKey(prodId));
                if(mapOfOpportunityIdAndSelectionSheetStatus.containskey(mapOfProductIdAndSelectionSheet.get(prodId).Opportunity__c)){
                    //System.debug('mapOfProductIdAndSelectionSheet.get(prodId).Opportunity__c----'+mapOfProductIdAndSelectionSheet.get(prodId).Opportunity__c);
                    set<String> sheetStatus=mapOfOpportunityIdAndSelectionSheetStatus.get(mapOfProductIdAndSelectionSheet.get(prodId).Opportunity__c);
                    sheetStatus.add(mapOfProductIdAndSelectionSheet.get(prodId).Status__c);
                    mapOfOpportunityIdAndSelectionSheetStatus.put(mapOfProductIdAndSelectionSheet.get(prodId).Opportunity__c,sheetStatus);
                }else{
                    mapOfOpportunityIdAndSelectionSheetStatus.put(mapOfProductIdAndSelectionSheet.get(prodId).Opportunity__c,new set<String> {mapOfProductIdAndSelectionSheet.get(prodId).Status__c});
                }
                
                if(mapOfOppIdAndSSsize.containskey(mapOfProductIdAndSelectionSheet.get(prodId).Opportunity__c)){
                    List<Selection_Sheet__c> olne=mapOfOppIdAndSSsize.get(mapOfProductIdAndSelectionSheet.get(prodId).Opportunity__c);
                    olne.add(mapOfProductIdAndSelectionSheet.get(prodId));
                }else{
                    mapOfOppIdAndSSsize.put(mapOfProductIdAndSelectionSheet.get(prodId).Opportunity__c,new List<Selection_Sheet__c>{mapOfProductIdAndSelectionSheet.get(prodId)});
                }
            }
        }
        
        for(Id opId:mapOfOpportunityIdAndSelectionSheetStatus.keyset()){
            //System.debug('value of map---'+mapOfOpportunityIdAndSelectionSheetStatus.get(opId));
            //System.debug('mapofIdAndSelectionsheet-selectsheet121----'+(String.valueOf(mapOfOpportunityIdAndSelectionSheetStatus.get(opId)));
            //System.debug('mapOfOppIdAndOppLineitems.get(opId).size()-----'+mapOfOppIdAndOppLineitems.get(opId).size());
            if(mapOfOppIdAndOppLineitems.containsKey(opId) && mapOfOppIdAndSSsize.containsKey(opId) && mapOfOppIdAndSSsize.get(opId).size() == mapOfOppIdAndOppLineitems.get(opId).size()){
                //System.debug('mapOfOppIdAndSSsize.get(opId).size()----'+mapOfOppIdAndSSsize.get(opId).size());
                
                if( mapOfOpportunityIdAndSelectionSheetStatus.get(opId).size() == 1){
                    //System.debug('sdfwerwe----'+String.valueOf(mapOfOpportunityIdAndSelectionSheetStatus.get(opId)));
                    if(mapOfOpportunityIdAndSelectionSheetStatus.get(opId).contains('Order')){
                        //System.debug('order---');
                        Opportunity opp = new Opportunity();
                        opp.Id=opId;
                        // System.debug('opp.Id---'+opp.Id);
                        opp.StageName='On Order';
                        MapOfselectsheetsAndOpportunity.put(opp.Id,opp);
                        //System.debug('MapOfselectsheetsAndOpportunity1211----'+MapOfselectsheetsAndOpportunity.values());
                    }else if(String.valueOf(mapOfOpportunityIdAndSelectionSheetStatus.get(opId))=='{Sold}'){
                        Opportunity opp = new Opportunity();
                        opp.Id=opId;
                        opp.StageName='Sold';
                        MapOfselectsheetsAndOpportunity.put(opp.Id,opp);
                        //System.debug('MapOfselectsheetsAndOpportunity1212----'+MapOfselectsheetsAndOpportunity.values());
                        
                    }else if(mapOfOpportunityIdAndSelectionSheetStatus.get(opId).contains('Inquiry/Planning')){
                        Opportunity opp = new Opportunity();
                        opp.Id=opId;
                        opp.StageName='Inquiry/Planning';
                        MapOfselectsheetsAndOpportunity.put(opp.Id,opp);
                        //System.debug('MapOfselectsheetsAndOpportunity1213----'+MapOfselectsheetsAndOpportunity.values());
                    }
                }
                else if(mapOfOpportunityIdAndSelectionSheetStatus.get(opId).size()==2 && (mapOfOpportunityIdAndSelectionSheetStatus.get(opId).contains('Order') && mapOfOpportunityIdAndSelectionSheetStatus.get(opId).contains('Sold'))){
                    
                    
                    Opportunity opp = new Opportunity();
                    opp.Id=opId;
                    opp.StageName='On Order';
                    MapOfselectsheetsAndOpportunity.put(opp.Id,opp);
                    //System.debug('MapOfselectsheetsAndOpportunity121----'+MapOfselectsheetsAndOpportunity.values());
                    
                }else if(mapOfOpportunityIdAndSelectionSheetStatus.get(opId).size()==2 && mapOfOpportunityIdAndSelectionSheetStatus.get(opId).contains('Inquiry/Planning')){
                    Opportunity opp = new Opportunity();
                    opp.Id=opId;
                    opp.StageName='Partial Order';
                    MapOfselectsheetsAndOpportunity.put(opp.Id,opp);
                    //System.debug('MapOfselectsheetsAndOpportunity121----'+MapOfselectsheetsAndOpportunity.values());
                }
                else if(mapOfOpportunityIdAndSelectionSheetStatus.get(opId).size()==3){
                    Opportunity opp = new Opportunity();
                    opp.Id=opId;
                    opp.StageName='Partial Order';
                    MapOfselectsheetsAndOpportunity.put(opp.Id,opp);
                    //System.debug('MapOfselectsheetsAndOpportunity121----'+MapOfselectsheetsAndOpportunity.values());
                }
            }else{
                Opportunity opp = new Opportunity();
                opp.Id=opId;
                opp.StageName='Partial Order';
                MapOfselectsheetsAndOpportunity.put(opp.Id,opp);
                //System.debug('MapOfselectsheetsAndOpportunity-----'+MapOfselectsheetsAndOpportunity.values());
            }
        }
        try{
            update MapOfselectsheetsAndOpportunity.values(); 
        }catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('SelectionSheetTriggerHelper - selectionSheetsAfterInsert',e.getMessage(),e.getStackTraceString());
        }
        //System.debug('MapOfselectsheetsAndOpportunity121----'+MapOfselectsheetsAndOpportunity.values());
    }  
    
    public static void getselectionSheetLineItems(List<Selection_Sheet__c> selectionSheet_lineItems){
        //system.debug('K_lineItems----'+selectionSheet_lineItems);
        List<String> selectionSheetLineItemProductName= new List<String>();
        List<Selection_Sheet__c> K_orderItem=new List<Selection_Sheet__c>();
        Map<String,Id> mapOFIdAndProduct=new Map<String,Id>();
        for(Selection_Sheet__c items:selectionSheet_lineItems){
            if(items.Product_name__c!=null){
                selectionSheetLineItemProductName.add(items.Product_name__c); 
            }
        }
        //System.debug('selectionSheetLineItemProductName----'+selectionSheetLineItemProductName);
        List<Product2> products = ProductSelector.fetchProducts(selectionSheetLineItemProductName);
        for(Product2 prod:products){
            mapOFIdAndProduct.put(prod.Name,prod.id);
        }
        //System.debug('mapOFIdAndProduct-----'+mapOFIdAndProduct.values());
        for(Selection_Sheet__c items:selectionSheet_lineItems){
            if(mapOFIdAndProduct.containsKey(items.Product_name__c)){
                items.Product__c= mapOFIdAndProduct.get(items.Product_name__c);
            }       
        }
    }
    
    /*public static void checkduplicateProduct(list<Selection_Sheet__c> selectionSheets){
        Map<Id,list<Selection_Sheet__c>> mapOfOppIdAndSelectionSheetItems=new Map<Id,list<Selection_Sheet__c>>();
        for(Selection_Sheet__c sheet:selectionSheets){
            if(mapOfOppIdAndSelectionSheetItems.containsKey(sheet.Opportunity__c)){
                List<Selection_Sheet__c> selctionSheetItems=mapOfOppIdAndSelectionSheetItems.get(sheet.Opportunity__c);
                selctionSheetItems.add(sheet);
                mapOfOppIdAndSelectionSheetItems.put(sheet.Opportunity__c,selctionSheetItems);
            }else{
                mapOfOppIdAndSelectionSheetItems.put(sheet.Opportunity__c,new list<Selection_Sheet__c>{sheet});
            }
        }
        System.debug('mapOfOppIdAndSelectionSheetItems------'+mapOfOppIdAndSelectionSheetItems);
        List<Selection_Sheet__c> allSelectionSheetItems = [SELECT Id,Opportunity__c,Product_name__c,Name,Product__c,Product__r.Name,Product__r.Color__c FROM Selection_Sheet__c where Opportunity__c IN:mapOfOppIdAndSelectionSheetItems.keyset()];
        for(Selection_Sheet__c sheet : allSelectionSheetItems){
            if(mapOfOppIdAndSelectionSheetItems.containsKey(sheet.Opportunity__c)){
                for(Selection_Sheet__c newSheet: mapOfOppIdAndSelectionSheetItems.get(sheet.Opportunity__c)){
                    if(sheet.Product__c == newSheet.Product__c){
                        newSheet.addError('This product can not be Insert because product already present.Please Upadte Quantity.');
                    }
                    else if(newSheet.Product__c==null && !String.isBlank(newSheet.Product_name__c)){
                        if(newSheet.Product_name__c==sheet.Product_name__c){
                            newSheet.addError('This product can not be Insert because product already present.Please Upadte Quantity.');
                        }
                    }
                }
            }
        }
    }*/
    public static void productInsertInOpportunityLineItem(List<Selection_Sheet__c> selectionSheets){
        List<OpportunityLineItem> opportunityLineItemsToBeInsert=new List<OpportunityLineItem>();
        List<PricebookEntry> priceBooks=new List<PricebookEntry>();
        List<Selection_Sheet__c> selectionSheetsforInsert=new List<Selection_Sheet__c>();
        Map<Id,Selection_Sheet__c> MapOfListOfSelectionSheetByProductId=new Map<Id,Selection_Sheet__c>();
        Map<Id,Id> mapOfPricebookIdByOppId=new Map<Id,Id>();
        Map<Id,List<PricebookEntry>> mapOfPricebooksByOppId=new Map<Id,List<PricebookEntry>>();
        Map<Id,PricebookEntry> mapOfPricebookByProductIdct=new Map<Id,PricebookEntry>();
        Id recordTypeId =RecordTypeSelector.getIdByDeveloperNameAndObjectType('Retail_Opportunities','Opportunity');
        system.debug('---------recordTypeId----'+recordTypeId);
        
        Set<Id> productIds=new Set<Id>();
        List<PricebookEntry> customPriceBookEntry=new List<PricebookEntry>();
        set<Id> OppIds=new set<Id>();
        for(Selection_Sheet__c sheet:selectionSheets){
            if(sheet.Product__c !=null){
                System.debug('sheet.Opportunity__r.RecordTypeId------'+sheet.Opportunity__r.RecordTypeId);
                MapOfListOfSelectionSheetByProductId.put(sheet.Product__c,sheet);
                OppIds.add(sheet.Opportunity__c);
            }
        }
        System.debug('MapOfListOfSelectionSheetByProductId-----'+MapOfListOfSelectionSheetByProductId);
        
        Map<Id,Opportunity> mapOfOpportunityBYId= new Map<Id,Opportunity>(OpportunitySelector.getOpportunitiesByIdsAndRecordId(OppIds,recordTypeId));
        
         System.debug('mapOfOpportunityBYId-----'+mapOfOpportunityBYId);
        List<PricebookEntry> priceBooksForcheckStatnderPrice=PriceBookEntrySelector.getPriceBooksByProductIdAndPricebookId(MapOfListOfSelectionSheetByProductId.keySet());
       System.debug('priceBooksForcheckStatnderPrice----'+priceBooksForcheckStatnderPrice);
        for(PricebookEntry pb:priceBooksForcheckStatnderPrice){
            mapOfPricebookByProductIdct.put(pb.Product2Id,pb);
        }
        System.debug('mapOfPricebookByProductIdct-----'+mapOfPricebookByProductIdct);
        for(PricebookEntry pBook:mapOfPricebookByProductIdct.values()){
            if(MapOfListOfSelectionSheetByProductId.containsKey(pBook.Product2Id) && 
               mapOfOpportunityBYId.containsKey(MapOfListOfSelectionSheetByProductId.get(pBook.Product2Id).Opportunity__c) &&
               String.isNotBlank(MapOfListOfSelectionSheetByProductId.get(pBook.Product2Id).Quantity__c) &&
              decimal.valueof(MapOfListOfSelectionSheetByProductId.get(pBook.Product2Id).Quantity__c)>0 && mapOfOpportunityBYId.get(MapOfListOfSelectionSheetByProductId.get(pBook.Product2Id).Opportunity__c).Pricebook2Id ==  pBook.Pricebook2.Id){
                  System.debug('MapOfListOfSelectionSheetByProductId----'+MapOfListOfSelectionSheetByProductId);
                   OpportunityLineItem opLineItem=new OpportunityLineItem();
                   opLineItem.OpportunityId=MapOfListOfSelectionSheetByProductId.get(pBook.Product2Id).Opportunity__c;
                   opLineItem.Product2Id=pBook.Product2Id;
                   opLineItem.Quantity= decimal.valueof(MapOfListOfSelectionSheetByProductId.get(pBook.Product2Id).Quantity__c);
                   opLineItem.UnitPrice=pBook.UnitPrice;
                   opLineItem.PricebookEntryId=pBook.Id;
                   opportunityLineItemsToBeInsert.add(opLineItem);
                   Selection_Sheet__c ss=new Selection_Sheet__c();
                   ss.Id=MapOfListOfSelectionSheetByProductId.get(pBook.Product2Id).Id;
                   ss.Product_Added__c=true;
                   selectionSheetsforInsert.add(ss);
               }
            
        }
       
        //System.debug('opportunityLineItemsToBeInsert--------'+opportunityLineItemsToBeInsert);
        if(!opportunityLineItemsToBeInsert.isEmpty()){
            //Database.SaveResult[] lsr = Database.insert(opportunityLineItemsToBeInsert,false);
            insert opportunityLineItemsToBeInsert;
            //System.debug('opportunityLineItemsToBeInsert------'+opportunityLineItemsToBeInsert);
        }
        if(!selectionSheetsforInsert.isEmpty()){
            update selectionSheetsforInsert;
            //System.debug('selectionSheetsforInsert------'+selectionSheetsforInsert);
        }
    }
    
}