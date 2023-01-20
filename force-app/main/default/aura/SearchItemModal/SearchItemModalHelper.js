({
       setDefault : function(component,event,helper){
        component.set('v.masterData',[]);
        component.set('v.data',{});
        component.set('v.totalResults','');
        component.set('v.isTableOpen',false);
    },
    
    makeSearch : function(component,event,helper){
        component.set('v.dataLoadSpinner' , true);
        var color = component.get('v.color')
        var pattern = component.get('v.pattern')
        let searchString = component.get('v.searchQuery')        
        var action = component.get("c.fetchData");
        action.setParams({ searchKeywordsString : component.get("v.searchQuery"),
                          searchAPI : component.get('v.fieldsToBeSearch') ,
                          objectToQuery : component.get('v.objectName') ,
                          fieldsToApplyFilterOn : component.get('v.fieldsToApplyFilterOn') ,
                          activeProductStatus :component.get('v.inActivesAlso'),
                          color :component.get('v.color'),
                          pattern :component.get('v.pattern'),
                          applyFilter : component.get('v.applyFilter')
                         });
        action.setCallback(this, function(response) {
            component.set('v.dataLoadSpinner' , false); 
            debugger;
            var state = response.getState();
            if (state === "SUCCESS") {                       
                var temp = response.getReturnValue(); 
                component.set('v.isTableOpen',true);
                var manufacturersList = helper.parseManufacturers(component, temp.Manufacturers);       
                component.set('v.masterData',temp.itemsList);
                searchString=searchString+" "+color;
                searchString=searchString+" "+pattern;
                var searchList = searchString.split(' ').filter(element => element != '');
                var slicedData = temp.itemsList.slice(0,250);
                var data=helper.highlightMatchedSearchSubStrings(component,slicedData,searchList);
                component.set('v.totalResults','<strong>Total results found: </strong>'+temp.resultsCount)
                component.set('v.data',data);
                component.set('v.searchList',searchList);
                component.set('v.manufacturerList', manufacturersList);
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                        let err = errors[0].message.split('Trace');
                        console.log(err);
                        let errorObj = {'className' : "Search Item Modal - Aura",
                            'apexTrace' : err[1],
                            'exceptionMsg' :  err[0]};
            				helper.CreateExceptionLog(component,event,helper,errorObj);
                        
                    }
                } else {
                    console.log("Unknown error");
                   
                    
                }
            }
        });
        $A.enqueueAction(action);       
    },
    
 
    parseManufacturers : function(component,manufacturer){
        var manufacturerList = [];
        for (const item in manufacturer){
            for(const innerItem in manufacturer[item]){
                let temp = {};
                temp.Id = item;
                temp.Name = innerItem;
                temp.Quantity = manufacturer[item][innerItem]; 
                manufacturerList.push(temp);
            }
        }

        return manufacturerList;
    },
    
    highlightMatchedSearchSubStrings : function (component,productList,searchList){
        
        for(var i in productList)
        {
            for(var j in productList[i]) 
            {	    
                if(j !='IsActiveProduct__c' && j != 'Id'){
                    let innerData = productList[i][j].toUpperCase();
                    searchList.forEach(item => {
                        if(innerData.includes(item.toUpperCase()))
                        {
                        let newStr = '<span style="background:yellow;"><strong>'+item.toUpperCase()+'</strong></span>';
                        productList[i][j] = productList[i][j].replace(item.toUpperCase(), newStr);
                        
                    }   
                                       })
                }
            }
        }
        return productList;
    }
    
})