({
    doInit : function(component, event, helper) {
        var announcementObj = component.get("v.announcementObj");        
        
        if($A.util.isUndefinedOrNull(announcementObj)){
            var obj = {};			           
            component.set("v.announcementObj", obj); 
            component.set("v.announcementObjForReply",obj);
        }
        
        
    },
    
    openModal: function(component, event, helper){
        component.set("v.showModal", true);
        component.set("v.showReplyModal", false);
        
    },
    
    hideModel: function(component, event, helper){
        component.set("v.showModal", false);
        component.set("v.announcementObj", {});  
        component.set("v.selectedUser",'');
         component.set("v.selectedUserId",'');
    },
    
    submitDetails : function(component, event, helper){
        var usersData=component.get("v.user");
        console.log('usersData---'+usersData);
        var usersNameStr=component.get("v.selectedUserString");
        console.log('usersNameStr---'+usersNameStr);
        var usersName=[];
        for(var i=0;i<usersData.length;i++){
            usersName.push(usersData[i].label);
        }
        
        component.set("v.selectedUser",usersName);
        var isValid=true;
        if(!component.get("v.announcementObj.Message__c")){
            component.set("v.validity", false);
        }
        else{
            component.set("v.validity", true);
        }
        
        var selectedUser = component.get("v.selectedUser");
        console.log('selectedUser name===>>'+selectedUser);
        var isValidUser = true;
        if(selectedUser == undefined || selectedUser == ''){
            var customLookup = component.find("customLookupForUser");
            isValidUser = customLookup.validateLookup();
            console.log(isValidUser); 
            
        }
        
        //console.log('allDetailsValid  '+validField.get('v.value'));
        //  console.log('fieldValue  '+fieldValue);
        if(component.get("v.announcementObj.Message__c") && isValidUser==true){
            helper.submitDetailsHelper(component, event, helper);            
        }
        
    },
     
    itemsChange : function(component,event,helper){
        debugger;
        var selectedUser = component.get("v.selectedUser");
       // var selectedUserId = component.get("v.selectedUserId");
       // selectedUserId.push(selectedUser);
       // component.set('v.selectedUserId',selectedUserId);
        console.log('user Name '+selectedUser);
        var announcementObj = component.get("v.announcementObj");  
        //announcementObj.Receiver__c = selectedUser;
        // console.log('selected User name '+JSON.stringify(announcementObj));
        // component.set("v.announcementObj",announcementObj);
    },
    
    handleKeyMessage :function(component,event,helper){
        var childComponent = component.find('customLookupForUserone');
        //alert("message---"+childComponent);
        var isTrue = event.getParam("modalValueTrue");
        var recordIdOfKeyMessage=event.getParam("currentRecordId");
        component.set("v.recordId",recordIdOfKeyMessage);
       //alert(recordIdOfKeyMessage);
        helper.getKeyReportUserName(component,event,helper,recordIdOfKeyMessage); 
    },
    hideReplyModel:function(component,event,helper){
        component.set("v.showReplyModal", false);
    },
    submitReplyDetails:function(component,event,helper){
        component.set("v.showReplyModal", false);
        component.set("v.showModal", false);
        component.set("v.showKeyMessage", false);
        component.set("v.showReplyKeyMessage", true);
        helper.submitDetailsReplyHelper(component, event, helper);            
    },
    
    openMyMessage:function(component,event,helper){
        component.set("v.showData",false);
        component.set("v.showButton",false);
    },
    previous:function(component,event,helper){
        component.set("v.showButton",true);
        component.set("v.showData",true);
    },
    
    /***
     * This method will be used to handle the toggle change
     * if true is selected then we shoukd display the message sent to me
     * if false is selected then we should display message sent by me
     ***/
    handleToggleChange : function(component,event,helper){
    	debugger;
        var isChecked = component.find('messageTypeToggle').get('v.checked');
        if(isChecked){
            component.set("v.showData",true);            
        }
        else{            
            component.set("v.showData",false);
        }
	}
})