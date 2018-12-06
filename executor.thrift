include 'general.thrift'
namespace java com.credits.client.executor.thrift.generated
namespace cpp executor

struct MethodArgument {
  1: string type
  2: string name
}

struct MethodDescription {
  1: string returnType
  2: string name
  3: list<MethodArgument> arguments
}

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
    2: list<MethodDescription> methods
}

struct GetContractVariablesResult{
   1: general.APIResponse status
   2: map<string, general.Variant> contractVariables //general.Variant
}

struct CompileByteCodeResult {
   1: general.APIResponse status
   2: binary bytecode
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
	//GetContractMethodsResult getContractMethods(1: binary bytecode)
   ExecuteByteCodeResult executeByteCode(1:binary address, 2:binary bytecode, 3:binary contractState, 4:string method, 5:list<general.Variant> params, 6:i64 executionTime) //general.Variant+
   ExecuteByteCodeMultipleResult executeByteCodeMultiple(1:binary address, 2:binary bytecode, 3:binary contractState, 4:string method, 5:list<list<string>> params, 6:i64 executionTime)
   GetContractMethodsResult getContractMethods(1:binary bytecode)
   GetContractVariablesResult getContractVariables(1:binary bytecode, 2:binary contractState)
   CompileByteCodeResult compileBytecode(1:string sourceCode)
}
