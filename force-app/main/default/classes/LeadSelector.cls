public class LeadSelector {

    public static List<Lead> getLeadCreatedInMonthByUser(){
        return [SELECT Id, Name 
                        FROM Lead 
                        WHERE ownerid =:userinfo.getuserid()  AND CreatedDate >= LAST_N_DAYS:30];
    }
    public static List<Lead> getLeadCreatedInYearByUser(){
        return [SELECT Id, Name 
                        FROM Lead
                        WHERE ownerid =:userinfo.getuserid()  AND CreatedDate >= LAST_N_DAYS:365];
    }
    
}