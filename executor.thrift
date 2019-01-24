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
   2: list<general.ByteCodeObject> byteCodeObjects
}

//struct ExecuteByteCodeResult
//{
//  1: general.APIResponse status
//	2: binary contractState
//	3: optional general.Variant ret_val //general.Variant+
//	4: optional map<string, general.Variant> contractVariables //general.Variant+
//}

service ContractExecutor {
	//ExecuteByteCodeResult executeByteCode(1:binary address, 2:list<general.ByteCodeObject> byteCodeObjects, 3: binary contractState, 4:string method, 5:list<general.Variant> params)
	//GetContractMethodsResult getContractMethods(1: list<general.ByteCodeObject> byteCodeObjects)
   //ExecuteByteCodeResult executeByteCode(1:binary address, 2:list<general.ByteCodeObject> byteCodeObjects, 3:binary contractState, 4:string method, 5:list<general.Variant> params, 6:i64 executionTime) //general.Variant+
   //ExecuteByteCodeMultipleResult executeByteCodeMultiple(1:binary address, 2:list<general.ByteCodeObject> byteCodeObjects, 3:binary contractState, 4:string method, 5:list<list<general.Variant>> params, 6:i64 executionTime)
   
   ExecuteByteCodeResult executeByteCode(1:binary initiatorAddress, 2:binary contractAddress, 3:list<general.ByteCodeObject> byteCodeObjects, 4:binary contractState, 5:string method, 6:list<general.Variant> params, 7:i64 executionTime) //general.Variant+
   ExecuteByteCodeMultipleResult executeByteCodeMultiple(1:binary initiatorAddress, 2:binary contractAddress, 3:list<general.ByteCodeObject> byteCodeObjects, 4:binary contractState, 5:string method, 6:list<list<general.Variant>> params, 7:i64 executionTime)
   
   GetContractMethodsResult getContractMethods(1:list<general.ByteCodeObject> byteCodeObjects)
   GetContractVariablesResult getContractVariables(1:list<general.ByteCodeObject> byteCodeObjects, 2:binary contractState)
   CompileSourceCodeResult compileSourceCode(1:string sourceCode)
}
