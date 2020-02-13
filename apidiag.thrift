include 'general.thrift'

namespace csharp NodeApiDiag
namespace netcore NodeApiDiag
namespace java com.credits.client.node.diag.thrift.generated
namespace cpp api_diag

struct TransactionId
{
    // block
    1: i64 sequence
    // 0-based index in block
    2: i16 index
}

// Unix timestamp in milliseconds
typedef i64 Time

typedef i64 TransactionInnerId

struct AmountCommission
{
  1: required i16 bits
  2: double value
}

struct Money
{
    // Exact value
    1: general.Amount amount
    // amount in double format
    2: double value
}

struct ContractDeploy
{
  1: string sourceCode
  2: list<general.ByteCodeObject> byteCodeObjects
  3: i32 tokenStandard
}

struct ContractCall
{
  // try call as getter
  1: bool getter
  2: string method
  // Empty on deploy, method params stringified Java-side with conversion to string on execute
  3: list<general.Variant> params //general.Variant+
  // If true, do not emit any transactions to blockchain (execute contract and forget state change if any)
  4: list<general.Address> uses
}

struct ContractState
{
  // true - stored state hash, false - stored state itself (elder transactions only)
  1: bool hashed
  // if hashed == true contains hash, otherwise contains state itself
  2: string content
  // ref start
  3: TransactionId call
  // fee for execution
  4: Money fee
  // returned value
  5: string returned
}

union Contract
{
    // Contract deployment
    1: ContractDeploy deploy
    // Contract invocation
    2: ContractCall call
    // Contract result state
    3: ContractState state
}

union UserFielData
{
    1: i64 integer
    // Binary data or text
    2: string bytes
    3: general.Amount amount
}

struct UserField
{
    1: i8 id
    2: UserFielData data
}

enum TransactionType
{
    // CS transfer
    TT_Transfer,
    // contarct deployment
    TT_ContractDeploy,
    // Contract execution
    TT_ContractCall,
    // Contract replenish (indirect payable() invocation) 
    TT_ContractReplenish,
    // Contract new state
    TT_ContractState,
    // Token deployment
    TT_TokenDeploy,
    // Token transfer
    TT_TokenTransfer,
    // Stake delegation to node address
    TT_Delegation,
    // Cancel stake delegation
    TT_RevokeDelegation,
    // Put some transfer on hold until some codition to release or cancel
    TT_Hold,
    // Release previously hold sum to complete transfer
    TT_Release,
    // Revoke hold to cancel the transfer
    TT_CancelHold,
    // Transfer delayed until some moment
    TT_DelayedTransfer,
    // Service: update current boostrap node list with new one
    TT_UpdateBootstrapList,
    // Malformed (invalid) transaction
    TT_Malformed,
    // Any other type
    TT_Other
}

struct TransactionData
{
    // Inner transaction ID for protection against replay attack
    1: TransactionInnerId id
    // Sender or contract deployer/invoker.
    // In general, the public key to test signature
    2: general.Address source
    // Receiver or contract address
    3: general.Address target
    // Transfer amount for payment transaction
    4: Money sum
    // Fee limitation
    6: AmountCommission max_fee
    // Actual fee to withdraw from source
    7: AmountCommission actual_fee
    // Signature is formed against node's custom binary serialization format,
    // see other docs for description
    8: binary signature
    9: Time timestamp
    10: TransactionType type
    // user fields if any, does not include special contract-related fields
    11: optional list<UserField> userFields
    12: optional Contract contract
}

struct GetTransactionResponse
{
    1: general.APIResponse status
    2: optional TransactionData transaction
}

//////////////////// Starter proto /////////////////////////

enum Platform
{
    OS_Linux, // = 0
    OS_MacOS, // = 1
    OS_Windows // = 2
}

// Active nodes
struct ServerNode
{
    // endpoint.address().to_string()
	1: string ip
    // std::to_string(uint16_t)
	2: string port
    // std::to_string(NODE_VERSION)
	3: string version
    // Utils::byteStreamToHex(cs::Hash);
	4: string hash
    // Utils::byteStreamToHex(cs::PublicKey);
	5: string publicKey
    // enum Platform to string
	6: string platform
    // integer
	7: i32 countTrust
    // std::chrono::system_clock::to_time_t(std::chrono::system_clock::now())
	8: i64 timeRegistration
    // now - timeRegistration - timeNotActive
	9: i64 timeActive
}

struct ActiveNodesResult
{
	1: general.APIResponse result
	2: list<ServerNode> nodes
}

struct ActiveTransactionsResult
{
	1: general.APIResponse result
	2: string count
}

//////////////////// Starter proto end /////////////////////

struct SessionInfo
{
    1: i64 startRound
    2: i64 curRound
    3: i64 lastBlock
    4: i64 uptimeMs
    5: i64 aveRoundMs
}

struct StateInfo
{
    1: i64 transactionsCount
    2: i64 walletsCount
    3: i64 contractsCount
    4: i64 contractsQueueSize
    5: i64 grayListSize
    6: i64 blackListSize
    7: i64 blockCacheSize
}

struct NodeInfo
{
    1: string id
    2: string version
    3: Platform platform
    4: optional SessionInfo session
    5: optional StateInfo state
    6: optional list<string> grayListContent
    7: optional list<string> blackListContent
}

struct NodeInfoRequest
{
    1: bool session
    2: bool state
    3: bool grayListContent
    4: bool blackListContent
}

struct NodeInfoRespone
{
  	1: general.APIResponse result
	2: NodeInfo info
}

service API_DIAG {

    // Former starter node protocol
	
    // returns nodes from server buffer
	ActiveNodesResult GetActiveNodes()
	
    // returns active transactions count
	ActiveTransactionsResult GetActiveTransactionsCount()

    // Diagnostic support
  
    // get detailed transaction info
	GetTransactionResponse GetTransaction(1:TransactionId id)

    // get detailed node info
    NodeInfoRespone GetNodeInfo(1: NodeInfoRequest request)
}
