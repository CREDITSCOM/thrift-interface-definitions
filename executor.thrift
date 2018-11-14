include 'general.thrift'
namespace java com.credits.client.executor.thrift.generated
namespace cpp executor

struct MethodDescription {
    1: string name
    2: list<string> argTypes
    3: string returnType
}

struct GetContractMethodsResult {
    1: general.APIResponse status
    2: list<MethodDescription> methods
}

struct ExecuteByteCodeResult
{
    1: general.APIResponse status
	2: binary contractState
	3: optional general.Variant ret_val
	4: optional map<string, general.Variant> contractVariables
}

service ContractExecutor {
	ExecuteByteCodeResult executeByteCode(1:binary address, 2:binary byteCode, 3: binary contractState, 4:string method, 5:list<general.Variant> params)
	GetContractMethodsResult getContractMethods(1: binary bytecode)
}
