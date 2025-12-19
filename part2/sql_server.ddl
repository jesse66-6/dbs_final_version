
CREATE TABLE Account
( 
	AccountId            integer  NOT NULL ,
	AccountName          varchar(100)  NOT NULL ,
	AccountType          varchar(30)  NOT NULL 
	CONSTRAINT CK_Customer_CustomerType_920614804
		CHECK  ( CustomerType in ('Individual', 'Trust', 'Company') ),
	AccountRegion        varchar(20)  NOT NULL ,
	CompanyCode          varchar(50)  NULL 
)
go



ALTER TABLE Account
	ADD CONSTRAINT XPKAccount PRIMARY KEY  CLUSTERED (AccountId ASC)
go



CREATE TABLE Account_Account
( 
	RelationType         varchar(20)  NULL 
	CONSTRAINT CK_AccountAccount_RelationType_1867148580
		CHECK  ( RelationType in ('GroupMaster', 'Flex Master', 'Member') ),
	MainAccountID        integer  NOT NULL ,
	MemberAccountID      integer  NOT NULL ,
	Id                   integer  NOT NULL 
)
go



ALTER TABLE Account_Account
	ADD CONSTRAINT XPKAccount_Account PRIMARY KEY  CLUSTERED (MainAccountID ASC,MemberAccountID ASC,Id ASC)
go



CREATE TABLE Account_AccountAdmin
( 
	AccountId            integer  NOT NULL ,
	AccountAdminId       integer  NOT NULL ,
	Id                   integer  NOT NULL 
)
go



ALTER TABLE Account_AccountAdmin
	ADD CONSTRAINT XPKAccount_AccountAdmin PRIMARY KEY  CLUSTERED (AccountId ASC,AccountAdminId ASC,Id ASC)
go



CREATE TABLE Account_BillingAccount
( 
	AccountId            integer  NOT NULL ,
	BillingAccountId     integer  NOT NULL ,
	Id                   integer  NOT NULL 
)
go



ALTER TABLE Account_BillingAccount
	ADD CONSTRAINT XPKAccount_BillingAccount PRIMARY KEY  CLUSTERED (AccountId ASC,BillingAccountId ASC,Id ASC)
go



CREATE TABLE Account_Customer
( 
	IsMoonlighting       bit  NULL ,
	AccountId            integer  NOT NULL ,
	CustomerId           integer  NOT NULL ,
	Id                   integer  NOT NULL 
)
go



ALTER TABLE Account_Customer
	ADD CONSTRAINT XPKAccountCustomer PRIMARY KEY  CLUSTERED (AccountId ASC,CustomerId ASC,Id ASC)
go



CREATE TABLE Account_ManagerContract
( 
	RoleType             varchar(20)  NULL 
	CONSTRAINT CK_AccountManagerContract_RoleType_1118062729
		CHECK  ( RoleType in ('Original Servicing', 'Servicing', 'Broker') ),
	AccountId            integer  NOT NULL ,
	ManagerContractId    integer  NOT NULL ,
	AssociateId          integer  NOT NULL ,
	Id                   integer  NOT NULL 
)
go



ALTER TABLE Account_ManagerContract
	ADD CONSTRAINT XPKAccountManagerContract PRIMARY KEY  CLUSTERED (Id ASC,AccountId ASC,ManagerContractId ASC,AssociateId ASC)
go



CREATE TABLE AccountAdmin
( 
	AccountAdminId       integer  NOT NULL ,
	AccountAdminName     varchar(50)  NOT NULL ,
	Expertise            varchar(50)  NULL 
	CONSTRAINT CK_AccountAdmin_Expertise_1806660661
		CHECK  ( Expertise in ('FSA', 'Life', 'A&H') )
)
go



ALTER TABLE AccountAdmin
	ADD CONSTRAINT XPKAccountAdmin PRIMARY KEY  CLUSTERED (AccountAdminId ASC)
go



CREATE TABLE AccountAlias
( 
	AccountAliasId       integer  NOT NULL ,
	OriginalDataType     varchar(50)  NULL ,
	DuplicateFlag        bit  NULL ,
	AccountId            integer  NOT NULL 
)
go



ALTER TABLE AccountAlias
	ADD CONSTRAINT XPKAccountAlias PRIMARY KEY  CLUSTERED (AccountAliasId ASC,AccountId ASC)
go



CREATE TABLE AccountMember
( 
	AccountMemberId      integer  NOT NULL ,
	AccountMemberName    varchar(50)  NULL ,
	IsCurrent            bit  NULL ,
	AccountId            integer  NOT NULL ,
	StartDate            datetime  NULL ,
	EndDate              datetime  NULL 
)
go



ALTER TABLE AccountMember
	ADD CONSTRAINT XPKAccountMember PRIMARY KEY  CLUSTERED (AccountMemberId ASC,AccountId ASC)
go



CREATE TABLE Associate
( 
	AssociateId          integer  NOT NULL ,
	LicenseState         varchar(10)  NOT NULL ,
	AssociateName        varchar(100)  NOT NULL 
)
go



ALTER TABLE Associate
	ADD CONSTRAINT XPKAssociate PRIMARY KEY  CLUSTERED (AssociateId ASC)
go



CREATE TABLE Associate_Associate
( 
	Id                   integer  NOT NULL ,
	RelationType         varchar(20)  NULL 
	CONSTRAINT CK_AssociateAssociate_RelationType_1622519112
		CHECK  ( RelationType in ('Broker', 'Recruiter', 'Upline', 'DSC', 'RSC') ),
	IsFormal             bit  NULL ,
	MainAssociateId      integer  NOT NULL ,
	RelatedAssociateId   integer  NOT NULL 
)
go



ALTER TABLE Associate_Associate
	ADD CONSTRAINT XPKAssociate_Associate PRIMARY KEY  CLUSTERED (Id ASC,MainAssociateId ASC,RelatedAssociateId ASC)
go



CREATE TABLE BillingAccount
( 
	BillingAccountId     integer  NOT NULL ,
	POBox                varchar(20)  NULL ,
	BusinessType         varchar(20)  NULL 
	CONSTRAINT CK_BillingAccount_BusinessType_1556320935
		CHECK  ( BusinessType in ('FSA', 'Life', 'A&H') ),
	EmployeeType         varchar(20)  NULL 
	CONSTRAINT CK_BillingAccount_EmployeeType_1338279336
		CHECK  ( EmployeeType in ('salaried', 'hourly', 'ALL') )
)
go



ALTER TABLE BillingAccount
	ADD CONSTRAINT XPKBillingAccount PRIMARY KEY  CLUSTERED (BillingAccountId ASC)
go



CREATE TABLE Contract
( 
	ContractId           integer  NOT NULL ,
	PolicyType           varchar(20)  NULL ,
	EffectiveDate        datetime  NULL ,
	PolicyOwnerID        integer  NOT NULL ,
	PayerID              integer  NOT NULL 
)
go



ALTER TABLE Contract
	ADD CONSTRAINT XPKContract PRIMARY KEY  CLUSTERED (ContractId ASC,PolicyOwnerID ASC,PayerID ASC)
go



CREATE TABLE ContractBenefit
( 
	ContractBenefitId    integer  NOT NULL ,
	BenefitType          varchar(20)  NULL ,
	CoverageAmount       money  NULL ,
	ContractId           integer  NOT NULL ,
	PolicyOwnerID        integer  NOT NULL ,
	PayerID              integer  NOT NULL 
)
go



ALTER TABLE ContractBenefit
	ADD CONSTRAINT XPKContractBenefit PRIMARY KEY  CLUSTERED (ContractBenefitId ASC,ContractId ASC,PolicyOwnerID ASC,PayerID ASC)
go



CREATE TABLE ContractBenefit_Customer
( 
	Id                   integer  NOT NULL ,
	CustomerId           integer  NOT NULL ,
	ContractId           integer  NOT NULL ,
	PolicyOwnerID        integer  NOT NULL ,
	PayerID              integer  NOT NULL ,
	ContractBenefitId    integer  NOT NULL 
)
go



ALTER TABLE ContractBenefit_Customer
	ADD CONSTRAINT XPKContractBenefit_Customer PRIMARY KEY  CLUSTERED (Id ASC,CustomerId ASC,ContractId ASC,PolicyOwnerID ASC,PayerID ASC,ContractBenefitId ASC)
go



CREATE TABLE ContractPremium
( 
	Period               datetime  NULL ,
	ContractPremiumId    integer  NOT NULL ,
	PremiumAmount        money  NULL ,
	ContractBenefitId    integer  NOT NULL ,
	ContractId           integer  NOT NULL ,
	PolicyOwnerID        integer  NOT NULL ,
	PayerID              integer  NOT NULL ,
	CalculationType      varchar(20)  NULL 
	CONSTRAINT CK_ContractPremium_CalculationType_1583708803
		CHECK  ( CalculationType in ('Commission', 'Production Credit') )
)
go



ALTER TABLE ContractPremium
	ADD CONSTRAINT XPKContractPremium PRIMARY KEY  CLUSTERED (ContractPremiumId ASC,ContractBenefitId ASC,ContractId ASC,PolicyOwnerID ASC,PayerID ASC)
go



