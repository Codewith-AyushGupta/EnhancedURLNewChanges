public without sharing class SearchItemModalController  {
    @AuraEnabled
    public static RecordData fetchData(String searchKeywordsString , 
                                       list<string> searchAPI , 
                                       String objectToQuery , 
                                       boolean activeProductStatus , 
                                       list<string> fieldsToApplyFilterOn ,
                                       string pattern ,
                                       string color,
                                       Boolean applyFilter)
    {
        system.debug('coming');
        system.debug('Search Label'+fieldsToApplyFilterOn);
        system.debug('Search Object'+objectToQuery);
        system.debug(activeProductStatus);
        system.debug(searchKeywordsString);
        list<string> searchKeywordsList = new list<string>();
        searchKeywordsList = searchKeywordsString.trim().split(' ');
        string whereClause ='';
        string query='';
        string limits = '';
        string fields='SELECT Id,IsActiveProduct__c, ';
        string counter = 'SELECT COUNT () from Manufacturer_s_Items__c WHERE ';
        string active =' IsActiveProduct__c = true AND ';
        String whereClauseTwo = ' (Item_Class_1__c = \'MK\') AND ( Item_Class_2__c = \'AR\' OR Item_Class_2__c = \'VB\' OR Item_Class_2__c = \'VD\' )';
        
       map<String , map< String,integer >>  manufacturers = new map<String , map< String,integer >> ();
        
        for(integer i = 0 ; i < searchAPI.size() ; i++)
        {
            if( i == searchAPI.size() - 1 )
            {
                fields+=searchAPI[i];    
            }
            else
            {
                fields+=searchAPI[i]+' , ';
            }
        }

         for( integer i = 0 ; i < fieldsToApplyFilterOn.size() ; i++)
        {
            string field= searchAPI[i];
            string tempwhere ='';
            for(integer j = 0 ; j < searchKeywordsList.size() ; j++)
            {
                if( i == fieldsToApplyFilterOn.size() - 1 && j == searchKeywordsList.size() - 1 )
                {
                    tempwhere += fieldsToApplyFilterOn[i] +' like \'%' + String.escapeSingleQuotes( searchKeywordsList[j].trim() ) + '%\' ';
                }
                else
                {
                    tempwhere += fieldsToApplyFilterOn[i] +' like \'%' + String.escapeSingleQuotes( searchKeywordsList[j].trim() ) + '%\' AND ';    
                }
                
            }
            
            whereClause+=tempwhere; 
           
            system.debug('My fields : '+fields);
            system.debug('whereClause::'+whereClause);
        }
        
        fields+=' FROM '+ objectToQuery + ' WHERE ';
        
        if(activeProductStatus)
        {
            query = fields + whereClause;
             counter += whereClause;
            
        }
        else{
            query=fields+active+'( '+whereClause+ ' )';
            counter=counter+active+'( '+whereClause+ ' )';
        }
        
        if(!String.isBlank(color))
        {
           	/*Changes are on HOLD asked by rajneesh sir on - 19/12/2022
            query+=' And ( Color__c Like \'%'+color+'%\' )' ;
			*/
            query+=' And ( Color__c = \''+color+'\' )' ;
            counter += ' And ( Color__c = \''+color+'\' )' ;
        }
        if(!String.isBlank(pattern))
        {	
            /*Changes are on HOLD asked by rajneesh sir on - 19/12/2022
			query+=' And ( Pattern__c Like \'%'+Pattern__c+'%\' )' ;
			*/
            query+=' And ( Pattern__c = \''+pattern+'\' )' ;
            counter += ' And ( Pattern__c = \''+pattern+'\' )' ;
        }
        if(applyFilter){
            query += ' AND';
            query += whereClauseTwo;
            counter += ' AND';
            counter += whereClauseTwo;
        }
        
        system.debug('my value '+query);
        system.debug('my counter :  '+counter);
        
        try{
            
            List<Manufacturer_s_Items__c> itemsList = database.query(query);
            integer resultsCount = Database.countQuery(counter);
            for(Manufacturer_s_Items__c itr : itemsList){
                if(manufacturers.containsKey(itr.Manufacturer__c))
                {
                   manufacturers.put(itr.Manufacturer__c, new map<string,integer>{itr.Manufacturer_Name__c =>manufacturers.get(itr.Manufacturer__c).get(itr.Manufacturer_Name__c)+1});
                    
                }
                else{
                    manufacturers.put(itr.Manufacturer__c, new map<string,integer>{itr.Manufacturer_Name__c =>1});
                }
            }
            system.debug(manufacturers);
            //system.debug('recordData:: '+recordData);
            return new recordData(itemsList,manufacturers,resultsCount);
        }
        catch (Exception err) {
            system.debug(err.getMessage() +'Trace'+ err.getStackTraceString());
            if (String.isNotBlank(err.getMessage()) && err.getMessage().contains( 'error:' )) {
                throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.' +'Trace'+ err.getStackTraceString());
            } else {
                throw new AuraHandledException(err.getMessage() +'Trace'+ err.getStackTraceString());
            }
        }
    }
    Public class RecordData{
        @AuraEnabled Public List<Manufacturer_s_Items__c> itemsList {get; set;}
        @AuraEnabled Public map<String , map< String,integer >> Manufacturers  = new map<String , map< String,integer >>(); 
        @AuraEnabled Public integer resultsCount {get; set;}
        public RecordData(List<Manufacturer_s_Items__c> itemsList,map<String , map< String,integer >> manufacturers, integer resultsCount){
            this.itemsList = itemsList;
            this.Manufacturers = manufacturers;
            this.resultsCount = resultsCount;
        }
        
    }
}