# Index & Use-Case Stories

## ----------------Index----------------

**Scenario 1:** Latest Quote Wins. **Type:** Apex

* PriorQuoteWipe.tgr

**Scenario 2:** Lowest Quote Prevents Quote Hike. **Type:** Apex

* KeepLowestQuote.tgr

**Scenario 3:** Retrieve Customer Policies. **Type:** Lightning Components + Apex + API’s

* GetPolicies.cmp & GetPoliciesController.js

* GetPolicy.cls

**Scenario 4:** Homepage Policy Finder. **Type:** Lightning Components + Apex + API’s

* GetHighestPolicyLookup.cmp & GetHighestPolicyLookupController.js

* GetHighestPolicy.cls

**Scenario 5:** Customer Tier Progress. **Type:** Lightning Components

* TierProgress.cmp

**Scenario 6:** Institution Quotes. **Type:** Lightning Components + Apex

* QuotesForInstitution.cmp & QuotesForInstitutionController.js

* GetQuotesForAccount.cls

**Scenario 7:** Quotes to Policies Ratio **Type:** Lightning Components + Apex + API’s

* DisplayExecRatio.cmp & DisplayExecRatioController.js

* GetExecRatio.cls

**Scenario 8:** New Insurance Focus **Type:** Apex + API’s

* AirConsumption.cls

**Scenario 9A:** New Insurance Focus FAA Update **Type:** Apex + API’s

* AirConsumption.cls

**Scenario 9B:** New Insurance Focus FAA UI **Type:** Lightning Components + Apex + API’s

* SubscribeAirPolicy.cmp & SubscribeAirPolicyController.js

* AirConsumption.cls


## ----------------Scenarios----------------

### Scenario 1: Latest Quote Wins. Type: Apex

**Story:** You’re an agent going into Salesforce. In the interface, you’re generating a quote for a customer (contact) for a particular car model. However, a friendly reminder: there are other quotes that were generated for this car model for this customer. To make the best experience possible, please create code that deletes any existing quotes generated in the past for this car model (as they are now outdated/expired/etc and you want your end users to not be confused by those quotes). That way, the latest quote you generate for the car model will wipe out other existing ones as they are now irrelevant.

* **Important Note:** This has to be done with a after-insert trigger only

### Scenario 2: Lowest Quote Prevents Quote Hike. Type: Apex

**Story:** You’re an agent going into Salesforce. In the interface, you’re generating a quote for a customer (contact) for a particular car model. However, a friendly reminder: there are other quotes that were generated for this car model for this customer - and we never want an agent to upset the customer by giving a higher insurance monthly quote than one they already made before for the same model. To make the best experience possible, please create code that prevents a creation of a quote if there is an existing quote out there that is for the same car model but happens to be lower (since we want to keep the the low one to keep customers happy)

* **Important Note:** This has to be done with a before-insert trigger only

### Scenario 3: Retrieve Customer Policies. Type: Lightning Components + Apex + API’s

**Story:** You’re an agent going into Salesforce. You’re looking at a customer and you want to know what kind of policies they have with you. Policies are stored in another system. So you’ll need to make a custom front-end surfaces them and a custom backend that fetches out and gets them

* **Important Note:** (1) Please register the Policies web service as a Remote Site Setting by going to Setup >> Security >> Remote Site Settings >> Name = InsureSystem, URL = https://gist.githubusercontent.com - and click Save (2) Have your server-side Apex code generate a List<Policy__c> in memory to pass to front-end Lightning Component (3) Use Contact’s Description field as where you plot policy holder ID (such as HOLDER-123, HOLDER-456, or HOLDER-789)

### Scenario 4: Homepage Policy Finder. Type: Lightning Components + Apex + API’s