CREATE TABLE Customer
( 
	CustomerId           integer  NOT NULL ,
	CustomerName         varchar(20)  NOT NULL ,
	CustomerType         varchar(20)  NOT NULL 
	CONSTRAINT CK_Customer_CustomerType_406867568
		CHECK  ( CustomerType in ('Individual', 'Trust', 'Company') )
)
go



ALTER TABLE Customer
	ADD CONSTRAINT XPKCustomer PRIMARY KEY  CLUSTERED (CustomerId ASC)
go



CREATE TABLE Customer_Associate
( 
	Id                   integer  NOT NULL ,
	RelationType         varchar(20)  NULL 
	CONSTRAINT CK_CustomerAssociate_RelationType_414460776
		CHECK  ( RelationType in ('Commission Beneficiary', 'Policy Sale') ),
	AssociateId          integer  NOT NULL ,
	CustomerId           integer  NOT NULL 
)
go



ALTER TABLE Customer_Associate
	ADD CONSTRAINT XPKCustomer_Associate PRIMARY KEY  CLUSTERED (Id ASC,AssociateId ASC,CustomerId ASC)
go



CREATE TABLE Customer_Customer
( 
	Id                   integer  NOT NULL ,
	RelationType         varchar(20)  NULL 
	CONSTRAINT CK_CustomerCustomer_RelationType_716602073
		CHECK  ( RelationType in ('Family', 'Trust', 'PolicyOwner', 'Beneficiary') ),
	MainCustomerId       integer  NOT NULL ,
	RelatedCustomerId    integer  NOT NULL 
)
go



ALTER TABLE Customer_Customer
	ADD CONSTRAINT XPKCustomer_Customer PRIMARY KEY  CLUSTERED (Id ASC,MainCustomerId ASC,RelatedCustomerId ASC)
go



CREATE TABLE ManagerContract
( 
	ManagerContractId    integer  NOT NULL ,
	SitCode              varchar(20)  NULL ,
	SitCodeType          varchar(20)  NULL 
	CONSTRAINT CK_ManagerContract_SitCodeType_832142247
		CHECK  ( SitCodeType in ('Formal', 'Informal') ),
	WritingNumber        varchar(30)  NULL ,
	AssociateId          integer  NOT NULL 
)
go



ALTER TABLE ManagerContract
	ADD CONSTRAINT XPKManagerContract PRIMARY KEY  CLUSTERED (ManagerContractId ASC,AssociateId ASC)
go




ALTER TABLE Account_Account
	ADD CONSTRAINT R_9 FOREIGN KEY (MainAccountID) REFERENCES Account(AccountId)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE Account_Account
	ADD CONSTRAINT R_10 FOREIGN KEY (MemberAccountID) REFERENCES Account(AccountId)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE Account_AccountAdmin
	ADD CONSTRAINT R_13 FOREIGN KEY (AccountId) REFERENCES Account(AccountId)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE Account_AccountAdmin
	ADD CONSTRAINT R_15 FOREIGN KEY (AccountAdminId) REFERENCES AccountAdmin(AccountAdminId)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE Account_BillingAccount
	ADD CONSTRAINT R_11 FOREIGN KEY (AccountId) REFERENCES Account(AccountId)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE Account_BillingAccount
	ADD CONSTRAINT R_12 FOREIGN KEY (BillingAccountId) REFERENCES BillingAccount(BillingAccountId)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE Account_Customer
	ADD CONSTRAINT R_18 FOREIGN KEY (AccountId) REFERENCES Account(AccountId)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE Account_Customer
	ADD CONSTRAINT R_19 FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE Account_ManagerContract
	ADD CONSTRAINT R_16 FOREIGN KEY (AccountId) REFERENCES Account(AccountId)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE Account_ManagerContract
	ADD CONSTRAINT R_17 FOREIGN KEY (ManagerContractId,AssociateId) REFERENCES ManagerContract(ManagerContractId,AssociateId)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE AccountAlias
	ADD CONSTRAINT R_2 FOREIGN KEY (AccountId) REFERENCES Account(AccountId)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE AccountMember
	ADD CONSTRAINT R_1 FOREIGN KEY (AccountId) REFERENCES Account(AccountId)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE Associate_Associate
	ADD CONSTRAINT R_22 FOREIGN KEY (MainAssociateId) REFERENCES Associate(AssociateId)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE Associate_Associate
	ADD CONSTRAINT R_23 FOREIGN KEY (RelatedAssociateId) REFERENCES Associate(AssociateId)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE Contract
	ADD CONSTRAINT R_4 FOREIGN KEY (PolicyOwnerID) REFERENCES Customer(CustomerId)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE Contract
	ADD CONSTRAINT R_6 FOREIGN KEY (PayerID) REFERENCES Customer(CustomerId)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE ContractBenefit
	ADD CONSTRAINT R_7 FOREIGN KEY (ContractId,PolicyOwnerID,PayerID) REFERENCES Contract(ContractId,PolicyOwnerID,PayerID)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE ContractBenefit_Customer
	ADD CONSTRAINT R_26 FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE ContractBenefit_Customer
	ADD CONSTRAINT R_27 FOREIGN KEY (ContractId,PolicyOwnerID,PayerID) REFERENCES Contract(ContractId,PolicyOwnerID,PayerID)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE ContractBenefit_Customer
	ADD CONSTRAINT R_28 FOREIGN KEY (ContractBenefitId,ContractId,PolicyOwnerID,PayerID) REFERENCES ContractBenefit(ContractBenefitId,ContractId,PolicyOwnerID,PayerID)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE ContractPremium
	ADD CONSTRAINT R_8 FOREIGN KEY (ContractBenefitId,ContractId,PolicyOwnerID,PayerID) REFERENCES ContractBenefit(ContractBenefitId,ContractId,PolicyOwnerID,PayerID)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE Customer_Associate
	ADD CONSTRAINT R_20 FOREIGN KEY (AssociateId) REFERENCES Associate(AssociateId)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE Customer_Associate
	ADD CONSTRAINT R_21 FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE Customer_Customer
	ADD CONSTRAINT R_24 FOREIGN KEY (MainCustomerId) REFERENCES Customer(CustomerId)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE Customer_Customer
	ADD CONSTRAINT R_25 FOREIGN KEY (RelatedCustomerId) REFERENCES Customer(CustomerId)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




ALTER TABLE ManagerContract
	ADD CONSTRAINT R_3 FOREIGN KEY (AssociateId) REFERENCES Associate(AssociateId)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go




