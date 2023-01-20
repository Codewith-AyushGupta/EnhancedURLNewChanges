global class TestWrapper {
    
    public List<KerridgeOrder> kerridgeOrders {get;set;}
    
    public class KerridgeOrder {
        public String orderName{get;set;}
        public Integer kerridgeQuote{get;set;}
        public DateTime dateCreatedInKerridge{get;set;}
        public Date orderStartDate{get;set;}
    }

}