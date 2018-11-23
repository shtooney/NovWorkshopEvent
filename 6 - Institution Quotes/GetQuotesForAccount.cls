public class GetQuotesForAccount {
    
    @AuraEnabled
    public static List<Quote__c> getQuotes(Id myAccountId){
        List<Quote__c> ourQuotes = new List<Quote__c>();
        
        //Get all the Contacts for this Account
        List<Contact> myContacts = [SELECT Id FROM Contact WHERE AccountId = :myAccountId];
        
        //Get all the Quotes for Contacts (for this Account)
        List<Quote__c> myQuotes = [SELECT Id, Rate__c, Model__c, Quote_Recipient__c FROM Quote__c WHERE Contact__c IN :myContacts];
        
        System.debug(myQuotes);
        
        return myQuotes;
    }

}
