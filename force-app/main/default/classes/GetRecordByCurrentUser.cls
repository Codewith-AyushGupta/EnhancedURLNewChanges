public class GetRecordByCurrentUser {
    
    public static Map<String,Integer> getRecordSize(){
        //get opportunity Record mothly And Yearly
        Map<String,Integer> mapOfRecordCreatedDateAndSize=new Map<String,Integer>();
      
       // Report opportunityInYTD = [SELECT Id FROM Report WHERE Name = 'All Opportunities in YTD' LIMIT 1];
        List<Report> opportunityInYTD = ReportSelector.getReportsByName(louisvilleTileConstants.oppYTD);
        // Running the Report
        if(opportunityInYTD.size() > 0 && opportunityInYTD[0].Id !=null){
              Reports.ReportResults resultsOpportunityInYTD = Reports.ReportManager.runReport(opportunityInYTD[0].Id, true);
        // Get the fact map from the report results
        System.debug('results ::'+resultsOpportunityInYTD);
        Reports.ReportFactWithDetails factDetailsOpportunityInYTD = (Reports.ReportFactWithDetails)resultsOpportunityInYTD.getFactMap().get('T!T');
        System.debug('factDetails ::'+factDetailsOpportunityInYTD);
        //List<String> SummaryValues=Reports.SummaryValue;
        Integer resultCountOpportunityInYTD = factDetailsOpportunityInYTD.getRows().size();
        System.debug('resultCount ::'+resultCountOpportunityInYTD);
        
        mapOfRecordCreatedDateAndSize.put('opportunityByYear',resultCountOpportunityInYTD);
        }
         
        List<Report> opportunityInMTD = ReportSelector.getReportsByName(louisvilleTileConstants.oppMTD);
        // Running the Report
        if(opportunityInMTD.size() > 0 && opportunityInMTD[0].Id !=null){
            Reports.ReportResults resultsopportunityInMTD = Reports.ReportManager.runReport(opportunityInMTD[0].Id, true);
        // Get the fact map from the report results
        System.debug('results ::'+resultsopportunityInMTD);
        Reports.ReportFactWithDetails factDetailsresultsopportunityInMTD = (Reports.ReportFactWithDetails)resultsopportunityInMTD.getFactMap().get('T!T');
        System.debug('factDetails ::'+factDetailsresultsopportunityInMTD);
        //List<String> SummaryValues=Reports.SummaryValue;
        Integer opportunityByMonth = factDetailsresultsopportunityInMTD.getRows().size();
        mapOfRecordCreatedDateAndSize.put('opportunityByMonth',opportunityByMonth);
        }
        
        
        List<Report> accountInMTD = ReportSelector.getReportsByName(louisvilleTileConstants.accountInMTD);
        // Running the Report
        if(accountInMTD.size() > 0 && accountInMTD[0].Id !=null){
             Reports.ReportResults resultsAccountInMTD = Reports.ReportManager.runReport(accountInMTD[0].Id, true);
        // Get the fact map from the report results
        System.debug('results ::'+resultsAccountInMTD);
        Reports.ReportFactWithDetails factDetailsresultsAccountInMTD= (Reports.ReportFactWithDetails)resultsAccountInMTD.getFactMap().get('T!T');
        System.debug('factDetails ::'+factDetailsresultsAccountInMTD);
        //List<String> SummaryValues=Reports.SummaryValue;
        Integer accountByMonth = factDetailsresultsAccountInMTD.getRows().size();
        mapOfRecordCreatedDateAndSize.put('accountByMonth',accountByMonth);
        }
       
        
        List<Report> accountInYTD = ReportSelector.getReportsByName(louisvilleTileConstants.accountInYTD);
        // Running the Report
        if(accountInYTD.size() > 0 && accountInYTD[0].Id !=null){
          Reports.ReportResults resultsAccountInYTD = Reports.ReportManager.runReport(accountInYTD[0].Id, true);
        // Get the fact map from the report results
        System.debug('results ::'+resultsAccountInYTD);
        Reports.ReportFactWithDetails factDetailsresultsAccountInYTD= (Reports.ReportFactWithDetails)resultsAccountInYTD.getFactMap().get('T!T');
        System.debug('factDetails ::'+factDetailsresultsAccountInYTD);
        //List<String> SummaryValues=Reports.SummaryValue;
        Integer accountByYear = factDetailsresultsAccountInYTD.getRows().size();
        mapOfRecordCreatedDateAndSize.put('accountByYear',accountByYear);  
        }
        
        
        list <Report> contactInMTD = ReportSelector.getReportsByName(louisvilleTileConstants.contactMTD);
        // Running the Report
        if(contactInMTD.size() > 0 && contactInMTD[0].Id !=null){
               Reports.ReportResults resultsContactInMTD = Reports.ReportManager.runReport(contactInMTD[0].Id, true);
        // Get the fact map from the report results
        System.debug('results ::'+resultsContactInMTD);
        Reports.ReportFactWithDetails factDetailsresultsContactInMTD= (Reports.ReportFactWithDetails)resultsContactInMTD.getFactMap().get('T!T');
        System.debug('factDetails ::'+factDetailsresultsContactInMTD);
        //List<String> SummaryValues=Reports.SummaryValue;
        Integer contactByMonth = factDetailsresultsContactInMTD.getRows().size();
        mapOfRecordCreatedDateAndSize.put('contactByMonth',contactByMonth); 
        }
    
        
        List<Report> contactInYTD = ReportSelector.getReportsByName(louisvilleTileConstants.contactYTD);
        // Running the Report
        if(contactInYTD.size() > 0 && contactInYTD[0].Id !=null){
            Reports.ReportResults resultsContactInYTD = Reports.ReportManager.runReport(contactInYTD[0].Id, true);
        // Get the fact map from the report results
        System.debug('results ::'+resultsContactInYTD);
        Reports.ReportFactWithDetails factDetailsrresultsContactInYTD= (Reports.ReportFactWithDetails)resultsContactInYTD.getFactMap().get('T!T');
        System.debug('factDetails ::'+factDetailsrresultsContactInYTD);
        //List<String> SummaryValues=Reports.SummaryValue;
        Integer contactByYear = factDetailsrresultsContactInYTD.getRows().size();
        mapOfRecordCreatedDateAndSize.put('contactByYear',contactByYear);
            
        }
        
        
        list<Report> leadInMTD = ReportSelector.getReportsByName(louisvilleTileConstants.leadMTD);
        // Running the Report
        if(leadInMTD.size() > 0 && leadInMTD[0].Id !=null){
             Reports.ReportResults resultsLeadInMTD = Reports.ReportManager.runReport(leadInMTD[0].Id, true);
        // Get the fact map from the report results
        System.debug('results ::'+resultsLeadInMTD);
        Reports.ReportFactWithDetails factDetailsresultsLeadInMTD =(Reports.ReportFactWithDetails)resultsLeadInMTD.getFactMap().get('T!T');
        System.debug('factDetails ::'+factDetailsresultsLeadInMTD);
        //List<String> SummaryValues=Reports.SummaryValue;
        Integer leadByMonth = factDetailsresultsLeadInMTD.getRows().size();
        mapOfRecordCreatedDateAndSize.put('leadByMonth',leadByMonth);
            
        }
       
        
        list<Report> leadInYTD = ReportSelector.getReportsByName(louisvilleTileConstants.leadYTD);
        // Running the Report
        if(leadInYTD.size() > 0 && leadInYTD[0].Id !=null){
          Reports.ReportResults resultsLeadInYTD = Reports.ReportManager.runReport(leadInYTD[0].Id, true);
        // Get the fact map from the report results
        System.debug('results ::'+resultsLeadInYTD);
        Reports.ReportFactWithDetails factDetailsresultsLeadInYTD= (Reports.ReportFactWithDetails)resultsLeadInYTD.getFactMap().get('T!T');
        System.debug('factDetails ::'+factDetailsresultsLeadInYTD);
        //List<String> SummaryValues=Reports.SummaryValue;
        Integer leadByYear = factDetailsresultsLeadInYTD.getRows().size();
        mapOfRecordCreatedDateAndSize.put('leadByYear',leadByYear);  
        }
        
        
        return mapOfRecordCreatedDateAndSize;
    }
}