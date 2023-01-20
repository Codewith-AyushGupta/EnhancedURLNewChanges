@isTest
public class AccountSelectorTest {
   @isTest
    static void AccountSelectorAllTest(){
     Set<Id> accIds = new Map<Id, Account>([select id from Account LIMIT 5]).keySet();
		Map<Id,Account> mapOfAccount=AccountSelector.getAccountsByIds(accIds);
        List<Account> accounts=AccountSelector.getAccountById(accIds);
        List<Account> accounts2=AccountSelector.getAccountCreatedInYearByUser();
        List<Account> accounts3=AccountSelector.getAccountCreatedInMonthByUser();

    }
}