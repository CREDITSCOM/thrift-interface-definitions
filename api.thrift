include 'general.thrift'

namespace csharp NodeApi
namespace netcore NodeApi
namespace java com.credits.client.node.thrift.generated
namespace cpp api

// Currency code, 1 for mainline one (Credits, 'CS')
typedef i8 Currency
// Wallet or smart contract address
//typedef binary Address
// Unix timestamp in milliseconds
typedef i64 Time

typedef string TokenCode
typedef string TokenAmount

struct AmountCommission
{
  1: required i16 commission = 0;
}

struct CumulativeAmount
{
  1: required i64 integral = 0;
  2: required i64 fraction = 0;
}

typedef map<Currency, general.Amount> Balance;

typedef map<Currency, CumulativeAmount> Total;

struct SmartContractDeploy
{
  1: string sourceCode
  2: list<general.ByteCodeObject> byteCodeObjects
  3: string hashState
  4: i32 tokenStandard
}

// Smart contract info
struct SmartContract
{
  1: required general.Address address
  2: general.Address deployer
  3: SmartContractDeploy smartContractDeploy
  4: binary objectState
  5: Time createTime
  6: i32 transactionsCount
}

struct SmartContractInvocation
{
  1: string method
  // Empty on deploy, method params stringified Java-side with conversion to string on execute
  2: list<general.Variant> params //general.Variant+
  // If true, do not emit any transactions to blockchain (execute smart contract and forget state change if any)
  3: list<general.Address> usedContracts
  4: bool forgetNewState
  5: optional SmartContractDeploy smartContractDeploy
  6: i16 version = 1; // must be on this place! Position number cannot be changed
}
//
// Transactions
//

typedef i64 TransactionInnerId

struct TransactionId
{
    1: i64 poolSeq
    // Position inside of block
    2: i32 index
}

enum TransactionType
{
    // 0 | CS transfer, former TT_Normal
    TT_Transfer,
    // 1 | contract deployment, former TT_SmartDeploy
    TT_ContractDeploy,
    // 2 | Contract execution, former TT_SmartExecute
    TT_ContractCall,
    // 3 | Contract new state, TT_SmartState
    TT_ContractState,
    // 4 | Contract replenish (indirect payable() invocation)
    TT_ContractReplenish,
    // 5 | Token deployment
    TT_TokenDeploy,
    // 6 | Token transfer
    TT_TokenTransfer,
    // 7 | Stake delegation to node address
    TT_Delegation,
    // 8 | Cancel stake delegation
    TT_RevokeDelegation,
    // 9 | Put some transfer on hold until some codition to release or cancel
    TT_Hold,
    // 10 | Release previously hold sum to complete transfer
    TT_Release,
    // 11 | Revoke hold to cancel the transfer
    TT_CancelHold,
    // 12 | Transfer delayed until some moment
    TT_DelayedTransfer,
    // 13 | Service: update current boostrap node list with new one
    TT_UpdateBootstrapList,
    // 14 | Service: update current settings
    TT_UpdateSettings,
    // 15 | Malformed (invalid) transaction
    TT_Malformed,
    // 16 | Contract emitted transaction
    TT_ContractEmitted,
    // 17 | Utility transaction
    TT_Utility,
    // 18 | Any other type
    TT_Other,
}

enum SmartOperationState
{
    SOS_Pending,
    SOS_Success,
    SOS_Failed
}

struct TokenDeployTransInfo
{
    1: string name
    2: TokenCode code
	3: i32 tokenStandard
    4: SmartOperationState state
    5: optional TransactionId stateTransaction
}

struct TokenTransferTransInfo
{
    1: TokenCode code
    2: general.Address sender
    3: general.Address receiver
    4: TokenAmount amount
    5: SmartOperationState state
    6: optional TransactionId stateTransaction
    7: optional bool transferSuccess
}

struct SmartDeployTransInfo
{
    1: SmartOperationState state
    2: optional TransactionId stateTransaction
}

struct SmartExecutionTransInfo
{
    1: string method;
    2: list<general.Variant> params;
    3: SmartOperationState state
    4: optional TransactionId stateTransaction
}

