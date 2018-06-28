namespace csharp NodeApi
namespace netcore NodeApi
namespace java com.credits.leveldb.client.thrift
namespace cpp api

typedef string Currency
typedef string Address
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
  1: required string address;
  2: string sourceCode;
  3: binary byteCode;
  4: binary contractState;
  5: string hashState;
  6: string method;
  7: list<string> params;
}

//
// Transactions
//

typedef string TransactionHash
typedef string TransactionId
typedef string TransactionInnerId

struct Transaction
{
//  1: TransactionHash hash  // removed. Reason: field removed from db (since version csdb_v2)
    1: TransactionInnerId innerId
    2: Address source
    3: Address target  // now transaction allows set multiple destinations (since version csdb_v2)
    4: Amount amount
    5: Amount balance
    6: Currency currency
    7: SmartContract smartContract
}

typedef list<Transaction> Transactions
typedef list<TransactionId> TransactionIds
typedef list<Address> Addresses

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

typedef list<Pool> Pools

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
    3: Transaction transaction
}

// TransactionsGet

struct TransactionsGetResult
{
    1: APIResponse status
    2: bool result
    3: Transactions transactions
}

struct TransactionFlowResult
{
    1: APIResponse status
}

// PoolListGet

struct PoolListGetResult
{
    1: APIResponse status
    2: bool result
    3: Pools pools
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
    2: Transactions transactions
}

// StatsGet

struct StatsGetResult
{
    1: APIResponse status
    2: StatsPerPeriod stats
}

// NodesInfoGet

typedef string NodeHash
typedef list<NodeHash> NodesHashes

struct NodesInfoGetResult
{
    1: APIResponse status
    2: Count count
    3: NodesHashes nodesHashes
}

// SmartContractGetResult

struct SmartContractGetResult
{
    1: APIResponse status
    2: SmartContract smartContract
}

// SmartContractAddressListGetResult

typedef list<string> SmartContractAddressList
struct SmartContractAddressesListGetResult
{
    1: APIResponse status
    2: SmartContractAddressList addressesList
}

// SmartContractsListGetResult

typedef list<SmartContract> SmartContractsList
struct SmartContractsListGetResult
{
    1: APIResponse status
    2: SmartContractsList smartContractsList
}

service API
{
    BalanceGetResult BalanceGet(1:Address address, 2:Currency currency = 'cs')

    TransactionGetResult TransactionGet(1:TransactionId transactionId)
    TransactionsGetResult TransactionsGet(1:Address address, 2:i64 offset, 3:i64 limit)
    TransactionFlowResult TransactionFlow(1:Transaction transaction)

    PoolListGetResult PoolListGet(1:i64 offset, 2:i64 limit)
    PoolInfoGetResult PoolInfoGet(1:PoolHash hash, 2:i64 index)
    PoolTransactionsGetResult PoolTransactionsGet(1:PoolHash hash, 2:i64 index, 3:i64 offset, 4:i64 limit)

    StatsGetResult StatsGet()
    NodesInfoGetResult NodesInfoGet()

    SmartContractGetResult SmartContractGet(1:Address address)
    SmartContractsListGetResult SmartContractsListGet(1:Address deployer)
    SmartContractAddressesListGetResult SmartContractAddressesListGet(1:Address deployer)
}
