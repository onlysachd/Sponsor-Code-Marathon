namespace Tutorials.DAO;
using Tutorials.Models;

public interface IEmployeeDAO
{
    Task<IEnumerable<Employee>> GetSponsorPaymentSummariesAsync();

    Task<IEnumerable<MatchPaymentSummary>> GetMatchPaymentSummariesAsync();

    Task<IEnumerable<SponsorMatchCount>> GetSponsorMatchCountsAsync(int year);

    Task<bool> AddPaymentAsync(PaymentRequest paymentRequest);
}


