namespace Tutorials.Models
{
    public class Employee
    {
        public int SponsorID { get; set; }
        public string SponsorName { get; set; }
        public decimal TotalPayments { get; set; }
        public int NumberOfPayments { get; set; }
        public DateTime? LatestPaymentDate { get; set; }
    }

    public class MatchPaymentSummary
    {
        public int MatchID { get; set; }
        public string MatchName { get; set; }
        public DateTime MatchDate { get; set; }
        public string Location { get; set; }
        public decimal TotalPayments { get; set; }
    }

    public class SponsorMatchCount
    {
        public int SponsorID { get; set; }
        public string SponsorName { get; set; }
        public int NumberOfMatches { get; set; }
    }

    public class PaymentRequest
    {
        public int ContractID { get; set; }
        public DateTime PaymentDate { get; set; }
        public decimal AmountPaid { get; set; }
        public string PaymentStatus { get; set; }
    }

}
