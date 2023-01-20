({
	doInit : function(component, event, helper) {
        component.set('v.totalCountOfObject',{});
		helper.getTotalCount(component, event, helper);
	}
})