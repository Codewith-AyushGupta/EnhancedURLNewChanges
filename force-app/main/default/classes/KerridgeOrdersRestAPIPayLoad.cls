public class KerridgeOrdersRestAPIPayLoad {
    public List<KerridgeOrders> kerridgeOrders;
    
    public class KerridgeOrders {
        public String orderName;
        public Integer kerridgeQuote;
        public Integer kerridgeAccount;
        public String status;
        public datetime dateCreatedInKerridge;
        public String description;
        public date orderStartDate;
        public String orderExternalId;
    }
    
    public List<KerridgeOrdersLine> kerridgeOrdersLine;
    
    public class KerridgeOrdersLine {
        public String kerridgeOrderLineName;
        public String kerridgeOrder;
        public Date lineShipDate;
        public Double listPrice;
        public String productName;
        public Integer quantity;
        public Double TotalPrice;
        public String orderExternalId;
        public String orderLineExternalId;
    }
    
    public List<KerridgeQuote> kerridgeQuote;
    
    public class KerridgeQuote {
        public String kerridgeQuoteName;
        public datetime dateCreatedInCqm;
        public datetime dateLastModifiedInCqm;
        public Integer kerridgeQuoteNumber;
        public Integer sequenceToShowMultipleQuotes;
        public String quoteExternalId;
    }
    
    public List<KerridgeQuotesLine> kerridgeQuotesLine;

	public class KerridgeQuotesLine {
		public String kerridgeQuoteLineName;
		public String lineItemDescription;
		public Double listPrice;
		public String productName;
		public Integer quantity;
		public String quote;    //Integer
		public String quoteExternalId;
		public String quoteLineExternalId;
	}

    public List<SelectionSheet> selectionSheet;

	public class SelectionSheet {
		public String name;
        public String SalesforceId;
		public String selectId;
		public date dateLastModifiedInSSM;
		public date dateCreatedInSSM;
		public String uom;
		public String status;
		public String quantity;
		public String productName;
		public String ssLineNumber;
		public String ssmCustId;
	}

    public static KerridgeOrdersRestAPIPayLoad parse(String json) {
        return (KerridgeOrdersRestAPIPayLoad) System.JSON.deserialize(json, KerridgeOrdersRestAPIPayLoad.class);
    }
}