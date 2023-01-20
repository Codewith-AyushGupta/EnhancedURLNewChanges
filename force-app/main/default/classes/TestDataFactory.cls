@isTest
public class TestDataFactory {
    
    public static Credit_Application_Form__c getCreditAppFormInstance(){
        return new Credit_Application_Form__c(
            BRANCH__c='Test Account',
            Terms_And_Condition_Accepted_By__c='Ank',
            Billing_Address_Line1__c='Noida-62',
            Guarantor_Home_Phone_Number__c='(123)-456-7890',
            In_consideration_of_the_Extension_to__c='test pvt ltd',
            Annual_Sales__c=2132434545,
            Primary_Account_Email__c='ankita1@gmail.com',
            Primary_Account_Method_Of_Invoice__c='Paper',
            Billing_Zip_Code__c='12345',
            Legal_Company_Name__c='Legal Company Private Limited',
            DBA_or_Trade_Name__c='Dba',
            Guarantor_City__c='Ghaziabad',
            Contact_Name__c='Ank Pthk',
            Previous_Emp_Business_Name__c='Aditi',
            Branch_Address__c='State Bank Of Pakistan',
            PRICE_CODE__c='code123',
            Stop__c='stop',
            Ship_VIA__c='ship via',
            Application_Status__c = CreditApplicationContstants.Application_Status_Sent_To_Customer
        );
    }
    
    public static Guarantor__c getGuarantorInstance(){
        return new Guarantor__c(
            Name='Ank',
            Guarantor_Date__c=date.newInstance(2021,7,15),
            Spouse_Date__c=date.newInstance(2021,8,20),
            Spouse_s_Name__c='Pthk',
            Guarantor_Email__c='ank@test.com',
            Spouse_Email__c='pthk@gmail.com'
        );
    }
    
    
    public static Trade_Reference__c getTradeReferenceInstance(){
        return new Trade_Reference__c(
            Name='Kumar',
            TradeRaf_Account__c='123488766',
            TradeRef_Address__c='Noida Park',
            TradeRef_City__c='Los Angeles',
            TradeRef_Contact_Name__c='Mishra',
            TradeRef_Fax__c='(098) 765-4321',
            TradeRef_Telephone__c='(098)888-4321',
            TradeRef_Zip_Code__c='12345',
            State__c='Georgia',
            TradeRef_Email__c='arna@test.com'
        );
    }
    
    
    public static Credit_Application_Principal__c getCreditApplicationPrincipalInstance(){
        return new Credit_Application_Principal__c(
            Name='Arna',
            Home_Address__c='A-552 South Delhi',
            Home_Phone__c='(123)-456-8899',
            Position__c='CFO',
            State__c='Connecticut',
            Zip_code__c='98675',
            City__c='Chicago'
        );
    }
    
    
    public static Contact getContactInstance(){
        return new Contact(
            FirstName='Ank',
            LastName='Pthk',
            Email='kumar@gmail.com'
        );
    }
}