struct ExtraFee
{
	1: general.Amount sum
    2: string comment
	3: TransactionId transactionId
}

struct SmartStateTransInfo
{
    1: bool success
    2: general.Amount executionFee
    3: optional general.Variant returnValue
    4: TransactionId startTransaction
}

union SmartTransInfo {
    1: TokenDeployTransInfo v_tokenDeploy
    2: TokenTransferTransInfo v_tokenTransfer
    3: SmartDeployTransInfo v_smartDeploy
    4: SmartExecutionTransInfo v_smartExecution
    5: SmartStateTransInfo v_smartState
}

struct Transaction
{
    // Inner transaction ID for protection against replay attack
    1: TransactionInnerId id
    // Giver if no smart contract invokation is present, otherwise deployer.
    // Generally, public key against of which signature is validated
    2: general.Address source
    // Smart contract address if one's invokation is present, otherwise acceptor's address
    3: general.Address target
    // Transfer amount for payment transaction
    4: general.Amount amount
    // Wallet's view on it's balance
    5: general.Amount balance
    6: Currency currency
    // Signature is formed against node's custom binary serialization format,
    // see other docs for description
    7: binary signature
    8: optional SmartContractInvocation smartContract
    // Max fee acceptable for donor to be subtracted
    9: AmountCommission fee
    10: Time timeCreation
    // user fields
    11: optional binary userFields
    12: TransactionType type
    13: optional SmartTransInfo smartInfo
	14: optional list<ExtraFee> extraFee
	15: i64 poolNumber
	16: optional list<general.Address> usedContracts
}

// Structure for tranactions that have been emplaced to the blockchain
struct SealedTransaction {
    1: TransactionId id
    2: Transaction trxn
}

// Structure for transaction in short form
struct ShortTransaction
{
	1: TransactionId id
	2: general.Address source
	3: general.Address target
	4: general.Amount amount
	5: AmountCommission fee
	6: Time timeCreation
	7: Currency currency
	8: TransactionType type
	10: optional binary userFields
}

//
//  Pools
//

typedef binary PoolHash
// Sequential index of block, starting with zero
typedef i64 PoolNumber

struct Pool
{
    1: PoolHash hash
    // Previous block hash
    2: PoolHash prevHash
    // Timestamp from writer (?)
    3: Time time
    // general.Amount of transactions in this block
    4: i32 transactionsCount
    5: PoolNumber poolNumber
    6: general.Address writer
    7: general.Amount totalFee
	8: list <general.Address> confidants
	9: i64 realTrusted
	10: i8 numberTrusted
}

//
// Wallets
//

struct DelegatedItem
{
    // partner address
    1: general.Address wallet
    // delegated sum
    2: general.Amount sum
    // Unix time in seconds
    3: optional Time validUntil
}

struct Delegated
{
    // delegated to this wallet by other one
    1: general.Amount incoming
    // total sum delegated by this wallet to others
    2: general.Amount outgoing
    // list of incoming delegations
    3: optional list<DelegatedItem> donors
    // list of outgoing delegations
    4: optional list<DelegatedItem> recipients
}

typedef i32 WalletId

struct WalletData
{
    1: WalletId walletId
    2: general.Amount balance
    3: TransactionInnerId lastTransactionId
    4: optional Delegated delegated
}

//
//  Stats
//

typedef i32 Count

struct PeriodStats
{
    // Amount of milliseconds over which following aggregated results are reported
    1: Time periodDuration
    // general.Amount of pools
    2: Count poolsCount
    // Amount of transactionss
    3: Count transactionsCount
    // Cumulative volume of each currency transferred
    4: Total balancePerCurrency
    // Amount of smart contracts transactions
    5: Count smartContractsCount
    6: Count transactionsSmartCount
}

// Periods are 24h, 1 month, 1 year, and cover-all period
typedef list<PeriodStats> StatsPerPeriod

// Wallets data

struct WalletDataGetResult
{
    1: general.APIResponse status
    2: WalletData walletData
}

