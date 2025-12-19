-- Backup original data first: CREATE TABLE [table_name]_backup AS SELECT * FROM [table_name];

-- 1. Account: Partition by AccountType (list partition)
DROP TABLE IF EXISTS Account CASCADE;
CREATE TABLE Account (
    AccountId            integer  NOT NULL,
    AccountName          varchar(100)  NOT NULL,
    AccountType          varchar(30)  NOT NULL CHECK (AccountType IN ('Individual', 'Trust', 'Company')),
    AccountRegion        varchar(20)  NOT NULL,
    CompanyCode          varchar(50)  NULL,
    PRIMARY KEY (AccountId, AccountType) -- PK includes partition key
) PARTITION BY LIST (AccountType);

-- Sub-partitions
CREATE TABLE Account_individual PARTITION OF Account FOR VALUES IN ('Individual');
CREATE TABLE Account_trust PARTITION OF Account FOR VALUES IN ('Trust');
CREATE TABLE Account_company PARTITION OF Account FOR VALUES IN ('Company');

-- Sub-partition indexes
CREATE INDEX idx_account_individual_name ON Account_individual(AccountName);
CREATE INDEX idx_account_company_region ON Account_company(AccountRegion);

-- 2. Contract: Partition by EffectiveDate (range partition 2025+)
DROP TABLE IF EXISTS Contract CASCADE;
CREATE TABLE Contract (
    ContractId           integer  NOT NULL,
    PolicyType           varchar(20)  NULL,
    EffectiveDate        timestamp  NOT NULL, -- Partition key (non-null)
    PolicyOwnerID        integer  NOT NULL,
    PayerID              integer  NOT NULL,
    PRIMARY KEY (ContractId, PolicyOwnerID, PayerID, EffectiveDate) -- PK includes partition key
) PARTITION BY RANGE (EffectiveDate);

-- 2025 monthly partitions
CREATE TABLE Contract_y2025m01 PARTITION OF Contract FOR VALUES FROM ('2025-01-01 00:00:00') TO ('2025-02-01 00:00:00');
CREATE TABLE Contract_y2025m02 PARTITION OF Contract FOR VALUES FROM ('2025-02-01 00:00:00') TO ('2025-03-01 00:00:00');
CREATE TABLE Contract_y2025m03 PARTITION OF Contract FOR VALUES FROM ('2025-03-01 00:00:00') TO ('2025-04-01 00:00:00');
CREATE TABLE Contract_y2025m04 PARTITION OF Contract FOR VALUES FROM ('2025-04-01 00:00:00') TO ('2025-05-01 00:00:00');
CREATE TABLE Contract_y2025m05 PARTITION OF Contract FOR VALUES FROM ('2025-05-01 00:00:00') TO ('2025-06-01 00:00:00');
CREATE TABLE Contract_y2025m06 PARTITION OF Contract FOR VALUES FROM ('2025-06-01 00:00:00') TO ('2025-07-01 00:00:00');
CREATE TABLE Contract_y2025m07 PARTITION OF Contract FOR VALUES FROM ('2025-07-01 00:00:00') TO ('2025-08-01 00:00:00');
CREATE TABLE Contract_y2025m08 PARTITION OF Contract FOR VALUES FROM ('2025-08-01 00:00:00') TO ('2025-09-01 00:00:00');
CREATE TABLE Contract_y2025m09 PARTITION OF Contract FOR VALUES FROM ('2025-09-01 00:00:00') TO ('2025-10-01 00:00:00');
CREATE TABLE Contract_y2025m10 PARTITION OF Contract FOR VALUES FROM ('2025-10-01 00:00:00') TO ('2025-11-01 00:00:00');
CREATE TABLE Contract_y2025m11 PARTITION OF Contract FOR VALUES FROM ('2025-11-01 00:00:00') TO ('2025-12-01 00:00:00');
CREATE TABLE Contract_y2025m12 PARTITION OF Contract FOR VALUES FROM ('2025-12-01 00:00:00') TO ('2026-01-01 00:00:00');

