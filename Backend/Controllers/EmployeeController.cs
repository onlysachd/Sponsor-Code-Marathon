using Microsoft.AspNetCore.Mvc;
using Tutorials.DAO;
using Tutorials.Models;

namespace Tutorials.Controllers
{
    [Route("api/employee")]
    [ApiController]
    public class EmployeeController : Controller
    {
        private readonly IEmployeeDAO _employeeDAO;

        public EmployeeController(IEmployeeDAO employeeDAO)
        {
            _employeeDAO = employeeDAO;
        }

        [HttpGet("payment-summary")]

        public async Task<ActionResult<IEnumerable<Employee>>> GetSponsorPaymentSummaries()
        {
            var summaries = await _employeeDAO.GetSponsorPaymentSummariesAsync();
            return Ok(summaries);
        }

        [HttpGet("match-payment-summary")]
        public async Task<ActionResult<IEnumerable<MatchPaymentSummary>>> GetMatchPaymentSummaries()
        {
            var summaries = await _employeeDAO.GetMatchPaymentSummariesAsync();
            return Ok(summaries);
        }

        [HttpGet("matches-count")]
        public async Task<ActionResult<IEnumerable<SponsorMatchCount>>> GetSponsorMatchCounts([FromQuery] int year)
        {
            if (year < 1900 || year > DateTime.Now.Year)
            {
                return BadRequest("Invalid year.");
            }

            var sponsorMatchCounts = await _employeeDAO.GetSponsorMatchCountsAsync(year);
            return Ok(sponsorMatchCounts);
        }

        [HttpPost]
        public async Task<IActionResult> AddPayment([FromBody] PaymentRequest paymentRequest)
        {
            if (paymentRequest == null)
            {
                return BadRequest("Payment request cannot be null.");
            }

            if (paymentRequest.AmountPaid <= 0 || paymentRequest.PaymentDate == default)
            {
                return BadRequest("Invalid payment data.");
            }

            var result = await _employeeDAO.AddPaymentAsync(paymentRequest);

            if (result)
            {
                return CreatedAtAction(nameof(AddPayment), new { id = paymentRequest.ContractID }, paymentRequest);
            }
            else
            {
                return NotFound("Contract not found.");
            }
        }

    }
}