struct WalletIdGetResult
{
    1: general.APIResponse status
    2: WalletId walletId
}

struct WalletTransactionsCountGetResult
{
    1: general.APIResponse status
    2: TransactionInnerId lastTransactionInnerId
}

struct WalletBalanceGetResult
{
    1: general.APIResponse status
    2: general.Amount balance
    3: optional Delegated delegated
}

enum TransactionState {
    INVALID = 0,
    VALID,
    INPROGRESS
}

// TransactionGet

struct TransactionGetResult
{
    1: general.APIResponse status
    2: bool found
    3: TransactionState state
    4: i32 roundNum
    5: SealedTransaction transaction
}

struct TransactionsGetResult
{
    1: general.APIResponse status
    2: bool result
    3: i32 total_trxns_count
    4: list<SealedTransaction> transactions
}

struct TransactionFlowResult
{
    1: general.APIResponse status
    2: optional general.Variant smart_contract_result //general.Variant
    3: i32 roundNum
	4: TransactionId id
	5: general.Amount fee
	6: optional list<ExtraFee> extraFee
}

struct SingleTokenQuery
{
	1: general.Address tokenAddress
	2: TransactionId fromId
}

struct SingleQuery
{
	1: general.Address requestedAddress
	2: TransactionId fromId
	3: optional list<SingleTokenQuery> tokensList
}

struct TransactionsQuery
{
	1: i16 flag
	2: list<SingleQuery> queries
}

struct SelectedTokenTransfers
{
	1: general.Address tokenAddress
	2: string tokenName
	3: string tokenTiker
	4: list<TokenTransfer> transfers
}

struct PublicKeyTransactions
{
	1: general.Address requestedAddress
	2: list<ShortTransaction> transactions
	3: optional list<SelectedTokenTransfers> transfersList  
}
struct FilteredTransactionsListResult
{
	1: general.APIResponse status
	2: list<PublicKeyTransactions> queryResponse
}

// PoolListGet

struct PoolListGetResult
{
    1: general.APIResponse status
    2: bool result
    3: i32 count
    4: list<Pool> pools
}

// PoolInfoGet

struct PoolInfoGetResult
{
    1: general.APIResponse status
    2: bool isFound
    3: Pool pool
}

// PoolTransactionGet

struct PoolTransactionsGetResult
{
    1: general.APIResponse status
    2: list<SealedTransaction> transactions
}

// StatsGet

struct StatsGetResult
{
    1: general.APIResponse status
    2: StatsPerPeriod stats
}

typedef string NodeHash

// SmartContractGetResult

struct SmartContractGetResult
{
    1: general.APIResponse status
    2: SmartContract smartContract
}

// SmartContractAddressListGetResult

struct SmartContractAddressesListGetResult
{
    1: general.APIResponse status
    2: list<general.Address> addressesList
}

// SmartContractsListGetResult

struct SmartContractsListGetResult
{
    1: general.APIResponse status
    2: i32 count
    3: list<SmartContract> smartContractsList
}

struct TransactionsStateGetResult
{
    1: general.APIResponse status
    2: map<TransactionInnerId, TransactionState> states
    3: i32 roundNum
}

struct SmartMethodParamsGetResult
{
    1: general.APIResponse status
    2: string method;
    3: list<general.Variant> params; //general.Variant+
}

struct ContractAllMethodsGetResult {
    1: i8 code
    2: string message
    3: list<general.MethodDescription> methods
}

// Smart contracts
struct SmartContractMethodArgument {
    1: string type
    2: string name
}

struct SmartContractMethod {
    1: string returnType
    2: string name
    3: list<SmartContractMethodArgument> arguments
}

struct SmartContractDataResult
{
    1: general.APIResponse status;
    2: list<SmartContractMethod> methods;
    3: map<string, general.Variant> variables //general.Variant
}

struct SmartContractCompileResult
{
    1: general.APIResponse status;
    2: list<general.ByteCodeObject> byteCodeObjects;
	3: i32 tokenStandard
}

