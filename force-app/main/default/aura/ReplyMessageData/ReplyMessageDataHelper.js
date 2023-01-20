({
    fetchAnnouncements : function(component, event, helper) {
        component.set("v.displaySpinnerForMessageSentByMe",true);
        
        var action = component.get("c.getMessages"); 
        action.setCallback(this, function(response) {
            component.set("v.displaySpinnerForMessageSentByMe",false);
            var state = response.getState();
            var returnResult=  response.getReturnValue();
            console.log('-----'+JSON.stringify(returnResult.Reply_Messages__r));
            console.log('returnResult == '+JSON.stringify(returnResult));
            if (state === "SUCCESS") { 
                
                var rows = response.getReturnValue();
                for ( var i = 0; i < rows.length; i++ ) {
                   
                    var row = rows[i];
                   var replys=row.Reply_Messages__r;
                    //alert(JSON.stringify(row));
                    if (  replys != undefined && replys.length > 0 ) {
                        for ( var k = 0; k < replys.length; k++ ) {
                           var reply=replys[k];
                        //alert(JSON.stringify(reply));
                        if(reply.User__r){
                            var User=reply.User__r;
                          row.UserName=User.FirstName;  
                        } 
                            
                        }
                        
                    }else{
                        row.UserName='zzz'; 
                    }
                }
                                      

                component.set("v.copyAnnouncementObj",rows);
                component.set("v.announcementObj",rows);
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
    
    getReplyMessageData:function(component, event, helper,currentRecordId){       	
        component.set("v.displaySpinnerForReplyModal",true);
        component.set("v.isModalOpen",true);
        var action = component.get("c.getReplyMessage");
        action.setParams({ 
            currentRecordId : currentRecordId 
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('replyMessages =----------->'+JSON.stringify(response.getReturnValue()));
            var result=response.getReturnValue();
                        console.log('resultSize =----------->'+result.length);

           
            component.set("v.displaySpinnerForReplyModal",false);
            if (state === "SUCCESS") {                
                component.set("v.replyMessages",response.getReturnValue());
                console.log('replyMessages =----------->'+JSON.stringify(response.getReturnValue()));
                 if(result.length==0){
                 helper.getReplyMessageData2(component, event, helper, currentRecordId);
            }
                
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
         if(sortingField == 'UserName'){
            
            //const sorter1 = (a, b) => a.last_nom.toLowerCase() > b.last_nom.toLowerCase() ? 1 : -1;
             if(isSortAsc == true){
                const sorter2 = (sortBy) => (a, b) => a[sortBy].toLowerCase() > b[sortBy].toLowerCase() ? 1 : -1;
                objectList.sort(sorter2('UserName'));
            }else{
                const sorter2 = (sortBy) => (a, b) => a[sortBy].toLowerCase() > b[sortBy].toLowerCase() ? -1 : 1;
                objectList.sort(sorter2('UserName'));  
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
    
    getReplyMessageData2:function(component, event, helper, currentRecordId){ 
     
          var recordIds=[];
        recordIds.push(currentRecordId);
    var action = component.get("c.getUserNameOfKeyMessage");
       
        //alert(recordIds);
        action.setParams({ 
            keyMessageRecordId : recordIds 
        });
        action.setCallback(this, function(response) {
             
            var state = response.getState();
           
            console.log('MainMessage =----------->'+JSON.stringify(response.getReturnValue()));
            var result=response.getReturnValue();
           
            if (state === "SUCCESS") {                
                component.set("v.mainMessages",response.getReturnValue());
                
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
})