CREATE TRIGGER tD_Account ON Account FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Account */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Account  AccountMember on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00082de9", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="AccountMember"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="AccountId" */
    IF EXISTS (
      SELECT * FROM deleted,AccountMember
      WHERE
        /*  %JoinFKPK(AccountMember,deleted," = "," AND") */
        AccountMember.AccountId = deleted.AccountId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Account because AccountMember exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Account  AccountAlias on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="AccountAlias"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="AccountId" */
    IF EXISTS (
      SELECT * FROM deleted,AccountAlias
      WHERE
        /*  %JoinFKPK(AccountAlias,deleted," = "," AND") */
        AccountAlias.AccountId = deleted.AccountId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Account because AccountAlias exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Account  Account_Account on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="Account_Account"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="MainAccountID" */
    IF EXISTS (
      SELECT * FROM deleted,Account_Account
      WHERE
        /*  %JoinFKPK(Account_Account,deleted," = "," AND") */
        Account_Account.MainAccountID = deleted.AccountId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Account because Account_Account exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Account  Account_Account on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="Account_Account"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="MemberAccountID" */
    IF EXISTS (
      SELECT * FROM deleted,Account_Account
      WHERE
        /*  %JoinFKPK(Account_Account,deleted," = "," AND") */
        Account_Account.MemberAccountID = deleted.AccountId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Account because Account_Account exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Account  Account_BillingAccount on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="Account_BillingAccount"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="AccountId" */
    IF EXISTS (
      SELECT * FROM deleted,Account_BillingAccount
      WHERE
        /*  %JoinFKPK(Account_BillingAccount,deleted," = "," AND") */
        Account_BillingAccount.AccountId = deleted.AccountId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Account because Account_BillingAccount exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Account  Account_AccountAdmin on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="Account_AccountAdmin"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="AccountId" */
    IF EXISTS (
      SELECT * FROM deleted,Account_AccountAdmin
      WHERE
        /*  %JoinFKPK(Account_AccountAdmin,deleted," = "," AND") */
        Account_AccountAdmin.AccountId = deleted.AccountId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Account because Account_AccountAdmin exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Account  Account_ManagerContract on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="Account_ManagerContract"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_16", FK_COLUMNS="AccountId" */
    IF EXISTS (
      SELECT * FROM deleted,Account_ManagerContract
      WHERE
        /*  %JoinFKPK(Account_ManagerContract,deleted," = "," AND") */
        Account_ManagerContract.AccountId = deleted.AccountId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Account because Account_ManagerContract exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Account  Account_Customer on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="Account_Customer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_18", FK_COLUMNS="AccountId" */
    IF EXISTS (
      SELECT * FROM deleted,Account_Customer
      WHERE
        /*  %JoinFKPK(Account_Customer,deleted," = "," AND") */
        Account_Customer.AccountId = deleted.AccountId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Account because Account_Customer exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go


CREATE TRIGGER tU_Account ON Account FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Account */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insAccountId integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Account  AccountMember on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="000902f3", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="AccountMember"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="AccountId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(AccountId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,AccountMember
      WHERE
        /*  %JoinFKPK(AccountMember,deleted," = "," AND") */
        AccountMember.AccountId = deleted.AccountId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Account because AccountMember exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Account  AccountAlias on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="AccountAlias"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="AccountId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(AccountId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,AccountAlias
      WHERE
        /*  %JoinFKPK(AccountAlias,deleted," = "," AND") */
        AccountAlias.AccountId = deleted.AccountId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Account because AccountAlias exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Account  Account_Account on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="Account_Account"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="MainAccountID" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(AccountId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Account_Account
      WHERE
        /*  %JoinFKPK(Account_Account,deleted," = "," AND") */
        Account_Account.MainAccountID = deleted.AccountId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Account because Account_Account exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Account  Account_Account on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="Account_Account"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="MemberAccountID" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(AccountId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Account_Account
      WHERE
        /*  %JoinFKPK(Account_Account,deleted," = "," AND") */
        Account_Account.MemberAccountID = deleted.AccountId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Account because Account_Account exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Account  Account_BillingAccount on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="Account_BillingAccount"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="AccountId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(AccountId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Account_BillingAccount
      WHERE
        /*  %JoinFKPK(Account_BillingAccount,deleted," = "," AND") */
        Account_BillingAccount.AccountId = deleted.AccountId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Account because Account_BillingAccount exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Account  Account_AccountAdmin on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="Account_AccountAdmin"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="AccountId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(AccountId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Account_AccountAdmin
      WHERE
        /*  %JoinFKPK(Account_AccountAdmin,deleted," = "," AND") */
        Account_AccountAdmin.AccountId = deleted.AccountId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Account because Account_AccountAdmin exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Account  Account_ManagerContract on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="Account_ManagerContract"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_16", FK_COLUMNS="AccountId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(AccountId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Account_ManagerContract
      WHERE
        /*  %JoinFKPK(Account_ManagerContract,deleted," = "," AND") */
        Account_ManagerContract.AccountId = deleted.AccountId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Account because Account_ManagerContract exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Account  Account_Customer on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="Account_Customer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_18", FK_COLUMNS="AccountId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(AccountId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Account_Customer
      WHERE
        /*  %JoinFKPK(Account_Customer,deleted," = "," AND") */
        Account_Customer.AccountId = deleted.AccountId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Account because Account_Customer exists.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go




CREATE TRIGGER tD_Account_Account ON Account_Account FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Account_Account */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Account  Account_Account on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="0002762a", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="Account_Account"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="MainAccountID" */
    IF EXISTS (SELECT * FROM deleted,Account
      WHERE
        /* %JoinFKPK(deleted,Account," = "," AND") */
        deleted.MainAccountID = Account.AccountId AND
        NOT EXISTS (
          SELECT * FROM Account_Account
          WHERE
            /* %JoinFKPK(Account_Account,Account," = "," AND") */
            Account_Account.MainAccountID = Account.AccountId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Account_Account because Account exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Account  Account_Account on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="Account_Account"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="MemberAccountID" */
    IF EXISTS (SELECT * FROM deleted,Account
      WHERE
        /* %JoinFKPK(deleted,Account," = "," AND") */
        deleted.MemberAccountID = Account.AccountId AND
        NOT EXISTS (
          SELECT * FROM Account_Account
          WHERE
            /* %JoinFKPK(Account_Account,Account," = "," AND") */
            Account_Account.MemberAccountID = Account.AccountId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Account_Account because Account exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go


CREATE TRIGGER tU_Account_Account ON Account_Account FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Account_Account */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insMainAccountID integer, 
           @insMemberAccountID integer, 
           @insId integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Account  Account_Account on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0002969a", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="Account_Account"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="MainAccountID" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(MainAccountID)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Account
        WHERE
          /* %JoinFKPK(inserted,Account) */
          inserted.MainAccountID = Account.AccountId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Account_Account because Account does not exist.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Account  Account_Account on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="Account_Account"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="MemberAccountID" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(MemberAccountID)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Account
        WHERE
          /* %JoinFKPK(inserted,Account) */
          inserted.MemberAccountID = Account.AccountId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Account_Account because Account does not exist.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go




CREATE TRIGGER tD_Account_AccountAdmin ON Account_AccountAdmin FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Account_AccountAdmin */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Account  Account_AccountAdmin on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00029655", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="Account_AccountAdmin"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="AccountId" */
    IF EXISTS (SELECT * FROM deleted,Account
      WHERE
        /* %JoinFKPK(deleted,Account," = "," AND") */
        deleted.AccountId = Account.AccountId AND
        NOT EXISTS (
          SELECT * FROM Account_AccountAdmin
          WHERE
            /* %JoinFKPK(Account_AccountAdmin,Account," = "," AND") */
            Account_AccountAdmin.AccountId = Account.AccountId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Account_AccountAdmin because Account exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* AccountAdmin  Account_AccountAdmin on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="AccountAdmin"
    CHILD_OWNER="", CHILD_TABLE="Account_AccountAdmin"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="AccountAdminId" */
    IF EXISTS (SELECT * FROM deleted,AccountAdmin
      WHERE
        /* %JoinFKPK(deleted,AccountAdmin," = "," AND") */
        deleted.AccountAdminId = AccountAdmin.AccountAdminId AND
        NOT EXISTS (
          SELECT * FROM Account_AccountAdmin
          WHERE
            /* %JoinFKPK(Account_AccountAdmin,AccountAdmin," = "," AND") */
            Account_AccountAdmin.AccountAdminId = AccountAdmin.AccountAdminId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Account_AccountAdmin because AccountAdmin exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go


CREATE TRIGGER tU_Account_AccountAdmin ON Account_AccountAdmin FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Account_AccountAdmin */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insAccountId integer, 
           @insAccountAdminId integer, 
           @insId integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Account  Account_AccountAdmin on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0002bb9e", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="Account_AccountAdmin"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="AccountId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(AccountId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Account
        WHERE
          /* %JoinFKPK(inserted,Account) */
          inserted.AccountId = Account.AccountId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Account_AccountAdmin because Account does not exist.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* AccountAdmin  Account_AccountAdmin on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="AccountAdmin"
    CHILD_OWNER="", CHILD_TABLE="Account_AccountAdmin"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="AccountAdminId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(AccountAdminId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,AccountAdmin
        WHERE
          /* %JoinFKPK(inserted,AccountAdmin) */
          inserted.AccountAdminId = AccountAdmin.AccountAdminId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Account_AccountAdmin because AccountAdmin does not exist.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go




CREATE TRIGGER tD_Account_BillingAccount ON Account_BillingAccount FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Account_BillingAccount */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Account  Account_BillingAccount on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="0002b989", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="Account_BillingAccount"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="AccountId" */
    IF EXISTS (SELECT * FROM deleted,Account
      WHERE
        /* %JoinFKPK(deleted,Account," = "," AND") */
        deleted.AccountId = Account.AccountId AND
        NOT EXISTS (
          SELECT * FROM Account_BillingAccount
          WHERE
            /* %JoinFKPK(Account_BillingAccount,Account," = "," AND") */
            Account_BillingAccount.AccountId = Account.AccountId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Account_BillingAccount because Account exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* BillingAccount  Account_BillingAccount on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="BillingAccount"
    CHILD_OWNER="", CHILD_TABLE="Account_BillingAccount"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="BillingAccountId" */
    IF EXISTS (SELECT * FROM deleted,BillingAccount
      WHERE
        /* %JoinFKPK(deleted,BillingAccount," = "," AND") */
        deleted.BillingAccountId = BillingAccount.BillingAccountId AND
        NOT EXISTS (
          SELECT * FROM Account_BillingAccount
          WHERE
            /* %JoinFKPK(Account_BillingAccount,BillingAccount," = "," AND") */
            Account_BillingAccount.BillingAccountId = BillingAccount.BillingAccountId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Account_BillingAccount because BillingAccount exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go


CREATE TRIGGER tU_Account_BillingAccount ON Account_BillingAccount FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Account_BillingAccount */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insAccountId integer, 
           @insBillingAccountId integer, 
           @insId integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Account  Account_BillingAccount on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0002c343", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="Account_BillingAccount"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="AccountId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(AccountId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Account
        WHERE
          /* %JoinFKPK(inserted,Account) */
          inserted.AccountId = Account.AccountId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Account_BillingAccount because Account does not exist.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* BillingAccount  Account_BillingAccount on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="BillingAccount"
    CHILD_OWNER="", CHILD_TABLE="Account_BillingAccount"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="BillingAccountId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(BillingAccountId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,BillingAccount
        WHERE
          /* %JoinFKPK(inserted,BillingAccount) */
          inserted.BillingAccountId = BillingAccount.BillingAccountId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Account_BillingAccount because BillingAccount does not exist.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go




CREATE TRIGGER tD_Account_Customer ON Account_Customer FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Account_Customer */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Account  Account_Customer on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="000275b3", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="Account_Customer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_18", FK_COLUMNS="AccountId" */
    IF EXISTS (SELECT * FROM deleted,Account
      WHERE
        /* %JoinFKPK(deleted,Account," = "," AND") */
        deleted.AccountId = Account.AccountId AND
        NOT EXISTS (
          SELECT * FROM Account_Customer
          WHERE
            /* %JoinFKPK(Account_Customer,Account," = "," AND") */
            Account_Customer.AccountId = Account.AccountId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Account_Customer because Account exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Customer  Account_Customer on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="Account_Customer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_19", FK_COLUMNS="CustomerId" */
    IF EXISTS (SELECT * FROM deleted,Customer
      WHERE
        /* %JoinFKPK(deleted,Customer," = "," AND") */
        deleted.CustomerId = Customer.CustomerId AND
        NOT EXISTS (
          SELECT * FROM Account_Customer
          WHERE
            /* %JoinFKPK(Account_Customer,Customer," = "," AND") */
            Account_Customer.CustomerId = Customer.CustomerId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Account_Customer because Customer exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go


CREATE TRIGGER tU_Account_Customer ON Account_Customer FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Account_Customer */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insAccountId integer, 
           @insCustomerId integer, 
           @insId integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Account  Account_Customer on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0002976b", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="Account_Customer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_18", FK_COLUMNS="AccountId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(AccountId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Account
        WHERE
          /* %JoinFKPK(inserted,Account) */
          inserted.AccountId = Account.AccountId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Account_Customer because Account does not exist.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Customer  Account_Customer on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="Account_Customer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_19", FK_COLUMNS="CustomerId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(CustomerId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Customer
        WHERE
          /* %JoinFKPK(inserted,Customer) */
          inserted.CustomerId = Customer.CustomerId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Account_Customer because Customer does not exist.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go




CREATE TRIGGER tD_Account_ManagerContract ON Account_ManagerContract FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Account_ManagerContract */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Account  Account_ManagerContract on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="0002f5b4", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="Account_ManagerContract"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_16", FK_COLUMNS="AccountId" */
    IF EXISTS (SELECT * FROM deleted,Account
      WHERE
        /* %JoinFKPK(deleted,Account," = "," AND") */
        deleted.AccountId = Account.AccountId AND
        NOT EXISTS (
          SELECT * FROM Account_ManagerContract
          WHERE
            /* %JoinFKPK(Account_ManagerContract,Account," = "," AND") */
            Account_ManagerContract.AccountId = Account.AccountId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Account_ManagerContract because Account exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* ManagerContract  Account_ManagerContract on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="ManagerContract"
    CHILD_OWNER="", CHILD_TABLE="Account_ManagerContract"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="ManagerContractId""AssociateId" */
    IF EXISTS (SELECT * FROM deleted,ManagerContract
      WHERE
        /* %JoinFKPK(deleted,ManagerContract," = "," AND") */
        deleted.ManagerContractId = ManagerContract.ManagerContractId AND
        deleted.AssociateId = ManagerContract.AssociateId AND
        NOT EXISTS (
          SELECT * FROM Account_ManagerContract
          WHERE
            /* %JoinFKPK(Account_ManagerContract,ManagerContract," = "," AND") */
            Account_ManagerContract.ManagerContractId = ManagerContract.ManagerContractId AND
            Account_ManagerContract.AssociateId = ManagerContract.AssociateId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Account_ManagerContract because ManagerContract exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go


CREATE TRIGGER tU_Account_ManagerContract ON Account_ManagerContract FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Account_ManagerContract */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insId integer, 
           @insAccountId integer, 
           @insManagerContractId integer, 
           @insAssociateId integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Account  Account_ManagerContract on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0003031c", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="Account_ManagerContract"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_16", FK_COLUMNS="AccountId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(AccountId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Account
        WHERE
          /* %JoinFKPK(inserted,Account) */
          inserted.AccountId = Account.AccountId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Account_ManagerContract because Account does not exist.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* ManagerContract  Account_ManagerContract on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="ManagerContract"
    CHILD_OWNER="", CHILD_TABLE="Account_ManagerContract"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="ManagerContractId""AssociateId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(ManagerContractId) OR
    UPDATE(AssociateId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,ManagerContract
        WHERE
          /* %JoinFKPK(inserted,ManagerContract) */
          inserted.ManagerContractId = ManagerContract.ManagerContractId and
          inserted.AssociateId = ManagerContract.AssociateId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Account_ManagerContract because ManagerContract does not exist.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go




CREATE TRIGGER tD_AccountAdmin ON AccountAdmin FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on AccountAdmin */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* AccountAdmin  Account_AccountAdmin on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="000117f5", PARENT_OWNER="", PARENT_TABLE="AccountAdmin"
    CHILD_OWNER="", CHILD_TABLE="Account_AccountAdmin"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="AccountAdminId" */
    IF EXISTS (
      SELECT * FROM deleted,Account_AccountAdmin
      WHERE
        /*  %JoinFKPK(Account_AccountAdmin,deleted," = "," AND") */
        Account_AccountAdmin.AccountAdminId = deleted.AccountAdminId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete AccountAdmin because Account_AccountAdmin exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go


CREATE TRIGGER tU_AccountAdmin ON AccountAdmin FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on AccountAdmin */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insAccountAdminId integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* AccountAdmin  Account_AccountAdmin on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00013da1", PARENT_OWNER="", PARENT_TABLE="AccountAdmin"
    CHILD_OWNER="", CHILD_TABLE="Account_AccountAdmin"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_15", FK_COLUMNS="AccountAdminId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(AccountAdminId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Account_AccountAdmin
      WHERE
        /*  %JoinFKPK(Account_AccountAdmin,deleted," = "," AND") */
        Account_AccountAdmin.AccountAdminId = deleted.AccountAdminId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update AccountAdmin because Account_AccountAdmin exists.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go




CREATE TRIGGER tD_AccountAlias ON AccountAlias FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on AccountAlias */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Account  AccountAlias on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="000132ed", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="AccountAlias"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="AccountId" */
    IF EXISTS (SELECT * FROM deleted,Account
      WHERE
        /* %JoinFKPK(deleted,Account," = "," AND") */
        deleted.AccountId = Account.AccountId AND
        NOT EXISTS (
          SELECT * FROM AccountAlias
          WHERE
            /* %JoinFKPK(AccountAlias,Account," = "," AND") */
            AccountAlias.AccountId = Account.AccountId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last AccountAlias because Account exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go


CREATE TRIGGER tU_AccountAlias ON AccountAlias FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on AccountAlias */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insAccountAliasId integer, 
           @insAccountId integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Account  AccountAlias on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00014ed2", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="AccountAlias"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="AccountId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(AccountId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Account
        WHERE
          /* %JoinFKPK(inserted,Account) */
          inserted.AccountId = Account.AccountId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update AccountAlias because Account does not exist.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go




CREATE TRIGGER tD_AccountMember ON AccountMember FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on AccountMember */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Account  AccountMember on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="000135a4", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="AccountMember"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="AccountId" */
    IF EXISTS (SELECT * FROM deleted,Account
      WHERE
        /* %JoinFKPK(deleted,Account," = "," AND") */
        deleted.AccountId = Account.AccountId AND
        NOT EXISTS (
          SELECT * FROM AccountMember
          WHERE
            /* %JoinFKPK(AccountMember,Account," = "," AND") */
            AccountMember.AccountId = Account.AccountId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last AccountMember because Account exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go


CREATE TRIGGER tU_AccountMember ON AccountMember FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on AccountMember */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insAccountMemberId integer, 
           @insAccountId integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Account  AccountMember on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00014c9e", PARENT_OWNER="", PARENT_TABLE="Account"
    CHILD_OWNER="", CHILD_TABLE="AccountMember"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_1", FK_COLUMNS="AccountId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(AccountId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Account
        WHERE
          /* %JoinFKPK(inserted,Account) */
          inserted.AccountId = Account.AccountId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update AccountMember because Account does not exist.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go




CREATE TRIGGER tD_Associate ON Associate FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Associate */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Associate  ManagerContract on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="000440e0", PARENT_OWNER="", PARENT_TABLE="Associate"
    CHILD_OWNER="", CHILD_TABLE="ManagerContract"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="AssociateId" */
    IF EXISTS (
      SELECT * FROM deleted,ManagerContract
      WHERE
        /*  %JoinFKPK(ManagerContract,deleted," = "," AND") */
        ManagerContract.AssociateId = deleted.AssociateId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Associate because ManagerContract exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Associate  Customer_Associate on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Associate"
    CHILD_OWNER="", CHILD_TABLE="Customer_Associate"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_20", FK_COLUMNS="AssociateId" */
    IF EXISTS (
      SELECT * FROM deleted,Customer_Associate
      WHERE
        /*  %JoinFKPK(Customer_Associate,deleted," = "," AND") */
        Customer_Associate.AssociateId = deleted.AssociateId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Associate because Customer_Associate exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Associate  Associate_Associate on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Associate"
    CHILD_OWNER="", CHILD_TABLE="Associate_Associate"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_22", FK_COLUMNS="MainAssociateId" */
    IF EXISTS (
      SELECT * FROM deleted,Associate_Associate
      WHERE
        /*  %JoinFKPK(Associate_Associate,deleted," = "," AND") */
        Associate_Associate.MainAssociateId = deleted.AssociateId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Associate because Associate_Associate exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Associate  Associate_Associate on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Associate"
    CHILD_OWNER="", CHILD_TABLE="Associate_Associate"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_23", FK_COLUMNS="RelatedAssociateId" */
    IF EXISTS (
      SELECT * FROM deleted,Associate_Associate
      WHERE
        /*  %JoinFKPK(Associate_Associate,deleted," = "," AND") */
        Associate_Associate.RelatedAssociateId = deleted.AssociateId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Associate because Associate_Associate exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go


CREATE TRIGGER tU_Associate ON Associate FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Associate */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insAssociateId integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Associate  ManagerContract on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0004a0fd", PARENT_OWNER="", PARENT_TABLE="Associate"
    CHILD_OWNER="", CHILD_TABLE="ManagerContract"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="AssociateId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(AssociateId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,ManagerContract
      WHERE
        /*  %JoinFKPK(ManagerContract,deleted," = "," AND") */
        ManagerContract.AssociateId = deleted.AssociateId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Associate because ManagerContract exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Associate  Customer_Associate on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Associate"
    CHILD_OWNER="", CHILD_TABLE="Customer_Associate"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_20", FK_COLUMNS="AssociateId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(AssociateId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Customer_Associate
      WHERE
        /*  %JoinFKPK(Customer_Associate,deleted," = "," AND") */
        Customer_Associate.AssociateId = deleted.AssociateId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Associate because Customer_Associate exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Associate  Associate_Associate on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Associate"
    CHILD_OWNER="", CHILD_TABLE="Associate_Associate"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_22", FK_COLUMNS="MainAssociateId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(AssociateId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Associate_Associate
      WHERE
        /*  %JoinFKPK(Associate_Associate,deleted," = "," AND") */
        Associate_Associate.MainAssociateId = deleted.AssociateId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Associate because Associate_Associate exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Associate  Associate_Associate on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Associate"
    CHILD_OWNER="", CHILD_TABLE="Associate_Associate"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_23", FK_COLUMNS="RelatedAssociateId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(AssociateId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Associate_Associate
      WHERE
        /*  %JoinFKPK(Associate_Associate,deleted," = "," AND") */
        Associate_Associate.RelatedAssociateId = deleted.AssociateId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Associate because Associate_Associate exists.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go




CREATE TRIGGER tD_Associate_Associate ON Associate_Associate FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Associate_Associate */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Associate  Associate_Associate on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="0002ae69", PARENT_OWNER="", PARENT_TABLE="Associate"
    CHILD_OWNER="", CHILD_TABLE="Associate_Associate"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_22", FK_COLUMNS="MainAssociateId" */
    IF EXISTS (SELECT * FROM deleted,Associate
      WHERE
        /* %JoinFKPK(deleted,Associate," = "," AND") */
        deleted.MainAssociateId = Associate.AssociateId AND
        NOT EXISTS (
          SELECT * FROM Associate_Associate
          WHERE
            /* %JoinFKPK(Associate_Associate,Associate," = "," AND") */
            Associate_Associate.MainAssociateId = Associate.AssociateId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Associate_Associate because Associate exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Associate  Associate_Associate on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Associate"
    CHILD_OWNER="", CHILD_TABLE="Associate_Associate"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_23", FK_COLUMNS="RelatedAssociateId" */
    IF EXISTS (SELECT * FROM deleted,Associate
      WHERE
        /* %JoinFKPK(deleted,Associate," = "," AND") */
        deleted.RelatedAssociateId = Associate.AssociateId AND
        NOT EXISTS (
          SELECT * FROM Associate_Associate
          WHERE
            /* %JoinFKPK(Associate_Associate,Associate," = "," AND") */
            Associate_Associate.RelatedAssociateId = Associate.AssociateId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Associate_Associate because Associate exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go


CREATE TRIGGER tU_Associate_Associate ON Associate_Associate FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Associate_Associate */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insId integer, 
           @insMainAssociateId integer, 
           @insRelatedAssociateId integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Associate  Associate_Associate on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0002d10c", PARENT_OWNER="", PARENT_TABLE="Associate"
    CHILD_OWNER="", CHILD_TABLE="Associate_Associate"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_22", FK_COLUMNS="MainAssociateId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(MainAssociateId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Associate
        WHERE
          /* %JoinFKPK(inserted,Associate) */
          inserted.MainAssociateId = Associate.AssociateId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Associate_Associate because Associate does not exist.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Associate  Associate_Associate on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Associate"
    CHILD_OWNER="", CHILD_TABLE="Associate_Associate"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_23", FK_COLUMNS="RelatedAssociateId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(RelatedAssociateId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Associate
        WHERE
          /* %JoinFKPK(inserted,Associate) */
          inserted.RelatedAssociateId = Associate.AssociateId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Associate_Associate because Associate does not exist.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go




CREATE TRIGGER tD_BillingAccount ON BillingAccount FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on BillingAccount */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* BillingAccount  Account_BillingAccount on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00012bfb", PARENT_OWNER="", PARENT_TABLE="BillingAccount"
    CHILD_OWNER="", CHILD_TABLE="Account_BillingAccount"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="BillingAccountId" */
    IF EXISTS (
      SELECT * FROM deleted,Account_BillingAccount
      WHERE
        /*  %JoinFKPK(Account_BillingAccount,deleted," = "," AND") */
        Account_BillingAccount.BillingAccountId = deleted.BillingAccountId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete BillingAccount because Account_BillingAccount exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go


CREATE TRIGGER tU_BillingAccount ON BillingAccount FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on BillingAccount */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insBillingAccountId integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* BillingAccount  Account_BillingAccount on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00014756", PARENT_OWNER="", PARENT_TABLE="BillingAccount"
    CHILD_OWNER="", CHILD_TABLE="Account_BillingAccount"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="BillingAccountId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(BillingAccountId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Account_BillingAccount
      WHERE
        /*  %JoinFKPK(Account_BillingAccount,deleted," = "," AND") */
        Account_BillingAccount.BillingAccountId = deleted.BillingAccountId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update BillingAccount because Account_BillingAccount exists.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go




CREATE TRIGGER tD_Contract ON Contract FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Contract */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Contract  ContractBenefit on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0004d5af", PARENT_OWNER="", PARENT_TABLE="Contract"
    CHILD_OWNER="", CHILD_TABLE="ContractBenefit"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="ContractId""PolicyOwnerID""PayerID" */
    IF EXISTS (
      SELECT * FROM deleted,ContractBenefit
      WHERE
        /*  %JoinFKPK(ContractBenefit,deleted," = "," AND") */
        ContractBenefit.ContractId = deleted.ContractId AND
        ContractBenefit.PolicyOwnerID = deleted.PolicyOwnerID AND
        ContractBenefit.PayerID = deleted.PayerID
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Contract because ContractBenefit exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Contract  ContractBenefit_Customer on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Contract"
    CHILD_OWNER="", CHILD_TABLE="ContractBenefit_Customer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_27", FK_COLUMNS="ContractId""PolicyOwnerID""PayerID" */
    IF EXISTS (
      SELECT * FROM deleted,ContractBenefit_Customer
      WHERE
        /*  %JoinFKPK(ContractBenefit_Customer,deleted," = "," AND") */
        ContractBenefit_Customer.ContractId = deleted.ContractId AND
        ContractBenefit_Customer.PolicyOwnerID = deleted.PolicyOwnerID AND
        ContractBenefit_Customer.PayerID = deleted.PayerID
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Contract because ContractBenefit_Customer exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Customer  Contract on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="Contract"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="PolicyOwnerID" */
    IF EXISTS (SELECT * FROM deleted,Customer
      WHERE
        /* %JoinFKPK(deleted,Customer," = "," AND") */
        deleted.PolicyOwnerID = Customer.CustomerId AND
        NOT EXISTS (
          SELECT * FROM Contract
          WHERE
            /* %JoinFKPK(Contract,Customer," = "," AND") */
            Contract.PolicyOwnerID = Customer.CustomerId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Contract because Customer exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Customer  Contract on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="Contract"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="PayerID" */
    IF EXISTS (SELECT * FROM deleted,Customer
      WHERE
        /* %JoinFKPK(deleted,Customer," = "," AND") */
        deleted.PayerID = Customer.CustomerId AND
        NOT EXISTS (
          SELECT * FROM Contract
          WHERE
            /* %JoinFKPK(Contract,Customer," = "," AND") */
            Contract.PayerID = Customer.CustomerId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Contract because Customer exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go


CREATE TRIGGER tU_Contract ON Contract FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Contract */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insContractId integer, 
           @insPolicyOwnerID integer, 
           @insPayerID integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Contract  ContractBenefit on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00059271", PARENT_OWNER="", PARENT_TABLE="Contract"
    CHILD_OWNER="", CHILD_TABLE="ContractBenefit"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="ContractId""PolicyOwnerID""PayerID" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(ContractId) OR
    UPDATE(PolicyOwnerID) OR
    UPDATE(PayerID)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,ContractBenefit
      WHERE
        /*  %JoinFKPK(ContractBenefit,deleted," = "," AND") */
        ContractBenefit.ContractId = deleted.ContractId AND
        ContractBenefit.PolicyOwnerID = deleted.PolicyOwnerID AND
        ContractBenefit.PayerID = deleted.PayerID
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Contract because ContractBenefit exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Contract  ContractBenefit_Customer on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Contract"
    CHILD_OWNER="", CHILD_TABLE="ContractBenefit_Customer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_27", FK_COLUMNS="ContractId""PolicyOwnerID""PayerID" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(ContractId) OR
    UPDATE(PolicyOwnerID) OR
    UPDATE(PayerID)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,ContractBenefit_Customer
      WHERE
        /*  %JoinFKPK(ContractBenefit_Customer,deleted," = "," AND") */
        ContractBenefit_Customer.ContractId = deleted.ContractId AND
        ContractBenefit_Customer.PolicyOwnerID = deleted.PolicyOwnerID AND
        ContractBenefit_Customer.PayerID = deleted.PayerID
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Contract because ContractBenefit_Customer exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Customer  Contract on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="Contract"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="PolicyOwnerID" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(PolicyOwnerID)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Customer
        WHERE
          /* %JoinFKPK(inserted,Customer) */
          inserted.PolicyOwnerID = Customer.CustomerId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Contract because Customer does not exist.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Customer  Contract on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="Contract"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="PayerID" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(PayerID)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Customer
        WHERE
          /* %JoinFKPK(inserted,Customer) */
          inserted.PayerID = Customer.CustomerId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Contract because Customer does not exist.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go




CREATE TRIGGER tD_ContractBenefit ON ContractBenefit FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on ContractBenefit */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* ContractBenefit  ContractPremium on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0004a07b", PARENT_OWNER="", PARENT_TABLE="ContractBenefit"
    CHILD_OWNER="", CHILD_TABLE="ContractPremium"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="ContractBenefitId""ContractId""PolicyOwnerID""PayerID" */
    IF EXISTS (
      SELECT * FROM deleted,ContractPremium
      WHERE
        /*  %JoinFKPK(ContractPremium,deleted," = "," AND") */
        ContractPremium.ContractBenefitId = deleted.ContractBenefitId AND
        ContractPremium.ContractId = deleted.ContractId AND
        ContractPremium.PolicyOwnerID = deleted.PolicyOwnerID AND
        ContractPremium.PayerID = deleted.PayerID
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete ContractBenefit because ContractPremium exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* ContractBenefit  ContractBenefit_Customer on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="ContractBenefit"
    CHILD_OWNER="", CHILD_TABLE="ContractBenefit_Customer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_28", FK_COLUMNS="ContractBenefitId""ContractId""PolicyOwnerID""PayerID" */
    IF EXISTS (
      SELECT * FROM deleted,ContractBenefit_Customer
      WHERE
        /*  %JoinFKPK(ContractBenefit_Customer,deleted," = "," AND") */
        ContractBenefit_Customer.ContractBenefitId = deleted.ContractBenefitId AND
        ContractBenefit_Customer.ContractId = deleted.ContractId AND
        ContractBenefit_Customer.PolicyOwnerID = deleted.PolicyOwnerID AND
        ContractBenefit_Customer.PayerID = deleted.PayerID
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete ContractBenefit because ContractBenefit_Customer exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Contract  ContractBenefit on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Contract"
    CHILD_OWNER="", CHILD_TABLE="ContractBenefit"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="ContractId""PolicyOwnerID""PayerID" */
    IF EXISTS (SELECT * FROM deleted,Contract
      WHERE
        /* %JoinFKPK(deleted,Contract," = "," AND") */
        deleted.ContractId = Contract.ContractId AND
        deleted.PolicyOwnerID = Contract.PolicyOwnerID AND
        deleted.PayerID = Contract.PayerID AND
        NOT EXISTS (
          SELECT * FROM ContractBenefit
          WHERE
            /* %JoinFKPK(ContractBenefit,Contract," = "," AND") */
            ContractBenefit.ContractId = Contract.ContractId AND
            ContractBenefit.PolicyOwnerID = Contract.PolicyOwnerID AND
            ContractBenefit.PayerID = Contract.PayerID
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last ContractBenefit because Contract exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go


CREATE TRIGGER tU_ContractBenefit ON ContractBenefit FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on ContractBenefit */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insContractBenefitId integer, 
           @insContractId integer, 
           @insPolicyOwnerID integer, 
           @insPayerID integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* ContractBenefit  ContractPremium on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="000501fe", PARENT_OWNER="", PARENT_TABLE="ContractBenefit"
    CHILD_OWNER="", CHILD_TABLE="ContractPremium"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="ContractBenefitId""ContractId""PolicyOwnerID""PayerID" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(ContractBenefitId) OR
    UPDATE(ContractId) OR
    UPDATE(PolicyOwnerID) OR
    UPDATE(PayerID)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,ContractPremium
      WHERE
        /*  %JoinFKPK(ContractPremium,deleted," = "," AND") */
        ContractPremium.ContractBenefitId = deleted.ContractBenefitId AND
        ContractPremium.ContractId = deleted.ContractId AND
        ContractPremium.PolicyOwnerID = deleted.PolicyOwnerID AND
        ContractPremium.PayerID = deleted.PayerID
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update ContractBenefit because ContractPremium exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* ContractBenefit  ContractBenefit_Customer on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="ContractBenefit"
    CHILD_OWNER="", CHILD_TABLE="ContractBenefit_Customer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_28", FK_COLUMNS="ContractBenefitId""ContractId""PolicyOwnerID""PayerID" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(ContractBenefitId) OR
    UPDATE(ContractId) OR
    UPDATE(PolicyOwnerID) OR
    UPDATE(PayerID)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,ContractBenefit_Customer
      WHERE
        /*  %JoinFKPK(ContractBenefit_Customer,deleted," = "," AND") */
        ContractBenefit_Customer.ContractBenefitId = deleted.ContractBenefitId AND
        ContractBenefit_Customer.ContractId = deleted.ContractId AND
        ContractBenefit_Customer.PolicyOwnerID = deleted.PolicyOwnerID AND
        ContractBenefit_Customer.PayerID = deleted.PayerID
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update ContractBenefit because ContractBenefit_Customer exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Contract  ContractBenefit on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Contract"
    CHILD_OWNER="", CHILD_TABLE="ContractBenefit"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="ContractId""PolicyOwnerID""PayerID" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(ContractId) OR
    UPDATE(PolicyOwnerID) OR
    UPDATE(PayerID)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Contract
        WHERE
          /* %JoinFKPK(inserted,Contract) */
          inserted.ContractId = Contract.ContractId and
          inserted.PolicyOwnerID = Contract.PolicyOwnerID and
          inserted.PayerID = Contract.PayerID
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update ContractBenefit because Contract does not exist.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go




CREATE TRIGGER tD_ContractBenefit_Customer ON ContractBenefit_Customer FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on ContractBenefit_Customer */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Customer  ContractBenefit_Customer on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00054dd7", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="ContractBenefit_Customer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_26", FK_COLUMNS="CustomerId" */
    IF EXISTS (SELECT * FROM deleted,Customer
      WHERE
        /* %JoinFKPK(deleted,Customer," = "," AND") */
        deleted.CustomerId = Customer.CustomerId AND
        NOT EXISTS (
          SELECT * FROM ContractBenefit_Customer
          WHERE
            /* %JoinFKPK(ContractBenefit_Customer,Customer," = "," AND") */
            ContractBenefit_Customer.CustomerId = Customer.CustomerId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last ContractBenefit_Customer because Customer exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Contract  ContractBenefit_Customer on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Contract"
    CHILD_OWNER="", CHILD_TABLE="ContractBenefit_Customer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_27", FK_COLUMNS="ContractId""PolicyOwnerID""PayerID" */
    IF EXISTS (SELECT * FROM deleted,Contract
      WHERE
        /* %JoinFKPK(deleted,Contract," = "," AND") */
        deleted.ContractId = Contract.ContractId AND
        deleted.PolicyOwnerID = Contract.PolicyOwnerID AND
        deleted.PayerID = Contract.PayerID AND
        NOT EXISTS (
          SELECT * FROM ContractBenefit_Customer
          WHERE
            /* %JoinFKPK(ContractBenefit_Customer,Contract," = "," AND") */
            ContractBenefit_Customer.ContractId = Contract.ContractId AND
            ContractBenefit_Customer.PolicyOwnerID = Contract.PolicyOwnerID AND
            ContractBenefit_Customer.PayerID = Contract.PayerID
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last ContractBenefit_Customer because Contract exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* ContractBenefit  ContractBenefit_Customer on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="ContractBenefit"
    CHILD_OWNER="", CHILD_TABLE="ContractBenefit_Customer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_28", FK_COLUMNS="ContractBenefitId""ContractId""PolicyOwnerID""PayerID" */
    IF EXISTS (SELECT * FROM deleted,ContractBenefit
      WHERE
        /* %JoinFKPK(deleted,ContractBenefit," = "," AND") */
        deleted.ContractBenefitId = ContractBenefit.ContractBenefitId AND
        deleted.ContractId = ContractBenefit.ContractId AND
        deleted.PolicyOwnerID = ContractBenefit.PolicyOwnerID AND
        deleted.PayerID = ContractBenefit.PayerID AND
        NOT EXISTS (
          SELECT * FROM ContractBenefit_Customer
          WHERE
            /* %JoinFKPK(ContractBenefit_Customer,ContractBenefit," = "," AND") */
            ContractBenefit_Customer.ContractBenefitId = ContractBenefit.ContractBenefitId AND
            ContractBenefit_Customer.ContractId = ContractBenefit.ContractId AND
            ContractBenefit_Customer.PolicyOwnerID = ContractBenefit.PolicyOwnerID AND
            ContractBenefit_Customer.PayerID = ContractBenefit.PayerID
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last ContractBenefit_Customer because ContractBenefit exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go


CREATE TRIGGER tU_ContractBenefit_Customer ON ContractBenefit_Customer FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on ContractBenefit_Customer */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insId integer, 
           @insCustomerId integer, 
           @insContractBenefitId integer, 
           @insContractId integer, 
           @insPolicyOwnerID integer, 
           @insPayerID integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Customer  ContractBenefit_Customer on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0004e644", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="ContractBenefit_Customer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_26", FK_COLUMNS="CustomerId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(CustomerId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Customer
        WHERE
          /* %JoinFKPK(inserted,Customer) */
          inserted.CustomerId = Customer.CustomerId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update ContractBenefit_Customer because Customer does not exist.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Contract  ContractBenefit_Customer on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Contract"
    CHILD_OWNER="", CHILD_TABLE="ContractBenefit_Customer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_27", FK_COLUMNS="ContractId""PolicyOwnerID""PayerID" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(ContractId) OR
    UPDATE(PolicyOwnerID) OR
    UPDATE(PayerID)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Contract
        WHERE
          /* %JoinFKPK(inserted,Contract) */
          inserted.ContractId = Contract.ContractId and
          inserted.PolicyOwnerID = Contract.PolicyOwnerID and
          inserted.PayerID = Contract.PayerID
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update ContractBenefit_Customer because Contract does not exist.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* ContractBenefit  ContractBenefit_Customer on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="ContractBenefit"
    CHILD_OWNER="", CHILD_TABLE="ContractBenefit_Customer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_28", FK_COLUMNS="ContractBenefitId""ContractId""PolicyOwnerID""PayerID" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(ContractBenefitId) OR
    UPDATE(ContractId) OR
    UPDATE(PolicyOwnerID) OR
    UPDATE(PayerID)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,ContractBenefit
        WHERE
          /* %JoinFKPK(inserted,ContractBenefit) */
          inserted.ContractBenefitId = ContractBenefit.ContractBenefitId and
          inserted.ContractId = ContractBenefit.ContractId and
          inserted.PolicyOwnerID = ContractBenefit.PolicyOwnerID and
          inserted.PayerID = ContractBenefit.PayerID
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update ContractBenefit_Customer because ContractBenefit does not exist.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go




CREATE TRIGGER tD_ContractPremium ON ContractPremium FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on ContractPremium */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* ContractBenefit  ContractPremium on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00021148", PARENT_OWNER="", PARENT_TABLE="ContractBenefit"
    CHILD_OWNER="", CHILD_TABLE="ContractPremium"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="ContractBenefitId""ContractId""PolicyOwnerID""PayerID" */
    IF EXISTS (SELECT * FROM deleted,ContractBenefit
      WHERE
        /* %JoinFKPK(deleted,ContractBenefit," = "," AND") */
        deleted.ContractBenefitId = ContractBenefit.ContractBenefitId AND
        deleted.ContractId = ContractBenefit.ContractId AND
        deleted.PolicyOwnerID = ContractBenefit.PolicyOwnerID AND
        deleted.PayerID = ContractBenefit.PayerID AND
        NOT EXISTS (
          SELECT * FROM ContractPremium
          WHERE
            /* %JoinFKPK(ContractPremium,ContractBenefit," = "," AND") */
            ContractPremium.ContractBenefitId = ContractBenefit.ContractBenefitId AND
            ContractPremium.ContractId = ContractBenefit.ContractId AND
            ContractPremium.PolicyOwnerID = ContractBenefit.PolicyOwnerID AND
            ContractPremium.PayerID = ContractBenefit.PayerID
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last ContractPremium because ContractBenefit exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go


CREATE TRIGGER tU_ContractPremium ON ContractPremium FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on ContractPremium */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insContractPremiumId integer, 
           @insContractBenefitId integer, 
           @insContractId integer, 
           @insPolicyOwnerID integer, 
           @insPayerID integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* ContractBenefit  ContractPremium on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0001ea30", PARENT_OWNER="", PARENT_TABLE="ContractBenefit"
    CHILD_OWNER="", CHILD_TABLE="ContractPremium"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="ContractBenefitId""ContractId""PolicyOwnerID""PayerID" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(ContractBenefitId) OR
    UPDATE(ContractId) OR
    UPDATE(PolicyOwnerID) OR
    UPDATE(PayerID)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,ContractBenefit
        WHERE
          /* %JoinFKPK(inserted,ContractBenefit) */
          inserted.ContractBenefitId = ContractBenefit.ContractBenefitId and
          inserted.ContractId = ContractBenefit.ContractId and
          inserted.PolicyOwnerID = ContractBenefit.PolicyOwnerID and
          inserted.PayerID = ContractBenefit.PayerID
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update ContractPremium because ContractBenefit does not exist.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go




CREATE TRIGGER tD_Customer ON Customer FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Customer */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Customer  Contract on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0006f4a7", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="Contract"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="PolicyOwnerID" */
    IF EXISTS (
      SELECT * FROM deleted,Contract
      WHERE
        /*  %JoinFKPK(Contract,deleted," = "," AND") */
        Contract.PolicyOwnerID = deleted.CustomerId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Customer because Contract exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Customer  Contract on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="Contract"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="PayerID" */
    IF EXISTS (
      SELECT * FROM deleted,Contract
      WHERE
        /*  %JoinFKPK(Contract,deleted," = "," AND") */
        Contract.PayerID = deleted.CustomerId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Customer because Contract exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Customer  Account_Customer on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="Account_Customer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_19", FK_COLUMNS="CustomerId" */
    IF EXISTS (
      SELECT * FROM deleted,Account_Customer
      WHERE
        /*  %JoinFKPK(Account_Customer,deleted," = "," AND") */
        Account_Customer.CustomerId = deleted.CustomerId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Customer because Account_Customer exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Customer  Customer_Associate on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="Customer_Associate"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_21", FK_COLUMNS="CustomerId" */
    IF EXISTS (
      SELECT * FROM deleted,Customer_Associate
      WHERE
        /*  %JoinFKPK(Customer_Associate,deleted," = "," AND") */
        Customer_Associate.CustomerId = deleted.CustomerId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Customer because Customer_Associate exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Customer  Customer_Customer on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="Customer_Customer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_24", FK_COLUMNS="MainCustomerId" */
    IF EXISTS (
      SELECT * FROM deleted,Customer_Customer
      WHERE
        /*  %JoinFKPK(Customer_Customer,deleted," = "," AND") */
        Customer_Customer.MainCustomerId = deleted.CustomerId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Customer because Customer_Customer exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Customer  Customer_Customer on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="Customer_Customer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_25", FK_COLUMNS="RelatedCustomerId" */
    IF EXISTS (
      SELECT * FROM deleted,Customer_Customer
      WHERE
        /*  %JoinFKPK(Customer_Customer,deleted," = "," AND") */
        Customer_Customer.RelatedCustomerId = deleted.CustomerId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Customer because Customer_Customer exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Customer  ContractBenefit_Customer on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="ContractBenefit_Customer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_26", FK_COLUMNS="CustomerId" */
    IF EXISTS (
      SELECT * FROM deleted,ContractBenefit_Customer
      WHERE
        /*  %JoinFKPK(ContractBenefit_Customer,deleted," = "," AND") */
        ContractBenefit_Customer.CustomerId = deleted.CustomerId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Customer because ContractBenefit_Customer exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go


CREATE TRIGGER tU_Customer ON Customer FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Customer */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insCustomerId integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Customer  Contract on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0007bb89", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="Contract"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_4", FK_COLUMNS="PolicyOwnerID" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(CustomerId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Contract
      WHERE
        /*  %JoinFKPK(Contract,deleted," = "," AND") */
        Contract.PolicyOwnerID = deleted.CustomerId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Customer because Contract exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Customer  Contract on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="Contract"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_6", FK_COLUMNS="PayerID" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(CustomerId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Contract
      WHERE
        /*  %JoinFKPK(Contract,deleted," = "," AND") */
        Contract.PayerID = deleted.CustomerId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Customer because Contract exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Customer  Account_Customer on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="Account_Customer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_19", FK_COLUMNS="CustomerId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(CustomerId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Account_Customer
      WHERE
        /*  %JoinFKPK(Account_Customer,deleted," = "," AND") */
        Account_Customer.CustomerId = deleted.CustomerId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Customer because Account_Customer exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Customer  Customer_Associate on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="Customer_Associate"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_21", FK_COLUMNS="CustomerId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(CustomerId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Customer_Associate
      WHERE
        /*  %JoinFKPK(Customer_Associate,deleted," = "," AND") */
        Customer_Associate.CustomerId = deleted.CustomerId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Customer because Customer_Associate exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Customer  Customer_Customer on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="Customer_Customer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_24", FK_COLUMNS="MainCustomerId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(CustomerId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Customer_Customer
      WHERE
        /*  %JoinFKPK(Customer_Customer,deleted," = "," AND") */
        Customer_Customer.MainCustomerId = deleted.CustomerId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Customer because Customer_Customer exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Customer  Customer_Customer on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="Customer_Customer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_25", FK_COLUMNS="RelatedCustomerId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(CustomerId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Customer_Customer
      WHERE
        /*  %JoinFKPK(Customer_Customer,deleted," = "," AND") */
        Customer_Customer.RelatedCustomerId = deleted.CustomerId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Customer because Customer_Customer exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Customer  ContractBenefit_Customer on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="ContractBenefit_Customer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_26", FK_COLUMNS="CustomerId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(CustomerId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,ContractBenefit_Customer
      WHERE
        /*  %JoinFKPK(ContractBenefit_Customer,deleted," = "," AND") */
        ContractBenefit_Customer.CustomerId = deleted.CustomerId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Customer because ContractBenefit_Customer exists.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go




CREATE TRIGGER tD_Customer_Associate ON Customer_Associate FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Customer_Associate */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Associate  Customer_Associate on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="0002995e", PARENT_OWNER="", PARENT_TABLE="Associate"
    CHILD_OWNER="", CHILD_TABLE="Customer_Associate"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_20", FK_COLUMNS="AssociateId" */
    IF EXISTS (SELECT * FROM deleted,Associate
      WHERE
        /* %JoinFKPK(deleted,Associate," = "," AND") */
        deleted.AssociateId = Associate.AssociateId AND
        NOT EXISTS (
          SELECT * FROM Customer_Associate
          WHERE
            /* %JoinFKPK(Customer_Associate,Associate," = "," AND") */
            Customer_Associate.AssociateId = Associate.AssociateId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Customer_Associate because Associate exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Customer  Customer_Associate on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="Customer_Associate"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_21", FK_COLUMNS="CustomerId" */
    IF EXISTS (SELECT * FROM deleted,Customer
      WHERE
        /* %JoinFKPK(deleted,Customer," = "," AND") */
        deleted.CustomerId = Customer.CustomerId AND
        NOT EXISTS (
          SELECT * FROM Customer_Associate
          WHERE
            /* %JoinFKPK(Customer_Associate,Customer," = "," AND") */
            Customer_Associate.CustomerId = Customer.CustomerId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Customer_Associate because Customer exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go


CREATE TRIGGER tU_Customer_Associate ON Customer_Associate FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Customer_Associate */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insId integer, 
           @insAssociateId integer, 
           @insCustomerId integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Associate  Customer_Associate on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0002b8ab", PARENT_OWNER="", PARENT_TABLE="Associate"
    CHILD_OWNER="", CHILD_TABLE="Customer_Associate"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_20", FK_COLUMNS="AssociateId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(AssociateId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Associate
        WHERE
          /* %JoinFKPK(inserted,Associate) */
          inserted.AssociateId = Associate.AssociateId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Customer_Associate because Associate does not exist.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Customer  Customer_Associate on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="Customer_Associate"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_21", FK_COLUMNS="CustomerId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(CustomerId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Customer
        WHERE
          /* %JoinFKPK(inserted,Customer) */
          inserted.CustomerId = Customer.CustomerId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Customer_Associate because Customer does not exist.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go




CREATE TRIGGER tD_Customer_Customer ON Customer_Customer FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on Customer_Customer */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* Customer  Customer_Customer on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="0002972a", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="Customer_Customer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_24", FK_COLUMNS="MainCustomerId" */
    IF EXISTS (SELECT * FROM deleted,Customer
      WHERE
        /* %JoinFKPK(deleted,Customer," = "," AND") */
        deleted.MainCustomerId = Customer.CustomerId AND
        NOT EXISTS (
          SELECT * FROM Customer_Customer
          WHERE
            /* %JoinFKPK(Customer_Customer,Customer," = "," AND") */
            Customer_Customer.MainCustomerId = Customer.CustomerId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Customer_Customer because Customer exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Customer  Customer_Customer on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="Customer_Customer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_25", FK_COLUMNS="RelatedCustomerId" */
    IF EXISTS (SELECT * FROM deleted,Customer
      WHERE
        /* %JoinFKPK(deleted,Customer," = "," AND") */
        deleted.RelatedCustomerId = Customer.CustomerId AND
        NOT EXISTS (
          SELECT * FROM Customer_Customer
          WHERE
            /* %JoinFKPK(Customer_Customer,Customer," = "," AND") */
            Customer_Customer.RelatedCustomerId = Customer.CustomerId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Customer_Customer because Customer exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go


CREATE TRIGGER tU_Customer_Customer ON Customer_Customer FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on Customer_Customer */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insId integer, 
           @insMainCustomerId integer, 
           @insRelatedCustomerId integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* Customer  Customer_Customer on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0002c780", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="Customer_Customer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_24", FK_COLUMNS="MainCustomerId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(MainCustomerId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Customer
        WHERE
          /* %JoinFKPK(inserted,Customer) */
          inserted.MainCustomerId = Customer.CustomerId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Customer_Customer because Customer does not exist.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Customer  Customer_Customer on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Customer"
    CHILD_OWNER="", CHILD_TABLE="Customer_Customer"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_25", FK_COLUMNS="RelatedCustomerId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(RelatedCustomerId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Customer
        WHERE
          /* %JoinFKPK(inserted,Customer) */
          inserted.RelatedCustomerId = Customer.CustomerId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Customer_Customer because Customer does not exist.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go




CREATE TRIGGER tD_ManagerContract ON ManagerContract FOR DELETE AS
/* ERwin Builtin Trigger */
/* DELETE trigger on ManagerContract */
BEGIN
  DECLARE  @errno   int,
           @errmsg  varchar(255)
    /* ERwin Builtin Trigger */
    /* ManagerContract  Account_ManagerContract on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00027cc5", PARENT_OWNER="", PARENT_TABLE="ManagerContract"
    CHILD_OWNER="", CHILD_TABLE="Account_ManagerContract"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="ManagerContractId""AssociateId" */
    IF EXISTS (
      SELECT * FROM deleted,Account_ManagerContract
      WHERE
        /*  %JoinFKPK(Account_ManagerContract,deleted," = "," AND") */
        Account_ManagerContract.ManagerContractId = deleted.ManagerContractId AND
        Account_ManagerContract.AssociateId = deleted.AssociateId
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete ManagerContract because Account_ManagerContract exists.'
      GOTO ERROR
    END

    /* ERwin Builtin Trigger */
    /* Associate  ManagerContract on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Associate"
    CHILD_OWNER="", CHILD_TABLE="ManagerContract"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="AssociateId" */
    IF EXISTS (SELECT * FROM deleted,Associate
      WHERE
        /* %JoinFKPK(deleted,Associate," = "," AND") */
        deleted.AssociateId = Associate.AssociateId AND
        NOT EXISTS (
          SELECT * FROM ManagerContract
          WHERE
            /* %JoinFKPK(ManagerContract,Associate," = "," AND") */
            ManagerContract.AssociateId = Associate.AssociateId
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last ManagerContract because Associate exists.'
      GOTO ERROR
    END


    /* ERwin Builtin Trigger */
    RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go


CREATE TRIGGER tU_ManagerContract ON ManagerContract FOR UPDATE AS
/* ERwin Builtin Trigger */
/* UPDATE trigger on ManagerContract */
BEGIN
  DECLARE  @NUMROWS int,
           @nullcnt int,
           @validcnt int,
           @insManagerContractId integer, 
           @insAssociateId integer,
           @errno   int,
           @errmsg  varchar(255)

  SELECT @NUMROWS = @@rowcount
  /* ERwin Builtin Trigger */
  /* ManagerContract  Account_ManagerContract on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0002c43d", PARENT_OWNER="", PARENT_TABLE="ManagerContract"
    CHILD_OWNER="", CHILD_TABLE="Account_ManagerContract"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="ManagerContractId""AssociateId" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(ManagerContractId) OR
    UPDATE(AssociateId)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Account_ManagerContract
      WHERE
        /*  %JoinFKPK(Account_ManagerContract,deleted," = "," AND") */
        Account_ManagerContract.ManagerContractId = deleted.ManagerContractId AND
        Account_ManagerContract.AssociateId = deleted.AssociateId
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update ManagerContract because Account_ManagerContract exists.'
      GOTO ERROR
    END
  END

  /* ERwin Builtin Trigger */
  /* Associate  ManagerContract on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Associate"
    CHILD_OWNER="", CHILD_TABLE="ManagerContract"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_3", FK_COLUMNS="AssociateId" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(AssociateId)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Associate
        WHERE
          /* %JoinFKPK(inserted,Associate) */
          inserted.AssociateId = Associate.AssociateId
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @NUMROWS
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update ManagerContract because Associate does not exist.'
      GOTO ERROR
    END
  END


  /* ERwin Builtin Trigger */
  RETURN
ERROR:
    raiserror @errno @errmsg
    rollback transaction
END

go


