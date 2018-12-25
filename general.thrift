namespace java com.credits.general.thrift.generated
namespace cpp general

union Variant {
	1: byte v_null;
	2: bool v_boolean;
	3: bool v_boolean_box;
	4: i8 v_byte;
	5: i8 v_byte_box;
	6: i16 v_short;
	7: i16 v_short_box;
	8: i32 v_int;
	9: i32 v_int_box;		
	10: i64 v_long;
	11: i64 v_long_box;
	12: double v_float;
	13: double v_float_box;
	14: double v_double;
	15: double v_double_box;
	16: string v_string;
	17: list<Variant> v_list;
	18: set<Variant> v_set;
	19: map<Variant, Variant> v_map;
	20: list<Variant> v_array;
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