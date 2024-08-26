set search_path to Sponsor, public;
show search_path;


Create table Sponsors (
	SponsorID serial Primary Key,
	SponsorName Varchar(250) Not Null,
	IndustryType Varchar(250),
	ContactEmail Varchar(250) Unique Not Null,
	Phone Varchar(250) Not Null
)

Create table Matches (
	MatchID serial Primary Key,
	MatchName Varchar(250) Not Null,
	MatchDate Date Not Null,
	Location Varchar Not Null
)

CREATE TABLE Contracts (
    ContractID SERIAL PRIMARY KEY,
    SponsorID INT REFERENCES Sponsors(SponsorID),
    MatchID INT REFERENCES Matches(MatchID),
    ContractDate DATE NOT NULL,
    ContractValue DECIMAL NOT NULL
);


Create table Payments (
	PaymentID serial Primary Key,
	ContractID int references Contracts(contractID),
	PaymentDate date not null,
	AmountPaid decimal not null,
	PaymentStatus VARCHAR(250) CHECK (PaymentStatus IN ('Pending', 'Completed', 'Failed')) NOT NULL
)

INSERT INTO Sponsors (SponsorName, IndustryType, ContactEmail, Phone)
VALUES
('Nike', 'Sportswear', 'nike@sports.com', '1234567890'),
('Adidas', 'Sportswear', 'contact@adidas.com', '2345678901'),
('Red Bull', 'Energy', 'info@redbull.com', '3456789012'),
('Puma', 'Sportswear', 'support@puma.com', '4567890123'),
('Under Armour', 'Sportswear', 'hello@underarmour.com', '5678901234'),
('Coca Cola', 'Beverages', 'contact@coca-cola.com', '6789012345'),
('Pepsi', 'Beverages', 'pepsi@contact.com', '7890123456'),
('Samsung', 'Electronics', 'samsung@sponsor.com', '8901234567'),
('Sony', 'Electronics', 'support@sony.com', '9012345678'),
('Visa', 'Financial Services', 'info@visa.com', '1234567890');


INSERT INTO Matches (MatchName, MatchDate, Location)
VALUES
('ICC World Cup Final', '2024-11-15', 'Mumbai'),
('UEFA Champions League Final', '2024-06-01', 'London'),
('ISL Semi-Final', '2024-12-10', 'Kolkata'),
('NBA Finals Game 7', '2024-06-25', 'Los Angeles'),
('Super Bowl LVII', '2024-02-10', 'Miami'),
('Wimbledon Mens Final', '2024-07-14', 'London'),
('Tokyo Olympic 100m Final', '2024-07-31', 'Tokyo'),
('FIFA World Cup Semi-Final', '2024-12-18', 'Doha'),
('Indian Premier League Final', '2024-05-20', 'Chennai'),
('Boston Marathon', '2024-04-19', 'Boston');

INSERT INTO Contracts (SponsorID, MatchID, ContractDate, ContractValue)
VALUES
(1, 1, '2024-08-01', 150000.00),
(2, 2, '2024-05-15', 200000.00),
(3, 3, '2024-09-20', 100000.00),
(4, 4, '2024-07-01', 180000.00),
(5, 5, '2024-06-10', 250000.00),
(6, 6, '2024-02-01', 220000.00),
(7, 7, '2024-07-25', 175000.00),
(8, 8, '2024-12-01', 300000.00),
(9, 9, '2024-05-10', 270000.00),
(10, 10, '2024-04-01', 160000.00);
INSERT INTO Contracts (SponsorID, MatchID, ContractDate, ContractValue)
VALUES
(1, 2, '2024-08-01', 150000.00),  -- Nike sponsoring UEFA Champions League Final
(1, 3, '2024-09-01', 130000.00);  -- Nike sponsoring ISL Semi-Final
-- Adidas sponsoring multiple matches
INSERT INTO Contracts (SponsorID, MatchID, ContractDate, ContractValue)
VALUES
(2, 4, '2024-07-01', 180000.00),  -- Adidas sponsoring NBA Finals Game 7
(2, 5, '2024-06-01', 200000.00);  -- Adidas sponsoring Super Bowl LVII
INSERT INTO Contracts (SponsorID, MatchID, ContractDate, ContractValue)
VALUES
(3, 6, '2024-07-10', 120000.00),  -- Red Bull sponsoring Wimbledon Men's Final
(3, 7, '2024-08-01', 140000.00);  -- Red Bull sponsoring Tokyo Olympic 100m Final

