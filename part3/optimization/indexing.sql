-- Core Customer table: frequent queries/joins
CREATE INDEX idx_customer_name ON Customer(CustomerName); -- Name search
CREATE INDEX idx_customer_type_age ON Customer(CustomerType, Age); -- Type + age filter
CREATE INDEX idx_customer_marital_income ON Customer(MaritalStatus, AnnualIncome); -- Marital + income filter

-- Core Account table: frequent associations/type filters
CREATE INDEX idx_account_name ON Account(AccountName); -- Name search
CREATE INDEX idx_account_type_region ON Account(AccountType, AccountRegion); -- Type + region filter

-- Core Contract table: large data/time filters
CREATE INDEX idx_contract_effectivedate ON Contract(EffectiveDate); -- Effective date filter
CREATE INDEX idx_contract_policytype ON Contract(PolicyType); -- Policy type filter
CREATE INDEX idx_contract_policyowner_payer ON Contract(PolicyOwnerID, PayerID); -- Owner + payer join

-- ContractBenefit table: frequent filters
CREATE INDEX idx_contractbenefit_benefittype ON ContractBenefit(BenefitType); -- Benefit type filter
CREATE INDEX idx_contractbenefit_coverage ON ContractBenefit(CoverageAmount); -- Coverage amount range

-- Core ContractPremium table: large data/time/amount queries
CREATE INDEX idx_contractpremium_period ON ContractPremium(Period); -- Period filter
CREATE INDEX idx_contractpremium_calculation ON ContractPremium(CalculationType); -- Calculation type filter
CREATE INDEX idx_contractpremium_amount ON ContractPremium(PremiumAmount); -- Premium amount range

-- AccountMember table: time range/status filters
CREATE INDEX idx_accountmember_iscurrent ON AccountMember(IsCurrent); -- Active status filter
CREATE INDEX idx_accountmember_daterange ON AccountMember(StartDate, EndDate); -- Start/end date range

-- Associate table: frequent associations/name/region queries
CREATE INDEX idx_associate_name ON Associate(AssociateName); -- Name search
CREATE INDEX idx_associate_licensestate ON Associate(LicenseState); -- License state filter

-- ManagerContract table: associate/contract queries
CREATE INDEX idx_managercontract_sitcode ON ManagerContract(SitCode); -- SIT code search
CREATE INDEX idx_managercontract_writingnumber ON ManagerContract(WritingNumber); -- Writing number search

-- Customer_Associate table: frequent joins
CREATE INDEX idx_ca_relationtype ON Customer_Associate(RelationType); -- Relation type filter

-- ContractBenefit_Customer table: frequent joins
CREATE INDEX idx_cbc_customer_contract ON ContractBenefit_Customer(CustomerId, ContractId); -- Customer + contract join