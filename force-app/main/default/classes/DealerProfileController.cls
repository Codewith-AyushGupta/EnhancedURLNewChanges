public without sharing class DealerProfileController {
    
    @AuraEnabled
    public static Map<String,String> getMetaDataRecords(){
        Map<String,String> metadataValueByMetadataName= new Map<String,String>();       
        for(LouisvilleConfiguration__mdt louisvilleConfigurationRecord : LouisvilleConfigurationSelector.getRecordsByCategory(new Set<String>{'Dealer Profile'})){
            metadataValueByMetadataName.put(louisvilleConfigurationRecord.Name__c,louisvilleConfigurationRecord.Value__c);
        }
        return metadataValueByMetadataName;      
        
    }
    
    @AuraEnabled
    public static Map<String,List<String>> fetchOnLoadConfigration(Id accountId){
        DealerProfileFetchOnloadConfigration onLoadValues = new DealerProfileFetchOnloadConfigration();        
        
        Map<String, List<String>> configrations = onLoadValues.getPickListValues();
        return configrations;      
    }
    
    @AuraEnabled 
    public static List<Account> getAccountsById(Id accountId){
        String accountName;
        List<Account> accounts=AccountSelector.getAccountById(new set<Id> {accountId});
        try{
            
            return accounts;
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('DealerProfileController - getAccountNameById',e.getMessage(),e.getStackTraceString());
            accountName=e.getMessage();
            return accounts;
        }
        
        
    }
    
    @AuraEnabled
    public static List<Sales_And_Market__c> getAllDealerProfiles(Id accountId){
        
        return SalesAndMarketSelector.getAllDealerProfile(new Set<Id>{accountId});
    }
    @AuraEnabled
    public static DealerProfileWrapper getDealerProfileRecord(String selectedYear,Id accountId){
        DealerProfileWrapper displayRecord = new DealerProfileWrapper();
        List<DealerCustomerDetailsWrapper> dealercustomers=new List<DealerCustomerDetailsWrapper>();
        Sales_And_Market__c salesAndMarket=SalesAndMarketSelector.getSalesAndMarketByAccountIdAndCeatedYear(new set<Id>{accountId},selectedYear)[0];
        displayRecord.dealerName=salesAndMarket.Name;
        displayRecord.dealerAnnualSalesTotal=salesAndMarket.Total_Annual_Revenue__c;
        displayRecord.displayProfileCreatedDate=salesAndMarket.CreatedDate;
        displayRecord.ltdTileAndAncillarySalesMarketShareTarget=salesAndMarket.ltd_Tile_And_Ancillary_Sales_MST__c/100;
        displayRecord.ltdTileSalesMarketShareTarget=salesAndMarket.ltd_Tile_Sales_Market_MST__c/100;
        displayRecord.ltdAncillarySalesMarketShareTarget=salesAndMarket.ltd_Ancillary_Sales_MST__c/100;
        displayRecord.ltdTileAndAncillarySalesMarketShare=salesAndMarket.LTD_Tile_Ancillary_Sales_Market_Share__c/100;
        displayRecord.ltdTileSalesMarketShare=salesAndMarket.LTD_Tile_Sales_Market_Share__c/100;
        displayRecord.ltdAncillarySalesMarketShare=salesAndMarket.LTD_Ancillary_Sales_Market_Share__c/100;
        displayRecord.recordId=salesAndMarket.Id;
        displayRecord.createdYear=salesAndMarket.Created_year__c;
        displayRecord.dealerAnnualSalesTotalPercentage=salesAndMarket.Total_Annual_Revenue_Percentage__c;
        displayRecord.dealerAnnualPurchase=salesAndMarket.Assumed_Annual_Purchases__c;	
        displayRecord.dealerAnnualPurchasePercentage=salesAndMarket.Assumed_Annual_Purchases_Percentage__c/100;
        displayRecord.dealerAnnualTileSaleincludelabour=salesAndMarket.Annual_Tile_Sales_Include_labor__c;	
        displayRecord.dealerAnnualTileSaleincludelabourPercentage=salesAndMarket.Annual_Tile_Sales_Percentage__c/100;
        displayRecord.dealerAnnualTileandAnnualPurchase = salesAndMarket.Annual_Tile_Ancillary_Purchases__c;
        displayRecord.dealerAnnualTileandAnnualPurchasePercentage =	salesAndMarket.Annual_Tile_Ancillary_Purchases_per__c/100;
        displayRecord.tilePurchase=salesAndMarket.Tile_Purchases__c;	
        displayRecord.tilePurchasePercentage=salesAndMarket.Tile_Purchases_Percentage__c/100;	
        displayRecord.ancillaryPurchases=salesAndMarket.Ancillary_Purchases__c;	
        displayRecord.ancillaryPurchasesPercentage =salesAndMarket.Ancillary_Purchases_Percentage__c/100;	
        displayRecord.ltdTileAndAncillarySales=salesAndMarket.LTD_Tile_Ancillary_Sales__c;
        displayRecord.ltdTileAndAncillarySalesPercentage=salesAndMarket.LTD_Tile_Ancillary_Sales_Percentage__c/100;
        displayRecord.ltdTileSale=salesAndMarket.LTD_Tile_Sales__c;
        displayRecord.ltdTileSalePercentage=salesAndMarket.LTD_Tile_Sales_Percentage__c/100;	
        displayRecord.ltdAncillarySales=salesAndMarket.LTD_Ancillary_Sales__c;
        displayRecord.ltdAncillarySalesPercentage=salesAndMarket.LTD_Ancillary_Sales_Percentage__c/100;
        
        for(Dealer_Customer__c dCustomer:salesAndMarket.Dealer_Customers__r){
            DealerCustomerDetailsWrapper dealercustomer=new DealerCustomerDetailsWrapper();
            dealercustomer.customerType=dCustomer.Customer_Type__c;	
            
            dealercustomer.dealerCustomerId=dCustomer.Id;
            dealercustomer.selections=dCustomer.Selections__c;
            dealercustomer.customerName=	dCustomer.Customer_Name__c;
            dealercustomer.salesperson=dCustomer.Sales_Person__c;
            dealercustomer.supplier = dCustomer.Supplier__c;	
            dealercustomer.notes=dCustomer.Notes__c;
            dealercustomer.inactive=dCustomer.Inactive__c;
            dealercustomers.add(dealercustomer);
            
        }
        System.debug('dealercustomers----'+dealercustomers);
        displayRecord.dealerCustomerDetails=dealercustomers;
        //objMasterSectionAWrapper.currentTopAccount.addAll(lstCurrentAccount);
        System.debug('displayRecord----'+displayRecord);
        return displayRecord;
    }
    @AuraEnabled 
    public static String saveDisplayItems(String displayItemJSON, String accountId){
        set<id> displayitemsIdsToBeDeleted=new set<Id>();
        
        
        String msg;
        
            //System.debug('dealerCeramicType--'+dealerCeramicType);
            DisplayItemWrapper displayItemWRP = (DisplayItemWrapper)JSON.deserialize(displayItemJSON, DisplayItemWrapper.class);
            System.debug('DisplayTypeWrapper--'+displayItemWRP);
            
            //delete[select Id from displayItemWRP ];
            List<Display_Item__c> displayItems=new List<Display_Item__c>();
            
            for(DisplayItemByType dIitem:displayItemWRP.displayItemByTypeDetails){
                if(dIitem.ids !=null && dIitem.isDeleted == true){
                    displayitemsIdsToBeDeleted.add(dIitem.ids); 
                }
                System.debug('dIitem------'+dIitem);
                Display_Item__c displayItem=new Display_Item__c();
                if(dIitem.ids !=null && dIitem.isChange==true && dIitem.isDeleted==false){
                    displayItem.Id=dIitem.ids;  
                    
                    displayItem.Manufacturer__c=dIitem.manufacturer;
                    if(dIitem.dealerType =='Ancillary Items'){
                        displayItem.Supplier__c=dIitem.Supplier;
                    }
                    displayItem.Type__c=dIitem.dealerType;
                    displayItem.Price__c=dIitem.price;
                    displayItem.Style_Type__c=dIitem.styleType;
                    displayItem.Volume__c=dIitem.volume;
                    displayItem.Why_is_the_Dealer_using_products__c=dIitem.whyDealerUsingProduct;
                    displayItem.Account__c=accountId;
                    //displayItem.SalesandMarket__c=salesAndMarketId;
                    displayItems.add(displayItem);
                    System.debug('ceramicRecords---'+displayItems);
                }
                else if(dIitem.ids ==null && dIitem.isChange==true && dIitem.isDeleted==false){
                    
                    displayItem.Manufacturer__c=dIitem.manufacturer;
                    if(dIitem.dealerType =='Ancillary Items'){
                        displayItem.Supplier__c=dIitem.Supplier;
                    }
                    displayItem.Type__c=dIitem.dealerType;
                    displayItem.Price__c=dIitem.price;
                    displayItem.Style_Type__c=dIitem.styleType;
                    displayItem.Volume__c=dIitem.volume;
                    displayItem.Why_is_the_Dealer_using_products__c=dIitem.whyDealerUsingProduct;
                    displayItem.Account__c=accountId;
                    //displayItem.SalesandMarket__c=salesAndMarketId;
                    displayItems.add(displayItem);
                    System.debug('ceramicRecords---'+displayItems);
                }
                
            }
        try{
            if(!displayItems.isEmpty()){
                upsert displayItems; 
                msg='Record Saved !!';
            }      
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('DealerProfileController - saveDisplayItems',e.getMessage(),e.getStackTraceString());
            msg=e.getMessage();
        }
        
        try{
            if(!displayitemsIdsToBeDeleted.isEmpty()){
                delete DisplayItemSelector.getDisplayItemByIds(displayitemsIdsToBeDeleted);
                msg='Record Saved !!';
            }
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage() + e.getStackTraceString());
            ExceptionUtils.createExceptionLog('DealerProfileController - saveDisplayItems',e.getMessage(),e.getStackTraceString());
            msg=e.getMessage();
        }
        return msg;
    } 
    
    @AuraEnabled 
    public static List<DisplayItemByType> getDisplayItem(String objType,String currentYear, Id accountId){ 
        list<Display_Item__c> displayItems=new list<Display_Item__c>();
        DisplayItemWrapper disItem=new DisplayItemWrapper();
        List<DisplayItemByType> lstdisplayItemByTypeDetail=new List<DisplayItemByType>();
        for(Display_Item__c dItem:DisplayItemSelector.getDisplayItembBytypeAndAccountIdAndYear(objType,new Set<Id>{accountId})){
            DisplayItemByType dItemType=new DisplayItemByType();
            dItemType.ids=dItem.Id;
            //dItemType.salesAndMarketId=dItem.SalesandMarket__c;
            dItemType.manufacturer=dItem.Manufacturer__c;
            dItemType.Supplier=dItem.Supplier__c;
            dItemType.styleType=dItem.Style_Type__c;
            dItemType.price=dItem.Price__c;
            dItemType.volume=dItem.Volume__c;
            dItemType.whyDealerUsingProduct=dItem.Why_is_the_Dealer_using_products__c;
            dItemType.dealerType=dItem.Type__c;
            dItemType.isDeleted=false;
            lstdisplayItemByTypeDetail.add(dItemType);
        }
        
        try{
            return lstdisplayItemByTypeDetail;
            
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('DealerProfileController - getAccountDetails',e.getMessage(),e.getStackTraceString());
            return null; 
        }
        
    } 
    public static list<Account> getAccountDetails(Id accountId){ 
        list<Account> accounts=new list<Account>();
        try{
            accounts=AccountSelector.getAccountById(new Set<Id>{accountId});
            return accounts;      
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('DealerProfileController - getAccountDetails',e.getMessage(),e.getStackTraceString());
            return null; 
        }
        
    }
    @AuraEnabled
    public static Integer getRecordByYear(String selectedYear,Id recordId){
        List<Sales_And_Market__c> salesAndMarket=SalesAndMarketSelector.getSalesAndMarketByAccountIdAndCeatedYear(new set<id>{recordId},selectedYear);
        return salesAndMarket.size();
    }
    
    @AuraEnabled
    public static Id saveDealerProfileRecord(String dealerProfileJSON,String accountId){ 
        System.debug('dealerProfileJSON----'+dealerProfileJSON);
        DealerProfileWrapper objdealerProfileWrapper = (DealerProfileWrapper)JSON.deserialize(dealerProfileJSON, DealerProfileWrapper.class);
        System.debug('objdealerProfileWrapper----'+objdealerProfileWrapper);
        Sales_And_Market__c salesAndMarket= new Sales_And_Market__c();
        
        if(objdealerProfileWrapper.recordId !=null){
            salesAndMarket.Id= objdealerProfileWrapper.recordId;
        }
        salesAndMarket.Name=objdealerProfileWrapper.dealerName;
        salesAndMarket.ltd_Ancillary_Sales_MST__c=objdealerProfileWrapper.ltdAncillarySalesMarketShareTarget*100;
        salesAndMarket.ltd_Tile_Sales_Market_MST__c=objdealerProfileWrapper.ltdTileSalesMarketShareTarget*100;
        salesAndMarket.ltd_Tile_And_Ancillary_Sales_MST__c=objdealerProfileWrapper.ltdTileAndAncillarySalesMarketShareTarget*100;
        salesAndMarket.Total_Annual_Revenue__c=objdealerProfileWrapper.dealerAnnualSalesTotal;
        salesAndMarket.Created_year__c=objdealerProfileWrapper.createdYear;
        salesAndMarket.Total_Annual_Revenue_Percentage__c=objdealerProfileWrapper.dealerAnnualSalesTotalPercentage;
        salesAndMarket.Assumed_Annual_Purchases__c=objdealerProfileWrapper.dealerAnnualPurchase;
        salesAndMarket.Assumed_Annual_Purchases_Percentage__c=objdealerProfileWrapper.dealerAnnualPurchasePercentage*100;
        salesAndMarket.Annual_Tile_Sales_Include_labor__c=objdealerProfileWrapper.dealerAnnualTileSaleincludelabour;
        salesAndMarket.Annual_Tile_Sales_Percentage__c=objdealerProfileWrapper.dealerAnnualTileSaleincludelabourPercentage*100;
        salesAndMarket.Ancillary_Purchases__c=objdealerProfileWrapper.dealerAnnualPurchase;
        salesAndMarket.Ancillary_Purchases_Percentage__c=objdealerProfileWrapper.ancillaryPurchases;
        salesAndMarket.Ancillary_Purchases_Percentage__c=objdealerProfileWrapper.ancillaryPurchasesPercentage*100;
        salesAndMarket.Annual_Tile_Ancillary_Purchases__c=objdealerProfileWrapper.dealerAnnualTileandAnnualPurchase;	
        salesAndMarket.Annual_Tile_Ancillary_Purchases_per__c=objdealerProfileWrapper.dealerAnnualTileandAnnualPurchasePercentage*100;
        salesAndMarket.Tile_Purchases__c=objdealerProfileWrapper.tilePurchase;
        salesAndMarket.Tile_Purchases_Percentage__c=objdealerProfileWrapper.tilePurchasePercentage*100;
        salesAndMarket.LTD_Tile_Ancillary_Sales__c=objdealerProfileWrapper.ltdTileAndAncillarySales;
        salesAndMarket.LTD_Tile_Ancillary_Sales_Percentage__c=objdealerProfileWrapper.ltdTileAndAncillarySalesPercentage*100;
        salesAndMarket.LTD_Tile_Sales__c=objdealerProfileWrapper.ltdTileSale;
        salesAndMarket.LTD_Tile_Sales_Percentage__c=objdealerProfileWrapper.ltdTileSalePercentage*100;
        salesAndMarket.LTD_Ancillary_Sales__c=objdealerProfileWrapper.ltdAncillarySales;
        salesAndMarket.LTD_Ancillary_Sales_Percentage__c=objdealerProfileWrapper.ltdAncillarySalesPercentage*100;
        salesAndMarket.LTD_Tile_Ancillary_Sales_Market_Share__c=objdealerProfileWrapper.ltdTileAndAncillarySalesMarketShare*100;
        salesAndMarket.LTD_Tile_Sales_Market_Share__c=objdealerProfileWrapper.ltdTileSalesMarketShare*100;
        salesAndMarket.LTD_Ancillary_Sales_Market_Share__c=objdealerProfileWrapper.ltdAncillarySalesMarketShare*100;            
        salesAndMarket.Account__c=accountId;
        try{
            upsert salesAndMarket;       
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('DealerProfileController - saveDealerProfileRecord',e.getMessage(),e.getStackTraceString());
        }
        
        List<Dealer_Customer__c> lstdealerCustomerDetails=new List<Dealer_Customer__c>();
        for(DealerCustomerDetailsWrapper dcWrap:objdealerProfileWrapper.dealerCustomerDetails){
            Dealer_Customer__c dc=new Dealer_Customer__c();
            if(dcWrap.dealerCustomerId !=null && dcWrap.isChange ==true ){
                dc.Id= dcWrap.dealerCustomerId;
                dc.Customer_Name__c=dcWrap.customerName;
                dc.Customer_Type__c=dcWrap.customerType;
                dc.Sales_Person__c=dcWrap.salesperson;
                dc.Supplier__c=dcWrap.supplier;
                dc.Selections__c=dcWrap.selections;
                dc.Notes__c=dcWrap.notes;
                dc.Inactive__c=dcWrap.inactive;
                dc.Account__c=accountId;
                dc.Sales_And_Market__c=salesAndMarket.Id;
                lstdealerCustomerDetails.add(dc);
            }else if(dcWrap.dealerCustomerId ==null && dcWrap.isChange ==true)
            {
                dc.Customer_Name__c=dcWrap.customerName;
                dc.Customer_Type__c=dcWrap.customerType;
                dc.Sales_Person__c=dcWrap.salesperson;
                dc.Supplier__c=dcWrap.supplier;
                dc.Selections__c=dcWrap.selections;
                dc.Notes__c=dcWrap.notes;
                dc.Inactive__c=dcWrap.inactive;
                dc.Account__c=accountId;
                dc.Sales_And_Market__c=salesAndMarket.Id;
                lstdealerCustomerDetails.add(dc);}
            
        }
        try{
            if(!lstdealerCustomerDetails.isEmpty()){
                upsert lstdealerCustomerDetails;
            }
        }
        catch(Exception e) {
            System.debug('An exception occurred: ' + e.getMessage());
            ExceptionUtils.createExceptionLog('DealerProfileController - dealerCustomerdeatails',e.getMessage(),e.getStackTraceString());
        }
        return salesAndMarket.Id;
    }
    
    public class DealerProfileWrapper{
        @AuraEnabled public String dealerName;	
        @AuraEnabled public Id recordId;
        @AuraEnabled public Decimal dealerAnnualSalesTotal;	
        @AuraEnabled public Decimal dealerAnnualSalesTotalPercentage;	
        @AuraEnabled public Decimal dealerAnnualPurchase;	
        @AuraEnabled public Decimal dealerAnnualPurchasePercentage;
        @AuraEnabled public Decimal dealerAnnualTileSaleincludelabour;	
        @AuraEnabled public Decimal dealerAnnualTileSaleincludelabourPercentage;	
        @AuraEnabled public Decimal dealerAnnualTileandAnnualPurchase;	
        @AuraEnabled public Decimal dealerAnnualTileandAnnualPurchasePercentage;	
        @AuraEnabled public Decimal tilePurchase;	
        @AuraEnabled public Decimal tilePurchasePercentage;	
        @AuraEnabled public Decimal ancillaryPurchases;	
        @AuraEnabled public Decimal ancillaryPurchasesPercentage;	
        @AuraEnabled public Decimal ltdTileAndAncillarySales;
        @AuraEnabled public Decimal ltdTileAndAncillarySalesPercentage;	
        @AuraEnabled public Decimal ltdTileSale;	
        @AuraEnabled public Decimal ltdTileSalePercentage;	
        @AuraEnabled public Decimal ltdAncillarySales;
        @AuraEnabled public Decimal ltdAncillarySalesPercentage;
        @AuraEnabled public String createdYear;
        @AuraEnabled public Decimal ltdTileAndAncillarySalesMarketShareTarget;
        @AuraEnabled public Decimal ltdTileSalesMarketShareTarget;
        @AuraEnabled public Decimal ltdAncillarySalesMarketShareTarget;
        @AuraEnabled public Decimal ltdTileAndAncillarySalesMarketShare;
        @AuraEnabled public Decimal ltdTileSalesMarketShare;
        @AuraEnabled public Decimal ltdAncillarySalesMarketShare;
        @AuraEnabled public Datetime  displayProfileCreatedDate;
        @AuraEnabled public List<DealerCustomerDetailsWrapper> dealerCustomerDetails;
        
    }
    public class DealerCustomerDetailsWrapper {
        @AuraEnabled public String customerType;
        @AuraEnabled public String dealerCustomerId;
        @AuraEnabled public String selections;	
        @AuraEnabled public String customerName;	
        @AuraEnabled public String salesperson;	
        @AuraEnabled public String supplier;	
        @AuraEnabled public String notes;	
        @AuraEnabled public Boolean inactive;
        @AuraEnabled public Boolean isChange;
    }
    
    public class DisplayItemWrapper{
        @AuraEnabled public List<DisplayItemByType> displayItemByTypeDetails = new List<DisplayItemByType>();
    }
    public class DisplayItemByType {
        @AuraEnabled public Id ids;
        @AuraEnabled public String manufacturer;
        @AuraEnabled public String Supplier;
        @AuraEnabled public String styleType;	
        @AuraEnabled public decimal price;	
        @AuraEnabled public decimal volume;	
        @AuraEnabled public String whyDealerUsingProduct;
        @AuraEnabled public String dealerType;
        @AuraEnabled public Boolean isChange;
        @AuraEnabled public boolean isDeleted;
        @AuraEnabled public Id salesAndMarketId;
        
    }
    
}