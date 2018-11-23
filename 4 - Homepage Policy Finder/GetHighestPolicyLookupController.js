({
	handleFromOutside : function(component, event, helper) {
        var action = component.get("c.getOutput");
        action.setParams({
            "givenName" : component.get("v.givenName")
        });
        
        action.setCallback(this, function(data) {
            component.set("v.Output", JSON.parse( data.getReturnValue() ));
        });
        
        component.set("v.showMe",true);                        
        $A.enqueueAction(action);
        
	}    
})
