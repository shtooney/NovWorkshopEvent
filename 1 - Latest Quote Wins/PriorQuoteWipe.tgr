trigger PriorQuoteWipe on Quote__c (after insert) {
    
    List<Quote__c> myQuotes = new List<Quote__c>();
    
    for(Quote__c myQuote : Trigger.New){
        Id myCurrentQuoteId = myQuote.Id;
        String myCurrentQuoteCarModel = myQuote.Model__c;
        Id myContactId = myQuote.Contact__c;
        myQuotes = [SELECT Id 
                    FROM Quote__c 
                    WHERE 
                    (Contact__c = :myContactId) 
                    AND 
                    (Model__c = :myCurrentQuoteCarModel)
                    AND
                    (Id != :myCurrentQuoteId)];                        
    }
    
    if(myQuotes.size() > 0){
        delete myQuotes;
    }
    
}
