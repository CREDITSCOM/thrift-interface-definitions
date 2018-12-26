include 'general.thrift'
namespace java com.credits.client.executor.thrift.generated
namespace cpp executor

struct ExecuteByteCodeResult
{
   1: general.APIResponse status
   2: binary contractState
   3: optional general.Variant ret_val //general.Variant
}

struct GetterMethodResult {
   1: general.APIResponse status
   2: optional general.Variant ret_val //general.Variant
}

struct ExecuteByteCodeMultipleResult {
   1: general.APIResponse status
   2: list<GetterMethodResult>  results
}

struct GetContractMethodsResult {
    1: general.APIResponse status
    2: list<general.MethodDescription> methods
}

struct GetContractVariablesResult{
   1: general.APIResponse status
   2: map<string, general.Variant> contractVariables //general.Variant
}

struct CompileSourceCodeResult {
   1: general.APIResponse status
   2: binary byteCode
}

//struct ExecuteByteCodeResult
//{
//  1: general.APIResponse status
//	2: binary contractState
//	3: optional general.Variant ret_val //general.Variant+
//	4: optional map<string, general.Variant> contractVariables //general.Variant+
//}

service ContractExecutor {
	//ExecuteByteCodeResult executeByteCode(1:binary address, 2:binary byteCode, 3: binary contractState, 4:string method, 5:list<general.Variant> params)
	//GetContractMethodsResult getContractMethods(1: binary byteCode)
   ExecuteByteCodeResult executeByteCode(1:binary address, 2:binary byteCode, 3:binary contractState, 4:string method, 5:list<general.Variant> params, 6:i64 executionTime) //general.Variant+
   ExecuteByteCodeMultipleResult executeByteCodeMultiple(1:binary address, 2:binary byteCode, 3:binary contractState, 4:string method, 5:list<list<general.Variant>> params, 6:i64 executionTime)
   GetContractMethodsResult getContractMethods(1:binary byteCode)
   GetContractVariablesResult getContractVariables(1:binary byteCode, 2:binary contractState)
   CompileSourceCodeResult compileSourceCode(1:string sourceCode)
}
