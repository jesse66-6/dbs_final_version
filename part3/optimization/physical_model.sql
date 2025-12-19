-- 1. Account
CREATE TABLE Account
( 
	AccountId            integer  NOT NULL PRIMARY KEY,
	AccountName          varchar(100)  NOT NULL,
	AccountType          varchar(30)  NOT NULL CHECK (AccountType IN ('Individual', 'Trust', 'Company')),
	AccountRegion        varchar(20)  NOT NULL,
	CompanyCode          varchar(50)  NULL
);


-- 2. Account_Account
CREATE TABLE Account_Account
( 
	RelationType         varchar(20)  NULL CHECK (RelationType IN ('GroupMaster', 'Flex Master', 'Member')),
	MainAccountID        integer  NOT NULL,
	MemberAccountID      integer  NOT NULL,
	Id                   integer  NOT NULL,
	PRIMARY KEY (MainAccountID, MemberAccountID, Id)
);


-- 3. Account_AccountAdmin
CREATE TABLE Account_AccountAdmin
( 
	AccountId            integer  NOT NULL,
	AccountAdminId       integer  NOT NULL,
	Id                   integer  NOT NULL,
	PRIMARY KEY (AccountId, AccountAdminId, Id)
);


-- 4. Account_BillingAccount
CREATE TABLE Account_BillingAccount
( 
	AccountId            integer  NOT NULL,
	BillingAccountId     integer  NOT NULL,
	Id                   integer  NOT NULL,
	PRIMARY KEY (AccountId, BillingAccountId, Id)
);


-- 5. Account_Customer
CREATE TABLE Account_Customer
( 
	IsMoonlighting       boolean  NULL,
	AccountId            integer  NOT NULL,
	CustomerId           integer  NOT NULL,
	Id                   integer  NOT NULL,
	PRIMARY KEY (AccountId, CustomerId, Id)
);


-- 6. Account_ManagerContract
CREATE TABLE Account_ManagerContract
( 
	RoleType             varchar(20)  NULL CHECK (RoleType IN ('Original Servicing', 'Servicing', 'Broker')),
	AccountId            integer  NOT NULL,
	ManagerContractId    integer  NOT NULL,
	AssociateId          integer  NOT NULL,
	Id                   integer  NOT NULL,
	PRIMARY KEY (Id, AccountId, ManagerContractId, AssociateId)
);


-- 7. AccountAdmin
CREATE TABLE AccountAdmin
( 
	AccountAdminId       integer  NOT NULL PRIMARY KEY,
	AccountAdminName     varchar(50)  NOT NULL,
	Expertise            varchar(50)  NULL CHECK (Expertise IN ('FSA', 'Life', 'A&H'))
);


-- 8. AccountAlias
CREATE TABLE AccountAlias
( 
	AccountAliasId       integer  NOT NULL,
	OriginalDataType     varchar(50)  NULL,
	DuplicateFlag        boolean  NULL,
	AccountId            integer  NOT NULL,
	PRIMARY KEY (AccountAliasId, AccountId)
);


-- 9. AccountMember
CREATE TABLE AccountMember
( 
	AccountMemberId      integer  NOT NULL,
	AccountMemberName    varchar(50)  NULL,
	IsCurrent            boolean  NULL,
	AccountId            integer  NOT NULL,
	StartDate            timestamp  NULL,
	EndDate              timestamp  NULL,
	PRIMARY KEY (AccountMemberId, AccountId)
);


-- 10. Associate
CREATE TABLE Associate
( 
	AssociateId          integer  NOT NULL PRIMARY KEY,
	LicenseState         varchar(10)  NOT NULL,
	AssociateName        varchar(100)  NOT NULL
);


-- 11. Associate_Associate
CREATE TABLE Associate_Associate
( 
	Id                   integer  NOT NULL,
	RelationType         varchar(20)  NULL CHECK (RelationType IN ('Broker', 'Recruiter', 'Upline', 'DSC', 'RSC')),
	IsFormal             boolean  NULL,
	MainAssociateId      integer  NOT NULL,
	RelatedAssociateId   integer  NOT NULL,
	PRIMARY KEY (Id, MainAssociateId, RelatedAssociateId)
);


