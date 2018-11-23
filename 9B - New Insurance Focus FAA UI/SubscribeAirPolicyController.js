({
    init : function(component, event, helper) {
        var empApi = component.find("empApi");
        
        //Inspired off blog of Bob Buzzard - credit goes to Bob and Bob's blog
        
        // Error handler function that prints the error to the console.
        var errorHandler = function (message) {
            console.log("Received error ", message);
        }.bind(this);
        
        // Register error listener and pass in the error handler function.
        empApi.onError(errorHandler);
        
        var channel='/event/Air_Insurance_Event__e';
        var sub;
        
        // new events
        var replayId=-1;
        
        var callback = function (message, data) {
            component.find('notifLib').showToast({
                "variant": "success",
                "title": "New Plane Policy Made!",
                "message": "$" + message.data.payload.Amount__c + " mil. policy for " + message.data.payload.Who__c,
                "mode:": "sticky"
            });        
        }.bind(this);        
        
        empApi.subscribe(channel, replayId, callback).then(function(value) {
            console.log("Subscribed to channel " + channel);
            sub = value;
            component.set("v.sub", sub);
        });
    }
})
