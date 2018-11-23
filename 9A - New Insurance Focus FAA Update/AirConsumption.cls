@RestResource(urlMapping='/AirConsumption/')
global with sharing class AirConsumption {
    
    @HttpPost
    global static void reflectAirInsurance(String PolicyHolder, Integer AmountInMil) {
		
        Id myContactID = GetHighestPolicy.getContactIdBasedOnSearch(PolicyHolder);
        
        Contact myContact = [SELECT Id, Air_Insurance_Potential__c FROM Contact WHERE Id = :myContactID LIMIT 1].get(0);
        
        if(myContact.Air_Insurance_Potential__c == null){
            myContact.Air_Insurance_Potential__c = AmountInMil;
        } else {
            myContact.Air_Insurance_Potential__c = Integer.valueOf(myContact.Air_Insurance_Potential__c) + AmountInMil;            
        }

        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://external-claims-developer-edition.na59.force.com/services/apexrest/External/');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody('{' +                       
                        '"postAmount":' + AmountInMil + ',' +
                        '"postPolicyType":"' + 'Air' + '"' +                         
                        '}'
                       );        
        HttpResponse response = http.send(request);        

        update myContact;
        
        //example - here: /services/apexrest/AirConsumption/
        //{
 		// "PolicyHolder" : "Andy Young",
		//  "AmountInMil": 5
		//}
    }
    
}