// Tokens
struct TokenInfo
{
    1: general.Address address
    2: TokenCode code
    3: string name
    4: TokenAmount totalSupply
    5: general.Address owner
    6: i32 transfersCount
    7: i32 transactionsCount
    8: i32 holdersCount
	9: i32 tokenStandard
}

struct TokenTransaction
{
    1: general.Address token
    2: TransactionId transaction
    3: Time time
    4: general.Address initiator
    5: string method
    6: list<general.Variant> params
    7: SmartOperationState state
}

struct TokenHolder
{
    1: general.Address holder
    2: general.Address token
    3: TokenAmount balance
    4: i32 transfersCount
}

// Token requests results

enum TokensListSortField
{
    TL_Code,
    TL_Name,
    TL_Address,
    TL_TotalSupply,
    TL_HoldersCount,
    TL_TransfersCount,
    TL_TransactionsCount
}

enum TokenHoldersSortField
{
    TH_Balance,
    TH_TransfersCount
}

struct TokenBalance
{
    1: general.Address token
    2: TokenCode code
    3: string name
    4: TokenAmount balance
}

struct TokenBalancesResult
{
    1: general.APIResponse status;
    2: list<TokenBalance> balances;
}

struct TokenTransfer
{
    1: general.Address token
    2: TokenCode code
    3: general.Address sender   // This may be zeros if transfer() and not transferFrom() was called
    4: general.Address receiver
    5: TokenAmount amount
    6: general.Address initiator
    7: TransactionId transaction
    8: Time time
	9: SmartOperationState state
	10: optional binary userFields
	11: AmountCommission fee
	14: list<ExtraFee> extraFee
}

struct TokenTransfersResult
{
    1: general.APIResponse status
    2: i32 count
    3: list<TokenTransfer> transfers
}

struct TokenTransactionsResult
{
    1: general.APIResponse status;
    2: i32 count;
    3: list<TokenTransaction> transactions;
}

struct TokenInfoResult
{
    1: general.APIResponse status;
    2: TokenInfo token;
}

struct TokenHoldersResult
{
    1: general.APIResponse status;
    2: i32 count;
    3: list<TokenHolder> holders;
}

struct TokensListResult
{
    1: general.APIResponse status;
    2: i32 count;
    3: list<TokenInfo> tokens;
}

// Wallets

enum WalletsListSort
{
    WL_CurrentSum,
    WL_CreationTime,
    WL_TransactionsCount
}

struct WalletInfo
{
    1: general.Address address;
    2: general.Amount balance;
    3: i64 transactionsNumber;
    4: Time firstTransactionTime;
    // delegations info
    5: optional Delegated delegated

}

struct ActualFeeGetResult
{
	1: AmountCommission fee;
}

struct WalletsGetResult
{
    1: general.APIResponse status;
    2: i32 count;
    3: list<WalletInfo> wallets;
}

struct TrustedInfo
{
    1: general.Address address;
    2: i32 timesWriter;
    3: i32 timesTrusted
    4: general.Amount feeCollected;
}

struct TrustedGetResult
{
    1: general.APIResponse status;
    2: i32 pages;
    3: list<TrustedInfo> writers;
}
////////

struct SyncStateResult
{
    1: general.APIResponse status;
    2: i64 currRound;
    3: i64 lastBlock
}

struct ExecuteCountGetResult
{
    1: general.APIResponse status;
    2: i64 executeCount;
}

struct TokenFilters{
    1: string name
	2: string code
	3: i32 tokenStandard
}

