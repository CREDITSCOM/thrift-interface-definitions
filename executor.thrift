include 'general.thrift'
namespace java com.credits.client.executor.thrift.generated
namespace cpp executor

struct ExecuteByteCodeResult {
   1: general.APIResponse status
   2: list<SetterMethodResult> results
}

struct SetterMethodResult {
   1: general.APIResponse status
   2: general.Variant ret_val
   3: map<general.Address, binary> contractsState
   4: list<EmittedTransaction> emittedTransactions
   5: i64 executionCost
}

struct EmittedTransaction {
    1: general.Address source
    2: general.Address target
    3: general.Amount amount
    4: optional binary userData
}

struct GetterMethodResult {
   1: general.APIResponse status
   2: optional general.Variant ret_val 
}

struct ExecuteByteCodeMultipleResult {
   1: general.APIResponse status
   2: list<GetterMethodResult>  results
}

struct GetContractMethodsResult {
    1: general.APIResponse status
    2: list<general.MethodDescription> methods
    3: i64 tokenStandard
}

struct GetContractVariablesResult{
   1: general.APIResponse status
   2: map<string, general.Variant> contractVariables 
}

struct CompileSourceCodeResult {
   1: general.APIResponse status
   2: list<general.ByteCodeObject> byteCodeObjects
}

struct SmartContractBinary {
   1: general.Address contractAddress
   2: general.ClassObject object
   3: bool stateCanModify
}

struct MethodHeader{
   1: string methodName
   2: list<general.Variant> params 
}


service ContractExecutor {
   ExecuteByteCodeResult executeByteCode(1:general.AccessID accessId, 2:general.Address initiatorAddress, 3:SmartContractBinary invokedContract, 4:list<MethodHeader> methods, 5:i64 executionTime, 6:i16 version)
   ExecuteByteCodeMultipleResult executeByteCodeMultiple(1:general.AccessID accessId, 2:general.Address initiatorAddress, 3:SmartContractBinary invokedContract, 4:string method, 5:list<list<general.Variant>> params, 6:i64 executionTime, 7:i16 version)
   GetContractMethodsResult getContractMethods(1:list<general.ByteCodeObject> byteCodeObjects, 2:i16 version)
   GetContractVariablesResult getContractVariables(1:list<general.ByteCodeObject> byteCodeObjects, 2:binary contractState, 3:i16 version)
   CompileSourceCodeResult compileSourceCode(1:string sourceCode, 2:i16 version)
}
