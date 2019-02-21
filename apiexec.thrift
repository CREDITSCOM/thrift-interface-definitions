include 'general.thrift'
include 'api.thrift'
namespace java com.credits.client.executor.thrift.generated.apiexec
namespace cpp apiexec

struct GetSeedResult
{
	1: general.APIResponse status
	2: binary seed;
}

struct GetSmartCodeResult
{
	1: general.APIResponse status
	2: list<general.ByteCodeObject> byteCodeObjects
	3: binary contractState
}

struct SendTransactionResult
{
	1: general.APIResponse status
}

struct SmartContractGetResult
{
	1: list<general.ByteCodeObject> byteCodeObjects
	2: binary contractState
	3: bool stateCanModify
}

service APIEXEC{
	GetSeedResult GetSeed(1:general.AccessID accessId)
	GetSmartCodeResult GetSmartCode(1:general.AccessID accessId, 2:general.Address address)
	SendTransactionResult SendTransaction(1:api.Transaction transaction)
	api.WalletIdGetResult WalletIdGet(1:general.Address address)
	SmartContractGetResult SmartContractGet(1:general.Address address)
}