**Story:** You’re an agent going into Salesforce. Your home page is your lifeblood, you don’t have time to go into each contact and look at their policies. You get a phone call from a client and you immediately want to find out what is their highest policy they pay (and for what) as well as where they are located to ensure you’re licensed to sell in their location (based on their City/State). To be as relevant as possible, you want a simple input form on your homepage where you enter their first and last name and their highest policy pops up as well as their address (note that in real life, you can have telephony integration with pop-ups of that - as well as regex rules you can use too, but we’ll keep it simple). You, on the Home Page tab, have to code one field that requires precise first and last name to be entered and the outcome is a policy (fetched from another system) as well as City/State (that came from the Contact field). To take advantage of the search engine we have running on Apache Solr, you you’ll executive dynamic SOSL (think like SOQL but for using our search language) - see instructions here. If you’re having a difficulty after 7 mins, please ask the instructor for assistance - or if you wish, do a SOQL search on matching first+last names. DON’T get diminished returns, raise your hand, we’ll fix any nuance you got stuck at. Further SOSL tips can be found here.

* **Important Note:** (1) Please register the Policies web service as a Remote Site Setting by going to Setup >> Security >> Remote Site Settings >> Name = InsureSystem, URL = https://gist.githubusercontent.com (2) Note that this well help you process Addresses as it’s an Address class

* **Optional Bonus Challenge:** (A) you can change the Data Table in Scenario 3 to have sorting capability to get highest policy (i.e., Agent clicks on Contact and then sorts based on Policies given). (B) Or you can implement regex in your input form

### Scenario 5: Customer Tier Progress. Type: Lightning Components

**Story:** Agents are busy people, especially those that have a lot of customers. They need visual cues because they are talking to so many people - so often they need a quick graphic that stands out to them rather than seeing everything in text. One of those cues is a graphic that displays the customer’s level (i.e., bronze, silver, gold, etc) that they would like in a graphic so that they can see where customer is at and immediately focus on progressing the customer to the next level (i.e., finding new policies to sell and etc). Please generate code that shows progress bar based on customer (Contact) field called “Level” (Level__c). If the customer has no level, treat it as the lowest level (0%), Tertiary level = treat it as 33%, Secondary = 66%, Primary = 100%. Remember, Google is your friend, and you can reuse Lightning Design System capabilities like those that show progress (hint hint). 

