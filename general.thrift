namespace java com.credits.general.thrift.generated
namespace cpp general

union Variant {
	1: bool v_bool;
	2: i8 v_i8;
	3: i16 v_i16;
	4: i32 v_i32;
	5: i64 v_i64;
	6: double v_double;
	7: string v_string;
	8: list<Variant> v_list;
	9: set<Variant> v_set;
	10: map<Variant, Variant> v_map;
}

struct MethodArgument {
  1: string type
  2: string name
}

struct MethodDescription {
  1: string returnType
  2: string name
  3: list<MethodArgument> arguments
}

//
// API responses
//

struct APIResponse
{
	// 0 for success, 1 for failure, 2 for not being implemented (currently unused)
    1: i8 code
	// Explanation
    2: string message
}