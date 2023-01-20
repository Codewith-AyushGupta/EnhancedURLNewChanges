public class ReportSelector {
 public static List<Report> getReportByFolderName(){
        return [SELECT Name,Id,OwnerId FROM Report where FolderName=:Label.Report_for_Home];
    }
    public static List<Report> getReportsByName(String name){
       
        return [SELECT Id FROM Report WHERE Name =:name LIMIT 1];
    }
}