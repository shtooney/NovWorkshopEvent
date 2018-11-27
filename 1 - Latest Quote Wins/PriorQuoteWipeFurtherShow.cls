trigger PriorQuoteWipeFurtherShow on Quote__c (after insert) {
    
    //We'll use these - myQuotes to extract a list of Quotes and Set<Id> for shortcut and myQuotesNew for reflecting Quotes we'll delete
    List<Quote__c> myQuotes = new List<Quote__c>();
    List<Quote__c> myQuotesNew = new List<Quote__c>();
    Set<Id> myQuoteIds = new Set<Id>();
    
    //get all Quotes as a list
    for(Quote__c myQuote : Trigger.New){        
        myQuotes.add(myQuote);
    }    

    //Get quote ID's (see next step as this is used as a shortcut)
    for(Integer i = 0; i < myQuotes.size(); i++){
        myQuoteIds.add(myQuotes.get(i).Id);
    }
    
    //Get all Quotes that are not Quotes in scope (see "NOT IN :myQuoteIds" where Set<ID> is used)
    List<Quote__c> allOtherQuotes = [SELECT Id, Contact__c, Model__c, Rate__c FROM Quote__c WHERE Id NOT IN :myQuoteIds];
       
    //Iterate through all quotes in scope
    for(Integer i = 0; i < myQuotes.size(); i++){
		
        //While comparing each quote (of the list) in scope against the list of all other quotes
        //Upon finding a match, add the quote in scope to the new empty myQuotesList that will represent all that we'll need to delete        
        for(Integer j = 0; j < allOtherQuotes.size(); j++){
            if((myQuotes.get(i).Contact__c == allOtherQuotes.get(j).Contact__c) && 
               (myQuotes.get(i).Model__c == allOtherQuotes.get(j).Model__c)){
				myQuotesNew.add(allOtherQuotes.get(j));                
            }
        }                
    }
    
    //reflect all other quotes that are not in scope to be slated for deletion
    allOtherQuotes = myQuotesNew;    
	
	//Delete your filtered quotes        
    if(allOtherQuotes.size() > 0){
        delete allOtherQuotes;
    }
    
}
