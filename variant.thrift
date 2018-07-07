
namespace cpp variant
namespace java com.credits.thrift.generated

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