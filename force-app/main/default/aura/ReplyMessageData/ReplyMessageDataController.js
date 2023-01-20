({
	doInit : function(component, event, helper) {
		helper.fetchAnnouncements(component, event, helper);
	},
    
    handleSorting: function (component, event, helper) {
          component.set("v.isSortFirstTime", false);
         
        var selectedItem = event.currentTarget;
         console.log('selectedItem == '+selectedItem);
        var selectedField = selectedItem.dataset.record;
         console.log('selectedField == '+selectedField);
         
        component.set("v.isSortByDate", false);
        component.set("v.isSortByName", false);
        component.set("v.selectedSortingField", selectedField);
         
        if(selectedField == 'UserName'){
            component.set("v.isSortByName", true);
        }else{
            component.set("v.isSortByDate", true);
        }
        helper.sortColumnData(component, event);
    },
    
    
    
     
    
    openReplyModal:function (component, event, helper){
        var currentRecordId=event.target.getAttribute("data-recId");
        helper.getReplyMessageData(component, event, helper,currentRecordId);
    },
    
    openModel: function(component, event, helper) {
      // Set isModalOpen attribute to true
      component.set("v.isModalOpen", true);
   },
  
   closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
   },
  
   submitDetails: function(component, event, helper) {
     
      component.set("v.isModalOpen", false);
   },
     
})