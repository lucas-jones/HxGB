package ;

using Tools;

class Registers
{
	public static var F:String = "f";
	public static var SP:String = "sp";
	public static var PC:String = "pc";
	public static var H:String = "h";
	public static var L:String = "l";
	public static var A:String = "a";
	public static var B:String = "b";
	public static var C:String = "c";

	public static var HL:String = H + L;
	public static var HF:String = H + F;

	public static var ALL:Array<String> = [ F, SP, PC, H, L, A, B, C, HF ];

	public var sp(get, set):Int;
	public var pc(get, set):Int;

	public var hl(get, set):Int;
	public var hf(get, set):Int;

	public var a(get, set):Int;
	public var b(get, set):Int;
	public var c(get, set):Int;

	public var f(get, set):Int;
	public var h(get, set):Int;
	public var l(get, set):Int;

	public var values:Map<String, Int>;

	public function new()
	{
		values = new Map();

		reset();
	}

	public function reset()
	{
		for(reg in ALL)
		{
			values.set(reg, 0);
		}
	}

	public function toString():String
	{
		return [
			"SP: " + sp.hex() + "\tHL: " + hl.hex() + "(H: " + h.hex() + ", " + l.hex() + ")",
			"A: " + a.hex() + " F:" + f.hex(),
			"B: " + b.hex() + " C:" + c.hex()

		].join("\n");
	}

	function get_f():Int
	{
		return values[F];
	}

	function set_f(value:Int):Int
	{
		values[F] = value;

		return value;
	}

	function get_h():Int
	{
		return values[H];
	}

	function set_h(value:Int):Int
	{
		values[H] = value;

		return value;
	}

	function get_l():Int
	{
		return values[L];
	}

	function set_l(value:Int):Int
	{
		values[L] = value;

		return value;
	}

	function get_a():Int
	{
		return values[A];
	}

	function set_a(value:Int):Int
	{
		values[A] = value;

		return value;
	}

	function get_b():Int
	{
		return values[B];
	}

	function set_b(value:Int):Int
	{
		values[B] = value;

		return value;
	}

	function get_c():Int
	{
		return values[C];
	}

	function set_c(value:Int):Int
	{
		values[C] = value;

		return value;
	}

	function get_hl():Int
	{
		return (values[H] << 8) + values[L];
	}

	function set_hl(value:Int):Int
	{
		values[L] = (value & 255);
		values[H] = (value >> 8);

		return value;
	}

	function get_hf():Int
	{
		return (values[H] << 8) + values[F];
	}

	function set_hf(value:Int):Int
	{
		values[F] = (value & 255);
		values[H] = (value >> 8);

		return value;
	}

	function get_sp():Int
	{
		return values[SP];
	}

	function set_sp(value:Int):Int
	{
		values[SP] = value;

		return value;
	}

	function get_pc():Int
	{
		return values[PC];
	}

	function set_pc(value:Int):Int
	{
		values[PC] = value;

		return value;
	}
}