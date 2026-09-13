--Create Database 
CREATE DATABASE BankChurnDB ;

--Use database 
USE BankChurnDB ;

--Display data from the Table
SELECT * FROM Bank_Churn_Data

--Total Customers 
SELECT COUNT(*) AS Total_Customers
FROM Bank_Churn_Data

--Churn Count
SELECT Churn,
	   COUNT(*) Customer_Count
FROM Bank_Churn_Data
GROUP BY Churn ;

--Display Customer Information
SELECT  Customer_ID , Age , Gender , Churn
FROM Bank_Churn_Data ;

--Churned Customers
SELECT * FROM Bank_Churn_Data
WHERE Churn = 1 ;

--Customers Who Stayed
SELECT * FROM Bank_Churn_Data
WHERE Churn = 0 ;

--Customers Above Age 50
SELECT Customer_ID , Age , Gender , Churn 
FROM Bank_Churn_Data
WHERE Age > 50 ;

--The Average Age of customers For Each Churn Status.
SELECT Churn , 
	   AVG(Age) AS [Average Age]
FROM Bank_Churn_Data
GROUP BY Churn;

--Average Balance 
SELECT Churn , 
	   AVG(Average_Balance) AS Average_Balance
FROM Bank_Churn_Data 
GROUP BY Churn ;

--Account Type Distribution
SELECT Account_Type ,
	   COUNT(*) AS [No Of Customers]
FROM Bank_Churn_Data 
GROUP BY Account_Type;

--Churn by Account Type
SELECT
    Account_Type,
    COUNT(*) AS Total_Customers,
    SUM(CASE
        WHEN Churn = 1 THEN 1
        ELSE 0
    END) AS Churned_Customers
FROM Bank_Churn_Data
GROUP BY Account_Type;

--The Overall Customer Churn Rate as a Percentage.
SELECT Churn , 
       COUNT(*) AS Customer_count,
       COUNT(*) * 100.0 /(SELECT COUNT(*) FROM Bank_Churn_Data ) 
       AS Churn_Percentage
FROM Bank_Churn_Data
GROUP BY Churn;

-- The Churn Rate For Each Gender
SELECT Gender,
       COUNT(*) AS Total_Customers,
       SUM(CASE
        WHEN Churn = 1 THEN 1
        ELSE 0
    END) AS Churned_Customers,
    SUM(CASE
        WHEN Churn = 1 THEN 1
        ELSE 0
    END) * 100.0 / COUNT(*) AS Churn_Rate

FROM Bank_Churn_Data
GROUP BY Gender;

--Products and Churn
SELECT Number_of_Products,
       COUNT(*) AS Total_Customers,
       SUM(CASE
        WHEN Churn = 1 THEN 1
        ELSE 0
    END) AS Churned_Customers,
    SUM(CASE
        WHEN Churn = 1 THEN 1
        ELSE 0
    END) * 100.0 / COUNT(*) AS Churn_Rate

FROM Bank_Churn_Data
GROUP BY Number_of_Products;

--Complaints and Churn
SELECT Number_of_Complaints,
       COUNT(*) AS Total_Customers,
       SUM(CASE
        WHEN Churn = 1 THEN 1
        ELSE 0
    END) AS Churned_Customers,
    SUM(CASE
        WHEN Churn = 1 THEN 1
        ELSE 0
    END) * 100.0 / COUNT(*) AS Churn_Rate

FROM Bank_Churn_Data
GROUP BY Number_of_Complaints;

--Account Types where the no of churned customers is greater than 500.
SELECT
    Account_Type,
    SUM(CASE
        WHEN Churn = 1 THEN 1
        ELSE 0
    END) AS Churned_Customers
FROM Bank_Churn_Data
GROUP BY Account_Type
HAVING SUM(CASE WHEN Churn = 1 THEN 1
        ELSE 0 END) > 500 ;

--Customers Ranked by Their Average_Balance From Highest to Lowest.
SELECT Customer_ID,
       Average_Balance ,
       RANK() OVER (ORDER BY Average_Balance DESC) AS [Rank]
FROM Bank_Churn_Data;

--Rank of Each Customer Based on Average_Balance Within their Account_Type.
SELECT Customer_ID,Account_Type ,
       RANK() OVER (PARTITION BY Account_Type 
       ORDER BY Average_Balance DESC) AS [Rank]
FROM Bank_Churn_Data;

-- Churn by Loan Account Holder
SELECT
    Loan_Account_Holder,
    COUNT(*) AS Total_Customers,
    (SELECT COUNT(*)
     FROM Bank_Churn_Data B2
     WHERE B2.Loan_Account_Holder = B1.Loan_Account_Holder
       AND B2.Churn = 1) AS Churned_Customers
FROM Bank_Churn_Data B1
GROUP BY Loan_Account_Holder;

-- Churn by Credit Card Holder
SELECT
    Credit_Card_Holder,
    COUNT(*) AS Total_Customers,
    (SELECT COUNT(*)
     FROM Bank_Churn_Data B2
     WHERE B2.Credit_Card_Holder = B1.Credit_Card_Holder
       AND B2.Churn = 1) AS Churned_Customers
FROM Bank_Churn_Data B1
GROUP BY Credit_Card_Holder;

-- Customers with High Balance but Churned
SELECT
    Customer_ID,
    Average_Balance,
    Account_Type,
    Churn
FROM Bank_Churn_Data
WHERE Churn = 1
  AND Average_Balance > (
      SELECT AVG(Average_Balance)
      FROM Bank_Churn_Data
  );
