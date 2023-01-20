({
    fetchAnnouncements : function(component, event, helper) {        
        component.set("v.displaySpinnerForMessageSentToMe",true);
        var action = component.get("c.getAnnouncementsByUser");         
        action.setCallback(this, function(response) {
            component.set("v.displaySpinnerForMessageSentToMe",false);
            var state = response.getState();
            var returnResult=  response.getReturnValue();
            console.log('returnResult == '+JSON.stringify(returnResult));
            if (state === "SUCCESS") {                 
                component.set("v.copyAnnouncementObj",returnResult);
                component.set("v.announcementObj",returnResult);
            }
            
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            } 
        });         
        $A.enqueueAction(action);
    },
    
    fetchCurrentUserReply : function(component, event, helper, currentRecordId) {        
        component.set("v.displaySpinnerForReplyModal",true);        
        var action = component.get("c.getReplyMessageOfLoggedInUser");
        action.setParams({ 
            currentRecordId : currentRecordId 
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.displaySpinnerForReplyModal",false);
            if (state === "SUCCESS") {                
                component.set("v.replyMessages",response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        
        $A.enqueueAction(action);
    },
    
    sortColumnData: function(component, event) {
        component.set("v.announcementObj",component.get("v.copyAnnouncementObj"));
        var objectList = component.get("v.announcementObj");
        var isSortAsc = component.get("v.isSortAsc");
        var sortingField = component.get("v.selectedSortingField");
        console.log('datasort to ='+sortingField);
        if(sortingField =='CreatedBy'){
            
            //const sorter1 = (a, b) => a.last_nom.toLowerCase() > b.last_nom.toLowerCase() ? 1 : -1;
            if(isSortAsc == true){
                const sorter2 = (sortBy) => (a, b) => a[sortBy].toLowerCase() > b[sortBy].toLowerCase() ? 1 : -1;
                objectList.sort(sorter2('Sender_Name__c'));
            }else{
                const sorter2 = (sortBy) => (a, b) => a[sortBy].toLowerCase() > b[sortBy].toLowerCase() ? -1 : 1;
                objectList.sort(sorter2('Sender_Name__c'));  
            }
        }else if(sortingField=='CreatedDate'){
            if(isSortAsc == true){
                const sorter2 = (sortBy) => (a, b) => new Date(a.CreatedDate) > new Date(b.CreatedDate) ? 1 : -1;
                objectList.sort(sorter2('CreatedDate'));
            }else{
                const sorter2 = (sortBy) => (a, b) => new Date(a.CreatedDate) > new Date(b.CreatedDate) ? -1 : 1;
                objectList.sort(sorter2('CreatedDate'));
            }
            
            
        }
        var obj={};
        var objlist=[];
        objlist.push(obj);
        component.set("v.announcementObj", objlist);
        component.set("v.announcementObj", objectList);
        component.set("v.showReplyMsg", '');
        console.log('isSobjectListc==11 '+JSON.stringify(objectList));
        component.set("v.isSortAsc", !isSortAsc);
        console.log('isSortAsc== '+isSortAsc);
    },
})