service API
{
	ActualFeeGetResult ActualFeeGet(1:i32 transactionSize) 
    WalletDataGetResult WalletDataGet(1:general.Address address)
    WalletIdGetResult WalletIdGet(1:general.Address address)
    WalletTransactionsCountGetResult WalletTransactionsCountGet(1:general.Address address)
    WalletBalanceGetResult WalletBalanceGet(1:general.Address address)

    TransactionGetResult TransactionGet(1:TransactionId transactionId)
    // Get transactions where `address` is either sender or receiver
    TransactionsGetResult TransactionsGet(1:general.Address address, 2:i64 offset, 3:i64 limit)
    // Not for monitor. Transmit transaction to network for approval
    TransactionFlowResult TransactionFlow(1:Transaction transaction)
    TransactionsGetResult TransactionsListGet(1:i64 offset, 2:i64 limit)
	FilteredTransactionsListResult FilteredTransactionsListGet(1:TransactionsQuery generalQuery)

    // For tetris for now.
    PoolHash GetLastHash()
    // Was intended for use by web monitor. Never tested, get blocks starting from `hash` up to `limit` instances
    PoolListGetResult PoolListGetStable(1:i64 sequence, 2:i64 limit)

    // For web monitor, used now. Get metainfo about pools skipping `offset` up to `limit` in amount
    PoolListGetResult PoolListGet(1:i64 offset, 2:i64 limit) // deprecated
    // For web monitor. Get metainfo about block by hash
    PoolInfoGetResult PoolInfoGet(1:i64 sequence, 2:i64 index)
    // For web monitor. Get transactions from exactly `hash` pool, skipping `offset` and retrieiving at most `limit`
    PoolTransactionsGetResult PoolTransactionsGet(1:i64 sequence, 2:i64 offset, 3:i64 limit)

    // For web monitor.
    StatsGetResult StatsGet()

    SmartContractGetResult SmartContractGet(1:general.Address address)
    SmartContractsListGetResult SmartContractsListGet(1:general.Address deployer, 2:i64 offset, 3:i64 limit)
    SmartContractAddressesListGetResult SmartContractAddressesListGet(1:general.Address deployer)

    // Blocks till `obsolete` is not the last block in chain.
    PoolHash WaitForBlock(1:PoolHash obsolete)

    // Blocks till there are transactions arrived to `smart_address`
    // not yet reported by this method in current node's process lifetime.
    TransactionId WaitForSmartTransaction(1:general.Address smart_public)
    SmartContractsListGetResult SmartContractsAllListGet(1:i64 offset, 2:i64 limit)
    TransactionsStateGetResult TransactionsStateGet(1:general.Address address, 2:list<TransactionInnerId> id)
    ContractAllMethodsGetResult ContractAllMethodsGet(1: list<general.ByteCodeObject> byteCodeObjects)
    SmartMethodParamsGetResult SmartMethodParamsGet(1:general.Address address, 2:TransactionInnerId id)

    ////////
    // Smart contracts
    SmartContractDataResult SmartContractDataGet(1:general.Address address)
    SmartContractCompileResult SmartContractCompile(1:string sourceCode)

    // Tokens
    TokenBalancesResult TokenBalancesGet(1:general.Address address)
    TokenTransfersResult TokenTransfersGet(1:general.Address token, 2:i64 offset, 3:i64 limit)
    TokenTransfersResult TokenTransferGet(1:general.Address token, 2:TransactionId id)
    TokenTransfersResult TokenTransfersListGet(1:i64 offset, 2:i64 limit)
    TokenTransfersResult TokenWalletTransfersGet(1:general.Address token, 2:general.Address address, 3:i64 offset, 4:i64 limit)

    TokenTransactionsResult TokenTransactionsGet(1:general.Address token, 2:i64 offset, 3:i64 limit)
    TokenInfoResult TokenInfoGet(1:general.Address token)
    TokenHoldersResult TokenHoldersGet(1:general.Address token, 2:i64 offset, 3:i64 limit, 4:TokenHoldersSortField order, 5:bool desc)
	TokensListResult TokensListGet(1:i64 offset, 2:i64 limit, 3:TokensListSortField order, 4:bool desc, 5: TokenFilters filters)

    // Wallets

    // Get page from wallets list from [offset] to [offset + limit]
    // sort - is one of WalletsListSort values
    // desc - true to request descending sort, false for ascending sort
    WalletsGetResult WalletsGet(1:i64 offset, 2:i64 limit, 3:i8 ordCol, 4:bool desc)
    TrustedGetResult TrustedGet(1:i32 page)
    ////////

    SyncStateResult SyncStateGet()
	
	ExecuteCountGetResult ExecuteCountGet(1:string executeMethod)
}
