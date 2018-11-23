public class GetExecRatio {
    
    @AuraEnabled
    public static String provideOutput(Id myContactID){
        
        String ourHolderID = [SELECT Id, Description FROM Contact WHERE Id = :myContactID LIMIT 1].get(0).Description;
        
        //Get all the Quote rates for this Contact
        List<Quote__c> myQuotes = [SELECT Rate__c FROM Quote__c WHERE Contact__c = :myContactID];
        Integer quoteTotals = 0;
        for(Integer i = 0; i < myQuotes.size(); i++){            
            quoteTotals = quoteTotals + Integer.valueOf(myQuotes.get(i).Rate__c);
        }
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://gist.githubusercontent.com/russboston/9c339c1b8108392e12ee368611e41791/raw/ecb851b13ef68e64417a77ef72d440012e93eb8e/policies.json');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        Map<String, Object> ourPolicyHolderPolicies;
        List<Object> outputList;
        List<Policy__c> finalOutputList = new List<Policy__c>();
        if (response.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types.
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());            
            
            //Filter to policies for Policy holder in scope
            ourPolicyHolderPolicies = (Map<String, Object>)results.get(ourHolderID);
            
            outputList = ourPolicyHolderPolicies.values();
            
        }
        
        Integer policyTotals = 0;
        
        for(Integer i = 0; i < outputList.size(); i++){            
            Object o = outputList.get(i);
            Map<String, Object> castedObject = (Map<String, Object>)o;                        
			policyTotals = policyTotals + Integer.valueOf(castedObject.get('amount'));
        }
        
        
        String ratioOutput = '$' + quoteTotals + ' / $' + policyTotals;
        
        System.debug(ratioOutput);
        
        return ratioOutput;
    }
    
}