-- 12. BillingAccount
CREATE TABLE BillingAccount
( 
	BillingAccountId     integer  NOT NULL PRIMARY KEY,
	POBox                varchar(20)  NULL,
	BusinessType         varchar(20)  NULL CHECK (BusinessType IN ('FSA', 'Life', 'A&H')),
	EmployeeType         varchar(20)  NULL CHECK (EmployeeType IN ('salaried', 'hourly', 'ALL'))
);


-- 13. Contract
CREATE TABLE Contract
( 
	ContractId           integer  NOT NULL,
	PolicyType           varchar(20)  NULL,
	EffectiveDate        timestamp  NULL,
	PolicyOwnerID        integer  NOT NULL,
	PayerID              integer  NOT NULL,
	PRIMARY KEY (ContractId, PolicyOwnerID, PayerID)
);


-- 14. ContractBenefit
CREATE TABLE ContractBenefit
( 
	ContractBenefitId    integer  NOT NULL,
	BenefitType          varchar(20)  NULL,
	CoverageAmount       numeric(19,4)  NULL,
	ContractId           integer  NOT NULL,
	PolicyOwnerID        integer  NOT NULL,
	PayerID              integer  NOT NULL,
	PRIMARY KEY (ContractBenefitId, ContractId, PolicyOwnerID, PayerID)
);


-- 15. ContractBenefit_Customer
CREATE TABLE ContractBenefit_Customer
( 
	Id                   integer  NOT NULL,
	CustomerId           integer  NOT NULL,
	ContractId           integer  NOT NULL,
	PolicyOwnerID        integer  NOT NULL,
	PayerID              integer  NOT NULL,
	ContractBenefitId    integer  NOT NULL,
	PRIMARY KEY (Id, CustomerId, ContractId, PolicyOwnerID, PayerID, ContractBenefitId)
);


-- 16. ContractPremium
CREATE TABLE ContractPremium
( 
	Period               timestamp  NULL,
	ContractPremiumId    integer  NOT NULL,
	PremiumAmount        numeric(19,4)  NULL,
	ContractBenefitId    integer  NOT NULL,
	ContractId           integer  NOT NULL,
	PolicyOwnerID        integer  NOT NULL,
	PayerID              integer  NOT NULL,
	CalculationType      varchar(20)  NULL CHECK (CalculationType IN ('Commission', 'Production Credit')),
	PRIMARY KEY (ContractPremiumId, ContractBenefitId, ContractId, PolicyOwnerID, PayerID)
);


-- 17. Customer
CREATE TABLE Customer
( 
	CustomerId           integer  NOT NULL PRIMARY KEY,
	CustomerName         varchar(20)  NOT NULL,
	CustomerType         varchar(20)  NOT NULL CHECK (CustomerType IN ('Individual', 'Trust', 'Company')),	
	Age                  integer  NULL CHECK (Age >= 0 AND Age < 120),
	Gender               varchar(10)  NULL CHECK (Gender IN ('Male', 'Female', 'Other')),
	MaritalStatus        varchar(20)  NULL CHECK (MaritalStatus IN ('Single', 'Married', 'Divorced', 'Widowed')),
	AnnualIncome         numeric(19,2) NULL,
	EducationLevel       varchar(50)  NULL CHECK (EducationLevel IN ('High School', 'Associate', 'Bachelor', 'Master', 'PhD', 'Other')),
	NumberOfDependents   integer  NULL DEFAULT 0 CHECK (NumberOfDependents >= 0)
);


-- 18. Customer_Associate
CREATE TABLE Customer_Associate
( 
	Id                   integer  NOT NULL,
	RelationType         varchar(20)  NULL CHECK (RelationType IN ('Commission Beneficiary', 'Policy Sale')),
	AssociateId          integer  NOT NULL,
	CustomerId           integer  NOT NULL,
	PRIMARY KEY (Id, AssociateId, CustomerId)
);


-- 19. Customer_Customer
CREATE TABLE Customer_Customer
( 
	Id                   integer  NOT NULL,
	RelationType         varchar(20)  NULL CHECK (RelationType IN ('Family', 'Trust', 'PolicyOwner', 'Beneficiary')),
	MainCustomerId       integer  NOT NULL,
	RelatedCustomerId    integer  NOT NULL,
	PRIMARY KEY (Id, MainCustomerId, RelatedCustomerId)
);