INSERT INTO Payments (ContractID, PaymentDate, AmountPaid, PaymentStatus)
VALUES
(1, '2024-08-10', 75000.00, 'Completed'),
(1, '2024-09-10', 75000.00, 'Completed'),
(2, '2024-06-20', 100000.00, 'Completed'),
(2, '2024-07-20', 100000.00, 'Completed'),
(3, '2024-09-30', 50000.00, 'Completed'),
(3, '2024-10-30', 50000.00, 'Pending'),
(4, '2024-07-10', 90000.00, 'Completed'),
(4, '2024-08-10', 90000.00, 'Pending'),
(5, '2024-06-15', 125000.00, 'Completed'),
(6, '2024-02-20', 110000.00, 'Completed'),
(7, '2024-08-01', 87500.00, 'Completed'),
(8, '2024-12-10', 150000.00, 'Completed'),
(9, '2024-05-25', 135000.00, 'Completed'),
(10, '2024-04-10', 80000.00, 'Completed'),
(10, '2024-05-10', 80000.00, 'Pending');



--   Retrieve the Top 5 Most Expensive Contracts.Display the ContractId and contract Value.
select contractID, contractValue from Contracts order by ContractValue desc limit 5;

-- Select all payments that are pending, and update their status to 'Completed' 
-- if the payment date is within the last 7 days.
Update Payments 
	set PaymentStatus = 'Completed' 
	where PaymentStatus = 'Pending' AND PaymentDate = Current_date - interval '7 days';

SELECT ContractID, PaymentDate, AmountPaid, PaymentStatus
FROM Payments
WHERE PaymentStatus = 'Completed'
  AND PaymentDate >= CURRENT_DATE - INTERVAL '7 days';

--- List All Matches that are Scheduled After July 1, 2024, Sorted by Match Date
select MatchName,MatchDate from Matches where MatchDate >= '2024-07-01' order by MatchDate asc;

-- List All Sponsors and the Number of Matches They Have Sponsored, 
-- Including Those Who Haven't Sponsored Any Matches .
-- Display the SponsorName and the Number of MatchesSponsored

select S.SponsorName, count(C.MatchID) from Sponsors S 
	 join Contracts C on S.SponsorID = C.SponsorID  
	group by S.SponsorName;


-- List the sponsors who have not completed their payments for any contract. 
-- Display the SponsorName, ContractID  and status. 

select S.SponsorName, C.ContractID, P.PaymentStatus from Sponsors S join Contracts C on 
S.SponsorID = C.SponsorID join Payments P on C.ContractID =  P.ContractID where P.PaymentStatus = 'Pending' ;


-- 1. Retrieve the total contract value for each sponsor, but only for sponsors who have at least one completed payment. Display the Sponsorname and the TotalContractValue.
-- Query: 

select Sponsors.SponsorName, sum(Contracts.ContractValue) as TotalContractValue from Sponsors join Contracts on Sponsors.SponsorID = Contracts.SponsorID join Payments on Contracts.ContractId = Payments.ContractId where Payments.PaymentStatus = 'Completed' group by Sponsors.SponsorName;

-- 2. Retrieve sponsors who have sponsored more than one match, along with the total number of matches they have sponsored. Display the Sponsor name and Number of Matches.
-- Query:

select Sponsors.SponsorName, count(Matches.MatchID) from Sponsors join Contracts on Sponsors.SponsorID = Contracts.SponsorID join Matches on Contracts.MatchID = Matches.MatchID group by Sponsors.SponsorName having count(Matches.MatchId) > 1

-- 3. Write an SQL query that retrieves a list of all sponsors along with their total contract value. Additionally, categorize each sponsor based on the total value of their contracts using the following criteria:
-- If the total contract value is greater than $500,000, label the sponsor as 'Platinum'.
-- If the total contract value is between $200,000 and $500,000, label the sponsor as 'Gold'.
-- If the total contract value is between $100,000 and $200,000, label the sponsor as 'Silver'.
-- If the total contract value is less than $100,000, label the sponsor as 'Bronze'.
-- Query: 

select Sponsors.SponsorName, sum(Contracts.ContractValue) as TotalContractValue,
  case 
    when sum(Contracts.ContractValue) > 500000 then 'Platinum'
    when sum(Contracts.ContractValue) between 200000 and 500000 then 'Gold'
    when sum(Contracts.ContractValue) between 100000 and 200000 then 'Silver'
    else 'Bronze'end as SponsorCategory
from Sponsors join Contracts on Sponsors.SponsorID = Contracts.SponsorID group by Sponsors.SponsorName order by TotalContractValue desc;

-- 4. Retrieve Matches Where the Average Contract Value is Greater Than the Average Contract Value of All Matches. Display the match name and average contract value.
-- Query:

with AverageContractValue as ( select avg(Contracts.ContractValue) as AvgValue from Contracts )
select Matches.MatchName, avg(Contracts.ContractValue) as AvgContractValue
from Matches join Contracts on Matches.MatchID = Contracts.MatchID group by Matches.MatchName
having avg(Contracts.ContractValue) > (select AvgValue from AverageContractValue);

