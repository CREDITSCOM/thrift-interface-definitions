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
  3: string hashState
  4: i32 tokenStandard
}

struct ContractCall
{
  1:  i16 version = 1;
  // try call as getter
  2: bool getter
  3: string method
  // Empty on deploy, method params stringified Java-side with conversion to string on execute
  4: list<general.Variant> params //general.Variant+
  // If true, do not emit any transactions to blockchain (execute contract and forget state change if any)
  5: list<general.Address> uses
}

union UserFielData
{
    1: i64 integer
    // Binary data or text
    2: string bytes
    3: general.Amount amount
    // Contract deployment
    4: ContractDeploy deploy
    // Contract invocation
    5: ContractCall call
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
    TT_ContractExecute,
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
    // user fields if any
    11: optional list<UserField> userFields
}

struct GetTransactionResponse
{
    1: general.APIResponse status
    2: optional TransactionData transaction
}

service API_DIAG {
	GetTransactionResponse GetTransaction(1:TransactionId id)
}