-- 20. ManagerContract
CREATE TABLE ManagerContract
( 
	ManagerContractId    integer  NOT NULL,
	SitCode              varchar(20)  NULL,
	SitCodeType          varchar(20)  NULL CHECK (SitCodeType IN ('Formal', 'Informal')),
	WritingNumber        varchar(30)  NULL,
	AssociateId          integer  NOT NULL,
	PRIMARY KEY (ManagerContractId, AssociateId)
);


-- Foreign Keys
ALTER TABLE Account_Account ADD FOREIGN KEY (MainAccountID) REFERENCES Account(AccountId);
ALTER TABLE Account_Account ADD FOREIGN KEY (MemberAccountID) REFERENCES Account(AccountId);

ALTER TABLE Account_AccountAdmin ADD FOREIGN KEY (AccountId) REFERENCES Account(AccountId);
ALTER TABLE Account_AccountAdmin ADD FOREIGN KEY (AccountAdminId) REFERENCES AccountAdmin(AccountAdminId);

ALTER TABLE Account_BillingAccount ADD FOREIGN KEY (AccountId) REFERENCES Account(AccountId);
ALTER TABLE Account_BillingAccount ADD FOREIGN KEY (BillingAccountId) REFERENCES BillingAccount(BillingAccountId);

ALTER TABLE Account_Customer ADD FOREIGN KEY (AccountId) REFERENCES Account(AccountId);
ALTER TABLE Account_Customer ADD FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId);

ALTER TABLE Account_ManagerContract ADD FOREIGN KEY (AccountId) REFERENCES Account(AccountId);
ALTER TABLE Account_ManagerContract ADD FOREIGN KEY (ManagerContractId,AssociateId) REFERENCES ManagerContract(ManagerContractId,AssociateId);

ALTER TABLE AccountAlias ADD FOREIGN KEY (AccountId) REFERENCES Account(AccountId);

ALTER TABLE AccountMember ADD FOREIGN KEY (AccountId) REFERENCES Account(AccountId);

ALTER TABLE Associate_Associate ADD FOREIGN KEY (MainAssociateId) REFERENCES Associate(AssociateId);
ALTER TABLE Associate_Associate ADD FOREIGN KEY (RelatedAssociateId) REFERENCES Associate(AssociateId);

ALTER TABLE Contract ADD FOREIGN KEY (PolicyOwnerID) REFERENCES Customer(CustomerId);
ALTER TABLE Contract ADD FOREIGN KEY (PayerID) REFERENCES Customer(CustomerId);

ALTER TABLE ContractBenefit ADD FOREIGN KEY (ContractId,PolicyOwnerID,PayerID) REFERENCES Contract(ContractId,PolicyOwnerID,PayerID);

ALTER TABLE ContractBenefit_Customer ADD FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId);
ALTER TABLE ContractBenefit_Customer ADD FOREIGN KEY (ContractId,PolicyOwnerID,PayerID) REFERENCES Contract(ContractId,PolicyOwnerID,PayerID);
ALTER TABLE ContractBenefit_Customer ADD FOREIGN KEY (ContractBenefitId,ContractId,PolicyOwnerID,PayerID) REFERENCES ContractBenefit(ContractBenefitId,ContractId,PolicyOwnerID,PayerID);

ALTER TABLE ContractPremium ADD FOREIGN KEY (ContractBenefitId,ContractId,PolicyOwnerID,PayerID) REFERENCES ContractBenefit(ContractBenefitId,ContractId,PolicyOwnerID,PayerID);

ALTER TABLE Customer_Associate ADD FOREIGN KEY (AssociateId) REFERENCES Associate(AssociateId);
ALTER TABLE Customer_Associate ADD FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId);

ALTER TABLE Customer_Customer ADD FOREIGN KEY (MainCustomerId) REFERENCES Customer(CustomerId);
ALTER TABLE Customer_Customer ADD FOREIGN KEY (RelatedCustomerId) REFERENCES Customer(CustomerId);

ALTER TABLE ManagerContract ADD FOREIGN KEY (AssociateId) REFERENCES Associate(AssociateId);