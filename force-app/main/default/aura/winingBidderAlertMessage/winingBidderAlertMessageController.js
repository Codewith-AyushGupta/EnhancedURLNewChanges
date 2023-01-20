({
	doInit : function(component, event, helper) {
        component.set("v.winningBidderName", undefined);
        component.set("v.isShowWarningMessage", false);
		helper.getAllWinningBidders(component, event, helper);
	}
})