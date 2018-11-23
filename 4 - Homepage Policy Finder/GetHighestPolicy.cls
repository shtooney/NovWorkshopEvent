public class GetHighestPolicy {
    
    @AuraEnabled
    public static Object getOutput(String givenName){
        
        //Call on helper method that uses SOSL to figure out Contact ID
        Id contactId = getContactIdBasedOnSearch(givenName);
        
        //Get Contact Name & Address that's associated highest policy with the contact
        Contact ContactNameAndAddress = [SELECT Name, MailingAddress FROM Contact WHERE Id = :contactId LIMIT 1].get(0);
        
        String ourHolderID = [SELECT Id, Description FROM Contact WHERE Id = :contactId LIMIT 1].get(0).Description;
        
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
        
        
        for(Integer i = 0; i < outputList.size(); i++){
            
            Object o = outputList.get(i);
            Map<String, Object> castedObject = (Map<String, Object>)o;            
            
            Policy__c myPolicies = new Policy__c(
                Type__c = String.valueOf(castedObject.get('tier')), 
                Amount__c = Integer.valueOf(castedObject.get('amount')),
                ID__c = String.valueOf(castedObject.get('policyID'))
            );
            
            finalOutputList.add(myPolicies);
        }
        
        //Prepare the highest policy and output message we'll surface
        Policy__c highestPolicy = new Policy__c();
        OurMessage outputMessage;
        
        if(finalOutputList.size() > 0){
            
            Integer highestAmount = 0;
            
            for(Integer i = 0; i < finalOutputList.size(); i++){
                if(Integer.valueOf(finalOutputList.get(i).Amount__c) > highestAmount){
                    highestAmount = Integer.valueOf(finalOutputList.get(i).Amount__c);
                }
            }
            

            
            for(Integer i = 0; i < finalOutputList.size(); i++){
                if(Integer.valueOf(finalOutputList.get(i).Amount__c) == highestAmount){
                    highestPolicy.Amount__c = finalOutputList.get(i).Amount__c;
                    highestPolicy.ID__c = finalOutputList.get(i).ID__c;
                    highestPolicy.Type__c = finalOutputList.get(i).Type__c;
                }
            }
            
        }
        
        
        outputMessage = new OurMessage(highestPolicy.Type__c, 
                                    Integer.valueOf(highestPolicy.Amount__c), 
                                    highestPolicy.ID__c,
                                    ContactNameAndAddress.Name,
                                    ContactNameAndAddress.MailingAddress.getCity(),
                                    ContactNameAndAddress.MailingAddress.getState());
        
        //System.debug(outputMessage);
        
        
        return JSON.serialize(outputMessage);

    }
    
    public static Id getContactIdBasedOnSearch(String givenName){
        String firstName = givenName.substringBefore(' ');
        String lastName = givenName.substringAfter(' ');
        System.debug('first: ' + firstName + ' last: ' + lastName);
        
        String s = 'FIND\'' + givenName + '*\'IN ALL FIELDS RETURNING Contact(Id)'; 
        List<List<sObject>> myOutput = search.query(s);
        //Get list of contacts as it's a List of Lists
        List<Contact> outputContacts = myOutput.get(0);
        //Get first Contact - for assumption, you'll search for only 1 result. 
        //In real life, you may need to account for 2 "John Smith's" but we'll not worry about that here
        
        //Get the first contactID of the Contact list as the List is only 1 element (again, no such thing as 2 John Smith's)
        Id ourContactId = outputContacts.get(0).Id;        
        
        return ourContactId;
    }
    
    public class OurMessage {
        String aType;
        Integer anAmount;
        String aPolicyID;
        String aContactName;
        String aCity;
        String aState;
        
        public OurMessage(String givenType, Integer givenAmount, String givenPolicyID, String givenContactName, String givenCity, String givenState){
            aType = givenType;
            anAmount = givenAmount;
            aPolicyID = givenPolicyID;
            aContactName = givenContactName;
            aCity = givenCity;
            aState = givenState;
            
        }
        
    }
    
    
}
