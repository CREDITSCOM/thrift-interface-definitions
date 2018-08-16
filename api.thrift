include 'variant.thrift'

namespace csharp NodeApi
namespace netcore NodeApi
namespace java com.credits.leveldb.client.thrift
namespace cpp api

typedef string Currency
typedef binary Address
typedef i64 Time

struct Amount
{
  1: required i32 integral = 0;
  2: required i64 fraction = 0;
}

struct CumulativeAmount
{
  1: required i64 integral = 0;
  2: required i64 fraction = 0;
}

typedef map<Currency, Amount> Balance;

typedef map<Currency, CumulativeAmount> Total;

struct SmartContract
{
  1: required Address address;
  2: Address deployer
  3: string sourceCode;
  4: binary byteCode;
  5: string hashState;
}

struct SmartContractInvocation
{
  1: string sourceCode;
  2: binary byteCode;
  3: string hashState;
  4: string method;
  5: list<string> params;
  6: bool forgetNewState;
}

//
// Transactions
//

struct TransactionId
{
	1: PoolHash poolHash
	2: i32 index
}

struct Transaction
{
    1: i64 id
    2: Address source
    3: Address target
    4: Amount amount
    5: Amount balance
    6: Currency currency
    7: binary signature
    8: optional SmartContractInvocation smartContract
    9: Amount fee
}

struct SealedTransaction {
	1: TransactionId id
	2: Transaction trxn
}

//
//  Pools
//

typedef binary PoolHash
typedef i64 PoolNumber

struct Pool
{
    1: PoolHash hash
    2: PoolHash prevHash
    3: Time time
    4: i32 transactionsCount
    5: PoolNumber poolNumber
}

//
//  Stats
//

typedef i32 Count

struct PeriodStats
{
    1: Time periodDuration
    2: Count poolsCount
    3: Count transactionsCount
    4: Total balancePerCurrency
    5: Count smartContractsCount
}

typedef list<PeriodStats> StatsPerPeriod

//
// API responses
//

struct APIResponse
{
    1: i8 code
    2: string message
}

// BalanceGet

struct BalanceGetResult
{
    1: APIResponse status
    2: Amount amount
}

// TransactionGet

struct TransactionGetResult
{
    1: APIResponse status
    2: bool found
    3: SealedTransaction transaction
}

// TransactionsGet

struct TransactionsGetResult
{
    1: APIResponse status
    2: bool result
    3: list<SealedTransaction> transactions
}

struct TransactionFlowResult
{
    1: APIResponse status
	2: optional variant.Variant smart_contract_result
}

// PoolListGet

struct PoolListGetResult
{
    1: APIResponse status
    2: bool result
    3: list<Pool> pools
}

// PoolInfoGet

struct PoolInfoGetResult
{
    1: APIResponse status
    2: bool isFound
    3: Pool pool
}

// PoolTransactionGet

struct PoolTransactionsGetResult
{
    1: APIResponse status
    2: list<SealedTransaction> transactions
}

// StatsGet

struct StatsGetResult
{
    1: APIResponse status
    2: StatsPerPeriod stats
}

typedef string NodeHash

// SmartContractGetResult

struct SmartContractGetResult
{
    1: APIResponse status
    2: SmartContract smartContract
}

// SmartContractAddressListGetResult

struct SmartContractAddressesListGetResult
{
    1: APIResponse status
    2: list<Address> addressesList
}

// SmartContractsListGetResult

struct SmartContractsListGetResult
{
    1: APIResponse status
    2: list<SmartContract> smartContractsList
}

service API
{
    BalanceGetResult BalanceGet(1:Address address, 2:Currency currency = 'cs')

    TransactionGetResult TransactionGet(1:TransactionId transactionId)
    TransactionsGetResult TransactionsGet(1:Address address, 2:i64 offset, 3:i64 limit)
    TransactionFlowResult TransactionFlow(1:Transaction transaction)

	PoolHash GetLastHash()
	PoolListGetResult PoolListGetStable(1:PoolHash hash, 2:i64 limit)

    PoolListGetResult PoolListGet(1:i64 offset, 2:i64 limit) // deprecated
    PoolInfoGetResult PoolInfoGet(1:PoolHash hash, 2:i64 index)
    PoolTransactionsGetResult PoolTransactionsGet(1:PoolHash hash, 2:i64 offset, 3:i64 limit)

    StatsGetResult StatsGet()

    SmartContractGetResult SmartContractGet(1:Address address)
    SmartContractsListGetResult SmartContractsListGet(1:Address deployer)
    SmartContractAddressesListGetResult SmartContractAddressesListGet(1:Address deployer)

    TransactionId WaitForSmartTransaction(1:Address smart_public)
    SmartContractsListGetResult SmartContractsAllListGet(1:i64 offset, 2:i64 limit)
}
