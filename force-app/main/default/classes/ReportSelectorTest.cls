@isTest
public class ReportSelectorTest {
@isTest
    static void getReportByFolderNameTest(){
        List<Report> reports=ReportSelector.getReportByFolderName();
    }
    @isTest
    static void getReportsByNameTest(){
        List<Report> reports=ReportSelector.getReportsByName('All Account in MTD');
    }
}