-- 5.     Find Sponsors Who Have the Highest Total Payments for a Single Match.Display the sponsor name, match name and total amount paid.
-- Query:

select Sponsors.SponsorName, Matches.MatchName, sum(Payments.AmountPaid) as TotalAmountPaid from Sponsors 
join Contracts on Sponsors.SponsorID = Contracts.SponsorID
join Matches on Contracts.MatchID = Matches.MatchID
join Payments on Contracts.ContractID = Payments.ContractID
group by Sponsors.SponsorName, Matches.MatchName
order by TotalAmountPaid desc limit 1;



-- 1.      Create a SQL view that provides a comprehensive overview of all sponsorship activities. The view should include the following details:

-- Sponsor Details:

-- Sponsor Name

-- Industry Type

-- Contact Email

-- Match Details:

-- Match Name

-- Match Date

-- Location

-- Contract Details:

-- Contract Value

-- Contract Date

-- Payment Summary:

-- Total Amount Paid by the Sponsor

-- Number of Payments Made

-- Latest Payment Date

-- Additional Requirements:

-- Only include sponsors who have made at least one payment.

-- Calculate the total amount paid by each sponsor for each match.

-- Include sponsors even if they have contracts but no completed payments, indicating their status with a Pending label in the PaymentStatus column.

-- Sort the results first by Sponsor Name and then by Match Date.


create view SponsorshipActivities as
select 
  S.SponsorName,
  S.IndustryType,
  S.ContactEmail,
  M.MatchName,
  M.MatchDate,
  M.Location,
  C.ContractValue,
  C.ContractDate,
  coalesce(P.TotalAmountPaid, 0) as TotalAmountPaid,
  coalesce(P.NumberOfPayments, 0) as NumberOfPayments,
  P.LatestPaymentDate,
  coalesce(P.PaymentStatus, 'Pending') as PaymentStatus
from 
  Sponsors S
  join Contracts C on S.SponsorID = C.SponsorID
  join Matches M on C.MatchID = M.MatchID
  left join (
    select 
      ContractID,
      sum(AmountPaid) as TotalAmountPaid,
      count(*) as NumberOfPayments,
      max(PaymentDate) as LatestPaymentDate,
      'Completed' as PaymentStatus
    from 
      Payments
    group by 
      ContractID
  ) P on C.ContractID = P.ContractID
where 
  S.SponsorID in (select S.SponsorID from Payments)
order by 
  S.SponsorName, M.MatchDate;



-- Create a view that lists all matches along with their sponsors and the total payments received.Then, retrieve all matches where the total payments exceed $200,000.

create view MatchSponsorPayments as
select 
  M.MatchName, S.SponsorName,
  sum(P.AmountPaid) as TotalPayments
from 
  Matches M
  join Contracts C on M.MatchID = C.MatchID
  join Sponsors S on C.SponsorID = S.SponsorID
  join Payments P on C.ContractID = P.ContractID
group by  M.MatchName, S.SponsorName; 

select * from MatchSponsorPayments where TotalPayments > 200000;

-- Create a view that displays the contract details (ContractID, SponsorName, MatchName, ContractValue) and write a query to retrieve contracts with a value greater than the average contract value.

create view ContractDetails as
select 
  C.ContractID,
  S.SponsorName,
  M.MatchName,
  C.ContractValue
from 
  Contracts C
  join Sponsors S on C.SponsorID = S.SponsorID
  join Matches M on C.MatchID = M.MatchID;

with AverageContractValue as (
  select avg(ContractValue) as AvgValue from Contracts
)
select * from ContractDetails where ContractValue > (select AvgValue from AverageContractValue);

-- 3. Create a view to display all pending payments for each sponsor and write a query to list the sponsors who have pending payments totaling more than $50,000.


create view PendingPayments as
select 
  S.SponsorName,
  sum(P.AmountPaid) as PendingAmount
from 
  Sponsors S
  join Contracts C on S.SponsorID = C.SponsorID
  join Payments P on C.ContractID = P.ContractID
where 
  P.PaymentStatus = 'Pending'
group by  
  S.SponsorName;

select * from PendingPayments where PendingAmount > 50000;

-- 4. Create a view that shows the number of matches each sponsor has sponsored. Then, write a query to find sponsors who have sponsored more than 2 matches.
create view SponsorMatches as
select 
  S.SponsorName,
  count(M.MatchID) as NumberOfMatches
from 
  Sponsors S
  join Contracts C on S.SponsorID = C.SponsorID
  join Matches M on C.MatchID = M.MatchID
group by 
  S.SponsorName;

select * from SponsorMatches where NumberOfMatches > 2;
