using System.Numerics;
using Tutorials.Models;
using Npgsql;
using System.Collections.Generic;
using System.Threading.Tasks;
namespace Tutorials.DAO
{
    public class EmployeeDAOImpl : IEmployeeDAO
    {
        private readonly string _connectionString;

        public EmployeeDAOImpl(string connectionString)
        {
            _connectionString = connectionString;
        }

        public async Task<IEnumerable<Employee>> GetSponsorPaymentSummariesAsync()
        {
            var sponsorSummaries = new List<Employee>();

            using (var connection = new NpgsqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                var query = @"
                    SELECT 
                        s.SponsorID,
                        s.SponsorName,
                        COALESCE(SUM(p.AmountPaid), 0) AS TotalPayments,
                        COALESCE(COUNT(p.PaymentID), 0) AS NumberOfPayments,
                        MAX(p.PaymentDate) AS LatestPaymentDate
                    FROM Sponsors s
                    LEFT JOIN Contracts c ON s.SponsorID = c.SponsorID
                    LEFT JOIN Payments p ON c.ContractID = p.ContractID
                    GROUP BY s.SponsorID, s.SponsorName";

                using (var command = new NpgsqlCommand(query, connection))
                {
                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            sponsorSummaries.Add(new Employee
                            {
                                SponsorID = reader.GetInt32(0),
                                SponsorName = reader.GetString(1),
                                TotalPayments = reader.GetDecimal(2),
                                NumberOfPayments = reader.GetInt32(3),
                                LatestPaymentDate = reader.IsDBNull(4) ? (DateTime?)null : reader.GetDateTime(4)
                            });
                        }
                    }
                }
            }

            return sponsorSummaries;
        }

        public async Task<IEnumerable<MatchPaymentSummary>> GetMatchPaymentSummariesAsync()
        {
            var matchSummaries = new List<MatchPaymentSummary>();

            using (var connection = new NpgsqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                var query = @"
                    SELECT 
                        m.MatchID,
                        m.MatchName,
                        m.MatchDate,
                        m.Location,
                        COALESCE(SUM(p.AmountPaid), 0) AS TotalPayments
                    FROM Matches m
                    LEFT JOIN Contracts c ON m.MatchID = c.MatchID
                    LEFT JOIN Payments p ON c.ContractID = p.ContractID
                    GROUP BY m.MatchID, m.MatchName, m.MatchDate, m.Location";

                using (var command = new NpgsqlCommand(query, connection))
                {
                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            matchSummaries.Add(new MatchPaymentSummary
                            {
                                MatchID = reader.GetInt32(0),
                                MatchName = reader.GetString(1),
                                MatchDate = reader.GetDateTime(2),
                                Location = reader.GetString(3),
                                TotalPayments = reader.GetDecimal(4)
                            });
                        }
                    }
                }
            }

            return matchSummaries;
        }

        public async Task<IEnumerable<SponsorMatchCount>> GetSponsorMatchCountsAsync(int year)
        {
            var sponsorMatchCounts = new List<SponsorMatchCount>();

            using (var connection = new NpgsqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                var query = @"
                    SELECT 
                        s.SponsorID,
                        s.SponsorName,
                        COUNT(m.MatchID) AS NumberOfMatches
                    FROM Sponsors s
                    LEFT JOIN Contracts c ON s.SponsorID = c.SponsorID
                    LEFT JOIN Matches m ON c.MatchID = m.MatchID
                    WHERE EXTRACT(YEAR FROM m.MatchDate) = @Year
                    GROUP BY s.SponsorID, s.SponsorName";

                using (var command = new NpgsqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@Year", year);

                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            sponsorMatchCounts.Add(new SponsorMatchCount
                            {
                                SponsorID = reader.GetInt32(0),
                                SponsorName = reader.GetString(1),
                                NumberOfMatches = reader.GetInt32(2)
                            });
                        }
                    }
                }
            }

            return sponsorMatchCounts;
        }

        public async Task<bool> AddPaymentAsync(PaymentRequest paymentRequest)
        {
            using (var connection = new NpgsqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                using (var transaction = await connection.BeginTransactionAsync())
                {
                    try
                    {
                        // Check if the contract exists
                        var contractExistsQuery = "SELECT COUNT(1) FROM Contracts WHERE ContractID = @ContractID";
                        using (var checkContractCommand = new NpgsqlCommand(contractExistsQuery, connection))
                        {
                            checkContractCommand.Parameters.AddWithValue("@ContractID", paymentRequest.ContractID);
                            var contractExists = (long)await checkContractCommand.ExecuteScalarAsync() > 0;

                            if (!contractExists)
                            {
                                return false; // Contract does not exist
                            }
                        }

                        // Insert the new payment
                        var insertPaymentQuery = @"
                            INSERT INTO Payments (ContractID, PaymentDate, AmountPaid, PaymentStatus)
                            VALUES (@ContractID, @PaymentDate, @AmountPaid, @PaymentStatus)";

                        using (var insertCommand = new NpgsqlCommand(insertPaymentQuery, connection))
                        {
                            insertCommand.Parameters.AddWithValue("@ContractID", paymentRequest.ContractID);
                            insertCommand.Parameters.AddWithValue("@PaymentDate", paymentRequest.PaymentDate);
                            insertCommand.Parameters.AddWithValue("@AmountPaid", paymentRequest.AmountPaid);
                            insertCommand.Parameters.AddWithValue("@PaymentStatus", paymentRequest.PaymentStatus);

                            await insertCommand.ExecuteNonQueryAsync();
                        }

                        // Commit transaction
                        await transaction.CommitAsync();
                        return true;
                    }
                    catch
                    {
                        // Rollback transaction in case of error
                        await transaction.RollbackAsync();
                        throw;
                    }
                }
            }
        }
    }
}