* **Important Note:** Write this code without writing any Apex and without writing JavaScript. Use Lightning Data Service to get this accomplished - see example here (note the example has a syntax error, please insert layoutType="FULL" between lines 7 & 8 of ldsLoad.cmp file if you’re going to utilize it or imitate it.

### Scenario 6: Institution Quotes. Type: Lightning Components + Apex

**Story:** Agencies also work with institutions/businesses (B2B relationships) and not just with individual customers (aka B2C). Agents can easily look up the related customers (Contacts) who roll up to an institution (Accounts). But when they go to an institution within Salesforce, they would like to look to see all the insurance quotes that were generated against it and to whom within the institution - that way they are more-relevant when they speak to an institution as they have a holistic sense. Please generate a Lightning Component on an Account record that looks at all Contacts that belong to that Account and scrapes all the quotes they got and presents the quotes and contact names they were issued to in the component on the Account record
**Important Note:** (1) AccountId is your friend - it lives on Contact object (2) As you generate Quote__c object in memory, utilize a formula field that already exists on it called “Quote_Recipient__c” → it eliminates unnecessary minutia you’d have to code for otherwise (as Quote Contact is technically an Id field, not a text field). If you don’t understand why, it’s okay, either ask us or just take it this way: out-of-the-box formula fields provide shortcuts when you code in Apex, you never need to expose them to the end user-either - these just productivity boosters, that’s it (3) Raise your hand if you have too many line items as your output (i.e., more than 7), -- while it won’t be imporant for this exersize, in practice you’ll need to make pagination (or the like) so someone can flip through rather than scrolling through a long list. If your list is too long, just cap it off (i.e., list.size < 7 or SOQL’s “LIMIT 7” clause)

### Scenario 7: Quotes to Policies Ratio Type: Lightning Components + Apex + API’s

**Story:** An Executive of an agency wants to hover a Contact and quickly see the potential their agent has. A way of doing that is a rule of thumb the agent uses: ratio comprised of total $ amount quotes (for that contact) vs total $ amount of policies for that contact. An example is of it is: “$400 / $980” - the actual ratio itself isn’t that valuable but what is valuable is the quick display, it’s one this executive and other executives of agencies use in the industry. The executives, upon seeing that ratio, doesn’t care to look anywhere else as they got all they needed. Since execs don’t have time since they are busy doing exec things, we need to generate a component that looks up Contact’s policies (that exist elsewhere) and Quotes against that contact (in Salesforce) and spits out this string.

* Important Note: (1) Please register the Policies web service as a Remote Site Setting by going to Setup >> Security >> Remote Site Settings >> Name = InsureSystem, URL = https://gist.githubusercontent.com - and click Save (2) Have your server-side Apex code generate a String (like “$400 / $980”) in memory to pass to front-end Lightning Component (3) Use Contact’s Description field as where you plot policy holder ID (such as HOLDER-123, HOLDER-456, or HOLDER-789)

### Scenario 8: New Insurance Focus Type: Apex + API’s

**Story:** Whenever a new type of policy is introduced, agents want to go “all hands on deck” on it to make sure they are able to market & sell this hot new financial instrument. Lately, private plane insurance has been launched as you bought out an insurance company (now your subsidiary) who does that. Plane insurance a very expensive instrument as policies range in millions on it. Because you just recently completed the merger of your subsidiary, your goal will be for subsidiary to feed you the relevant data. Reason for that is in the past, an Agent would go to Salesforce for everything but go to the plane insurance company platform to enter data. Now that everything is one place, Salesforce will house all of this over the course of time, but for short term (as you complete your merger), there will be a field agents will see under Contacts called “Air Insurance Potential” - which shows how much has already been discussed. That way, for those agents that are still slow to adopt and go to multiple places, the data is synchronized in a relevant way. Please code an Apex REST Service that takes a POST’ed web service which includes plane policy holder name (i.e., Andy Young) as well as the amount (already in $ millions), finds the Contact (using SOSL), and updates the contact’s Air_Insurance_Potential__c field incrementally each time an amount comes in (i.e., a POST of $12m and a POST of $4M = $16M for Air_Insurance_Potential__c). 

* **Important Note:** To generate an incoming POST, you’ll go to Workbench >> login >> go to top-right >> Utilities >> REST Explorer >> you’ll choose a POST under radio buttons >> your header string will be /services/apexrest/AirConsumption/ >> your JSON body will be as follows (example) as you hit the Execute button:

---------- {

---------- "PolicyHolder" : "Andy Young",

---------- "AmountInMil": 5

---------- }

## ---------- Proceed IF time allows ----------

### Scenario 9A: New Insurance Focus FAA update Type: Apex + API’s

**Prerequisite:** Must complete Scenario 8, as we’ll build off it and modify it

**Story:** Lastly, airlines need to know about this policy potential as part of FAA regulation, so upon receiving a real time feed (that you accomplished in Scenario 9), Salesforce would also need to send an update to an airline system. Upon processing the web service, you’ll write a POST in your existing Apex REST Service to send a POST to the FAA-based Airline Web Service with the Policy Type (which you’ll hard-code as “Air”) and Policy Amount (which is what you got, in millions) - you’ll post it here: link.

* **Important Note:** (1) Please register the FAA-based Airline Web service as a Remote Site Setting by going to Setup >> Security >> Remote Site Settings >> Name = AirSystem, URL = https://external-claims-developer-edition.na59.force.com (2) When creating the POST, please follow these parameters:

---------- Endpoint: https://external-claims-developer-edition.na59.force.com/services/apexrest/External/

---------- Header = request.setHeader('Content-Type', 'application/json;charset=UTF-8');

---------- Body = 

---------- {

----------   "postAmount" : "24",

----------   "postPolicyType": "Air"

---------- }


# Scenario 9B: New Insurance Focus FAA update Type: Lightning Components + Apex + API’s

**Prerequisite:** Must complete off scenario 8, as we’ll build off it and modify it

**Part 1:** Draw out & Explain how you can do Scenarios 9A & 9B with Platform Events

**Part 2:** Provide a real-time UI update on the home page to alert end users of the vital information that came via the POST’d web service

