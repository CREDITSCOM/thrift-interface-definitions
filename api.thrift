include 'general.thrift'

namespace csharp NodeApi
namespace netcore NodeApi
namespace java com.credits.client.node.thrift.generated
namespace cpp api

// Currency code, 1 for mainline one (Credits, 'CS')
typedef i8 Currency
// Wallet or smart contract address
typedef binary Address
// Unix timestamp in milliseconds
typedef i64 Time

struct Amount
{
  1: required i32 integral = 0;
  2: required i64 fraction = 0;
}

struct AmountCommission
{
  1: required i16 commission = 0;
}

struct CumulativeAmount
{
  1: required i64 integral = 0;
  2: required i64 fraction = 0;
}

typedef map<Currency, Amount> Balance;

typedef map<Currency, CumulativeAmount> Total;

struct SmartContractDeploy
{
  1: string sourceCode
  2: binary byteCode
  3: string hashState
  4: i16 tokenStandart	
}

// Smart contract info
struct SmartContract
{
  1: required Address address
  2: Address deployer
  3: SmartContractDeploy smartContractDeploy
  4: binary objectState
} 

struct SmartContractInvocation
{
  1: string method
  // Empty on deploy, method params stringified Java-side with conversion to string on execute
  2: list<general.Variant> params
  // If true, do not emit any transactions to blockchain (execute smart contract and forget state change if any)
  3: bool forgetNewState
  4: optional SmartContractDeploy smartContractDeploy
}
//
// Transactions
//

typedef i64 TransactionInnerId

struct TransactionId
{
    1: PoolHash poolHash
    // Position inside of block
    2: i32 index
}

struct Transaction
{
    // Inner transaction ID for protection against replay attack
    1: TransactionInnerId id
    // Giver if no smart contract invokation is present, otherwise deployer. 
    // Generally, public key against of which signature is validated
    2: Address source
    // Smart contract address if one's invokation is present, otherwise acceptor's address
    3: Address target
    // Transfer amount for payment transaction
    4: Amount amount
    // Wallet's view on it's balance
    5: Amount balance
    6: Currency currency
    // Signature is formed against node's custom binary serialization format,
    // see other docs for description
    7: binary signature
    8: optional SmartContractInvocation smartContract
    // Max fee acceptable for donor to be subtracted
    9: AmountCommission fee
	10: i64 timeCreation
	// user fields
	11: optional binary userFields
}

// Structure for tranactions that have been emplaced to the blockchain
struct SealedTransaction {
    1: TransactionId id
    2: Transaction trxn
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
    // Amount of transactions in this block
    4: i32 transactionsCount
    5: PoolNumber poolNumber
}

//
// Wallets
//

typedef i32 WalletId

struct WalletData
{
    1: WalletId walletId
    2: Amount balance
    3: TransactionInnerId lastTransactionId
}

//
//  Stats
//

typedef i32 Count

struct PeriodStats
{
	// Amount of milliseconds over which following aggregated results are reported
    1: Time periodDuration
	// Amount of pools
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
    2: Amount balance
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

// TransactionsGet
struct TrxnsCount
{
    1: i64 sendCount
	2: i64 recvCount
}

struct TransactionsGetResult
{
    1: general.APIResponse status
    2: bool result
    3: list<SealedTransaction> transactions
	4: TrxnsCount totalTrxns
}

struct TransactionFlowResult
{
    1: general.APIResponse status
    2: optional general.Variant smart_contract_result
    3: i32 roundNum
}

// PoolListGet

struct PoolListGetResult
{
    1: general.APIResponse status
    2: bool result
    3: list<Pool> pools
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
    2: list<Address> addressesList
}

// SmartContractsListGetResult

struct SmartContractsListGetResult
{
    1: general.APIResponse status
    2: list<SmartContract> smartContractsList
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
    3: list<general.Variant> params;

}

/*struct MethodDescription {
    1: string name
    2: list<string> argTypes
    3: string returnType
}*/

struct MethodArgument {
  1: string type
  2: string name
}

struct MethodDescription {
  1: string returnType
  2: string name
  3: list<MethodArgument> arguments
}

struct ContractAllMethodsGetResult {
    1: i8 code
    2: string message
    3: list<MethodDescription> methods
}

struct MembersSmartContractGetResult {
    1: general.APIResponse status
    2: string name
    3: string owner
	4: string decimal
	5: string totalCoins
    6: string symbol
}

////////
enum TokenStandart
{
    NotAToken = 0,
    CreditsBasic = 1,
    CreditsExtended = 2
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
    3: map<string, general.Variant> variables
}

struct SmartContractCompileResult
{
    1: general.APIResponse status;
    2: binary byteCode;
    3: TokenStandart ts;
}
////////

service API
{
    WalletDataGetResult WalletDataGet(1:Address address)
    WalletIdGetResult WalletIdGet(1:Address address)
    WalletTransactionsCountGetResult WalletTransactionsCountGet(1:Address address)
    WalletBalanceGetResult WalletBalanceGet(1:Address address)

    TransactionGetResult TransactionGet(1:TransactionId transactionId)
    // Get transactions where `address` is either sender or receiver
    TransactionsGetResult TransactionsGet(1:Address address, 2:i64 offset, 3:i64 limit) 
    // Not for monitor. Transmit transaction to network for approval
    TransactionFlowResult TransactionFlow(1:Transaction transaction)

    // For tetris for now.
    PoolHash GetLastHash()
    // Was intended for use by web monitor. Never tested, get blocks starting from `hash` up to `limit` instances
    PoolListGetResult PoolListGetStable(1:PoolHash hash, 2:i64 limit)

    // For web monitor, used now. Get metainfo about pools skipping `offset` up to `limit` in amount
    PoolListGetResult PoolListGet(1:i64 offset, 2:i64 limit) // deprecated
    // For web monitor. Get metainfo about block by hash
    PoolInfoGetResult PoolInfoGet(1:PoolHash hash, 2:i64 index)
    // For web monitor. Get transactions from exactly `hash` pool, skipping `offset` and retrieiving at most `limit`
    PoolTransactionsGetResult PoolTransactionsGet(1:PoolHash hash, 2:i64 offset, 3:i64 limit)

    // For web monitor. 
    StatsGetResult StatsGet()

    SmartContractGetResult SmartContractGet(1:Address address)
    SmartContractsListGetResult SmartContractsListGet(1:Address deployer)
    SmartContractAddressesListGetResult SmartContractAddressesListGet(1:Address deployer)

    // Blocks till `obsolete` is not the last block in chain.
    PoolHash WaitForBlock(1:PoolHash obsolete)

    // Blocks till there are transactions arrived to `smart_address` 
    // not yet reported by this method in current node's process lifetime.
    TransactionId WaitForSmartTransaction(1:Address smart_public)
    SmartContractsListGetResult SmartContractsAllListGet(1:i64 offset, 2:i64 limit)
    TransactionsStateGetResult TransactionsStateGet(1:Address address, 2:list<TransactionInnerId> id)
    ContractAllMethodsGetResult ContractAllMethodsGet(1: binary bytecode)
    SmartMethodParamsGetResult SmartMethodParamsGet(1:Address address, 2:TransactionInnerId id)
	MembersSmartContractGetResult MembersSmartContractGet(1:TransactionId transactionId)
	
	////////new
	// Smart contracts
    SmartContractDataResult SmartContractDataGet(1:Address address)
    SmartContractCompileResult SmartContractCompile(1:string sourceCode)
	////////new
}