-- 2026 reserved partitions
CREATE TABLE Contract_y2026m01 PARTITION OF Contract FOR VALUES FROM ('2026-01-01 00:00:00') TO ('2026-02-01 00:00:00');
CREATE TABLE Contract_y2026m02 PARTITION OF Contract FOR VALUES FROM ('2026-02-01 00:00:00') TO ('2026-03-01 00:00:00');
CREATE TABLE Contract_y2026m03 PARTITION OF Contract FOR VALUES FROM ('2026-03-01 00:00:00') TO ('2026-04-01 00:00:00');

-- Sub-partition indexes
CREATE INDEX idx_contract_policytype_y2025 ON Contract_y2025m01(PolicyType);
CREATE INDEX idx_contract_payerid_y2025 ON Contract_y2025m01(PayerID);

-- 3. ContractPremium: Partition by Period (range partition 2025+)
DROP TABLE IF EXISTS ContractPremium CASCADE;
CREATE TABLE ContractPremium (
    Period               timestamp  NOT NULL, -- Partition key (non-null)
    ContractPremiumId    integer  NOT NULL,
    PremiumAmount        numeric(19,4)  NULL,
    ContractBenefitId    integer  NOT NULL,
    ContractId           integer  NOT NULL,
    PolicyOwnerID        integer  NOT NULL,
    PayerID              integer  NOT NULL,
    CalculationType      varchar(20)  NULL CHECK (CalculationType IN ('Commission', 'Production Credit')),
    PRIMARY KEY (ContractPremiumId, ContractBenefitId, ContractId, PolicyOwnerID, PayerID, Period) -- PK includes partition key
) PARTITION BY RANGE (Period);

-- 2025 monthly partitions
CREATE TABLE ContractPremium_y2025m01 PARTITION OF ContractPremium FOR VALUES FROM ('2025-01-01 00:00:00') TO ('2025-02-01 00:00:00');
CREATE TABLE ContractPremium_y2025m02 PARTITION OF ContractPremium FOR VALUES FROM ('2025-02-01 00:00:00') TO ('2025-03-01 00:00:00');
CREATE TABLE ContractPremium_y2025m03 PARTITION OF ContractPremium FOR VALUES FROM ('2025-03-01 00:00:00') TO ('2025-04-01 00:00:00');
CREATE TABLE ContractPremium_y2025m04 PARTITION OF ContractPremium FOR VALUES FROM ('2025-04-01 00:00:00') TO ('2025-05-01 00:00:00');
CREATE TABLE ContractPremium_y2025m05 PARTITION OF ContractPremium FOR VALUES FROM ('2025-05-01 00:00:00') TO ('2025-06-01 00:00:00');
CREATE TABLE ContractPremium_y2025m06 PARTITION OF ContractPremium FOR VALUES FROM ('2025-06-01 00:00:00') TO ('2025-07-01 00:00:00');
CREATE TABLE ContractPremium_y2025m07 PARTITION OF ContractPremium FOR VALUES FROM ('2025-07-01 00:00:00') TO ('2025-08-01 00:00:00');
CREATE TABLE ContractPremium_y2025m08 PARTITION OF ContractPremium FOR VALUES FROM ('2025-08-01 00:00:00') TO ('2025-09-01 00:00:00');
CREATE TABLE ContractPremium_y2025m09 PARTITION OF ContractPremium FOR VALUES FROM ('2025-09-01 00:00:00') TO ('2025-10-01 00:00:00');
CREATE TABLE ContractPremium_y2025m10 PARTITION OF ContractPremium FOR VALUES FROM ('2025-10-01 00:00:00') TO ('2025-11-01 00:00:00');
CREATE TABLE ContractPremium_y2025m11 PARTITION OF ContractPremium FOR VALUES FROM ('2025-11-01 00:00:00') TO ('2025-12-01 00:00:00');
CREATE TABLE ContractPremium_y2025m12 PARTITION OF ContractPremium FOR VALUES FROM ('2025-12-01 00:00:00') TO ('2026-01-01 00:00:00');

