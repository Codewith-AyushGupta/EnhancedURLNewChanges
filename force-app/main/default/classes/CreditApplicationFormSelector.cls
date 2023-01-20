public class CreditApplicationFormSelector {
    
    /***
* this method return the list of fields name
*/ 
    public static List<String> getFields(){
        return new List<String> {
            'Contact__c',
                'Name',
                'Terms_And_Condition_Accepted_By__c',
                'Account_Number__c',
                'Address_Line_1__c',
                'Billing_Address_Line1__c',
                'Annual_Sales__c','Any__c','Are_Accounts_Receivable__c',
                'BRANCH__c',
                'Branch_Address__c',
                'Business_Information__c',
                'Business_Location_is_Please_Select__c',
                'Previous_Emp_Business_Name__c',
                'City__c','Billing_City__c',
                'Guarantor_City__c',
                'Company_Telephone__c',
                'Previous_Emp_Contact_Name__c',
                'Contact_Name__c',
                'Primary_Contact_Credit_Limit_Requested__c',
                'CUSTOMER_TYPE__c',
                'Date__c',
                'Agreement_Date__c',
                'Terms_And_Condition_Date__c',
                'Date_Business_Commenced__c',
                'Date_Established__c',
                'DBA_or_Trade_Name__c','Delivery_Charge__c','Bank_E_mail_Address__c',
                'Primary_Account_Email__c','Previous_Emp_Email__c',
                'Primary_Contact_Email__c','Fax__c','Bank_Fax_Number__c',
                'Terms_And_Condition_Firm__c','Guarantor_Name__c',
                'Has_Application__c','Guarantor_Home_Address__c',
                'Guarantor_Home_Phone_Number__c',
                'In_consideration_of_the_Extension_to__c',
                'Legal_Company_Name__c','Primary_Contact_Name__c',
                'Primary_Account_Name__c','Name_of_Authorized_Officer__c',
                'Primary_Contact_Phone__c',
                'Pledge_accounts_receivable__c',
                'Guarantor_Position__c','Primary_Account_Method_Of_Invoice__c',
                'Presently_registered__c','PRICE_CODE__c','Principal_Bank__c',
                'SALESMAN__c','Ship_VIA__c',
                'State__c','Billing_State__c',
                'guarantor_State__c','Stop__c','Tax_ID__c',
                'Primary_Account_Telephone__c','Previous_Emp_Telephone__c',
                'Bank_Telephone_Number__c','Title_Agreement__c',
                'Truck_Route__c','Type_of_Buisness__c',
                'Primary_Contact_Web_Add__c','Zip_Code__c',
                'Day_Of__c','Month__c','Year__c',
                'Billing_Zip_Code__c','Guarantor_Zip_Code__c',
                'Completed_Step__c',
                'Indicate_reason_for_exemption__c',
                'Sales_Tax_Exemption_Number__c',
                'SSNnumber__c','Financials__c','Describe__c',
                'Other_Describe__c','Application_Status__c',
                'Term_and_Conditions_of_Sales_App__c',
                'Submitted_Date__c',
                'Application_Sent_By__c',
                'Recommended_Credit_Limit__c',
                'Contact_Name_For_Credit__c',
                'Credit_manager_Comments__c',
                'Warehouse__c','Form_URL__c'
                };
                    }
    
    /***
* This method return the list of Credit application form records where contacts id matched
*/ 
    public static List<Credit_Application_Form__c> getCreditApplications(Set<Id> ContactIds){
        String query = 'SELECT Id, '+ String.join(getFields(), ',') + ' FROM Credit_Application_Form__c';
        query += ' WHERE Contact__c IN :ContactIds';
        
        return database.query(query);
    }
    
    /***
* This method return the list of Credit application form records where ids matched
*/ 
    public static List<Credit_Application_Form__c> getCreditApplicationsByIds(Set<Id> applicationsIds){
        String query = 'SELECT Id, '+ String.join(getFields(), ',') + ' FROM Credit_Application_Form__c';
        query += ' WHERE Id IN :applicationsIds';
        
        return database.query(query);
    }
    
    
    public static Map<String, ContentDocumentLink> getContentDocumentLinks(Id parentId){
        List<ContentDocumentLink> lstContentDocumentLinks = [Select Id, 
                                                             ContentDocument.title,
                                                             ContentDocumentId
                                                             From ContentDocumentLink 
                                                             Where LinkedEntityId =: parentId];
        
        Map<String, ContentDocumentLink> mapTitleVsConDocLink = new Map<String, ContentDocumentLink>();
        
        for(ContentDocumentLink conDocLink : lstContentDocumentLinks){
            mapTitleVsConDocLink.put(conDocLink.ContentDocument.title, conDocLink);
        }
        
        return mapTitleVsConDocLink;
    }
   public static List<Credit_Application_Form__c> getCreditApplicationsData(Set<Id> ContactIds){
        List<Credit_Application_Form__c> lstCreditApplicationForm=[Select Id,Name,Application_Status__c,Contact__c from Credit_Application_Form__c where Contact__c IN :ContactIds AND (Application_Status__c='In Progress' OR Application_Status__c='Opened By Customer')];
        
        return lstCreditApplicationForm;
    } 
}