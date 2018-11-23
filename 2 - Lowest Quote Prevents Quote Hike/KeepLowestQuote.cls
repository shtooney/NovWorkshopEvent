trigger KeepLowestQuote on Quote__c (before insert) {
    
    List<Quote__c> myQuotes = new List<Quote__c>();
    
    for(Quote__c myQuote : Trigger.New){
        Integer myCurrentQuoteRate = Integer.valueOf(myQuote.Rate__c);
        String myCurrentQuoteCarModel = myQuote.Model__c;
        Id myContactId = myQuote.Contact__c;
        myQuotes = [SELECT Id, Rate__c 
                    FROM Quote__c 
                    WHERE 
                    (Contact__c = :myContactId) 
                    AND 
                    (Model__c = :myCurrentQuoteCarModel)
                    AND
                    (Rate__c < :myCurrentQuoteRate)];      
        
        
        if(myQuotes.size() > 0){
            myQuote.adderror('You already sent a quote to this person for the same car model but lower quote amount of $' + myQuotes.get(0).Rate__c + '/mo. Please honor that, as it is our policy!');
        }
        
    }
    
    
    
}
