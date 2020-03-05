namespace java com.credits.general.thrift.generated
namespace cpp general
namespace csharp NodeApi
namespace netcore NodeApi

typedef i64 AccessID
typedef binary Address

struct ClassObject {
   1: list<ByteCodeObject> byteCodeObjects
   2: binary instance
}

struct object {
	1: string nameClass
	2: binary instance
}

struct Amount
{
  1: required i32 integral = 0;
  2: required i64 fraction = 0;
}

union Variant {
	1: string v_null;
	2: i8 v_void;
	3: bool v_boolean;
	4: bool v_boolean_box;
	5: i8 v_byte;
	6: i8 v_byte_box;
	7: i16 v_short;
	8: i16 v_short_box;
	9: i32 v_int;
	10: i32 v_int_box;		
	11: i64 v_long;
	12: i64 v_long_box;
	13: double v_float;
	14: double v_float_box;
	15: double v_double;
	16: double v_double_box;
	17: string v_string;
	18: object v_object;
	19: list<Variant> v_array;
	20: list<Variant> v_list;
	21: set<Variant> v_set;
	22: map<Variant, Variant> v_map;
	23: string v_big_decimal;
	24: Amount v_amount;
	25: binary v_byte_array;
}

struct Annotation {
	1:string name
	2:map<string, string> arguments
}

struct MethodArgument {
  1: string type
  2: string name
  3: list<Annotation> annotations
}

struct MethodDescription {
  1: string returnType
  2: string name
  3: list<MethodArgument> arguments
  4: list<Annotation> annotations
}

struct ByteCodeObject {
  1: string name
  2: binary byteCode
}

//
// API responses
//
struct APIResponse
{
    1: i8 code // 0 for success, 1 for failure, 2 for not being implemented (currently unused)
    2: string message // Explanation
}