-- 2026 reserved partitions
CREATE TABLE ContractPremium_y2026m01 PARTITION OF ContractPremium FOR VALUES FROM ('2026-01-01 00:00:00') TO ('2026-02-01 00:00:00');
CREATE TABLE ContractPremium_y2026m02 PARTITION OF ContractPremium FOR VALUES FROM ('2026-02-01 00:00:00') TO ('2026-03-01 00:00:00');

-- Sub-partition indexes
CREATE INDEX idx_contractpremium_calculation_y2025 ON ContractPremium_y2025m01(CalculationType);
CREATE INDEX idx_contractpremium_amount_y2025 ON ContractPremium_y2025m01(PremiumAmount);

-- 4. AccountMember: Partition by StartDate (range partition 2025+)
DROP TABLE IF EXISTS AccountMember CASCADE;
CREATE TABLE AccountMember (
    AccountMemberId      integer  NOT NULL,
    AccountMemberName    varchar(50)  NULL,
    IsCurrent            boolean  NULL,
    AccountId            integer  NOT NULL,
    StartDate            timestamp  NOT NULL, -- Partition key (non-null)
    EndDate              timestamp  NULL,
    PRIMARY KEY (AccountMemberId, AccountId, StartDate) -- PK includes partition key
) PARTITION BY RANGE (StartDate);

-- 2025 monthly partitions
CREATE TABLE AccountMember_y2025m01 PARTITION OF AccountMember FOR VALUES FROM ('2025-01-01 00:00:00') TO ('2025-02-01 00:00:00');
CREATE TABLE AccountMember_y2025m02 PARTITION OF AccountMember FOR VALUES FROM ('2025-02-01 00:00:00') TO ('2025-03-01 00:00:00');
CREATE TABLE AccountMember_y2025m03 PARTITION OF AccountMember FOR VALUES FROM ('2025-03-01 00:00:00') TO ('2025-04-01 00:00:00');
CREATE TABLE AccountMember_y2025m04 PARTITION OF AccountMember FOR VALUES FROM ('2025-04-01 00:00:00') TO ('2025-05-01 00:00:00');
CREATE TABLE AccountMember_y2025m05 PARTITION OF AccountMember FOR VALUES FROM ('2025-05-01 00:00:00') TO ('2025-06-01 00:00:00');
CREATE TABLE AccountMember_y2025m06 PARTITION OF AccountMember FOR VALUES FROM ('2025-06-01 00:00:00') TO ('2025-07-01 00:00:00');
CREATE TABLE AccountMember_y2025m07 PARTITION OF AccountMember FOR VALUES FROM ('2025-07-01 00:00:00') TO ('2025-08-01 00:00:00');
CREATE TABLE AccountMember_y2025m08 PARTITION OF AccountMember FOR VALUES FROM ('2025-08-01 00:00:00') TO ('2025-09-01 00:00:00');
CREATE TABLE AccountMember_y2025m09 PARTITION OF AccountMember FOR VALUES FROM ('2025-09-01 00:00:00') TO ('2025-10-01 00:00:00');
CREATE TABLE AccountMember_y2025m10 PARTITION OF AccountMember FOR VALUES FROM ('2025-10-01 00:00:00') TO ('2025-11-01 00:00:00');
CREATE TABLE AccountMember_y2025m11 PARTITION OF AccountMember FOR VALUES FROM ('2025-11-01 00:00:00') TO ('2025-12-01 00:00:00');
CREATE TABLE AccountMember_y2025m12 PARTITION OF AccountMember FOR VALUES FROM ('2025-12-01 00:00:00') TO ('2026-01-01 00:00:00');

-- Sub-partition indexes
CREATE INDEX idx_accountmember_iscurrent_y2025 ON AccountMember_y2025m01(IsCurrent);
CREATE INDEX idx_accountmember_enddate_y2025 ON AccountMember_y2025m01(EndDate);