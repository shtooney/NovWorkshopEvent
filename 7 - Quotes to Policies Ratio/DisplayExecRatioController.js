({
	myAction : function(component, event, helper) {
        var action = component.get("c.provideOutput");
        action.setParams({
            "myContactID": component.get("v.recordId")
        });
        action.setCallback(this, function(data) {
            component.set("v.myRatio", data.getReturnValue());
        });
        $A.enqueueAction(action);
	}
})
