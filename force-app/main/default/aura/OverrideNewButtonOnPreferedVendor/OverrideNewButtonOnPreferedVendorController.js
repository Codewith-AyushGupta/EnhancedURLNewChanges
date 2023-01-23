({
   openModel: function(component, event, helper) {
      component.set("v.isModalOpen", true);
   },
  
   closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
   },
    
    doInit : function(component, event, helper){
        var lable = $A.get("$Label.c.Preferred_Vendor_RPF_link");
        component.set("v.preferredVendorLink", lable);
        
    }
  
})