namespace * variant

union variant {
	1: bool v_bool;
	2: i8 v_i8;
	3: i16 v_i16;
	4: i32 v_i32;
	5: i64 v_i64;
	6: double v_double;
	7: string v_string;
	8: list<variant> v_list;
	9: set<i16> i16_set;
	10: set<i32> i32_set;
	11: set<i64> i64_set;
	12: set<string> string_set;
	13: map<i16, variant> i16_map;
	14: map<i32, variant> i32_map;
	15: map<i64, variant> i64_map;
	16: map<string, variant> string_map;
}