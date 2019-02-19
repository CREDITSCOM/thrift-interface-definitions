include 'general.thrift'
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

service APIEXEC{
	GetSeedResult GetSeed(1:general.AccessID accessId)
	GetSmartCodeResult GetSmartCode(1:general.AccessID accessId, 2:general.Address address)
}