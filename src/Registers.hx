package ;

using Tools;

class Flags
{
	public var carry:Bool = true;
	public var half:Bool = true;
	public var zero:Bool = true;
	public var addsub:Bool = false;

	public function new()
	{

	}
}

class Registers
{
	public static var SP:String = "sp";
	public static var PC:String = "pc";
	public static var A:String = "a";
	public static var B:String = "b";
	public static var C:String = "c";
	public static var D:String = "d";
	public static var E:String = "e";
	public static var F:String = "f";
	public static var H:String = "h";
	public static var L:String = "l";
	public static var HL:String = H + L;
	public static var HF:String = H + F;
	public static var DE:String = D + E;
	public static var BC:String = B + C;
	public static var CF:String = C + F;

	public static var ALL:Array<String> = [ SP, PC, A, B, C, D, E, F, H, L,  HL, HF, DE, BC, CF ];

	public var sp(get, set):Int;
	public var pc(get, set):Int;

	public var a(get, set):Int;
	public var b(get, set):Int;
	public var c(get, set):Int;
	public var d(get, set):Int;
	public var e(get, set):Int;
	public var f(get, set):Int;
	public var h(get, set):Int;
	public var l(get, set):Int;

	public var hl(get, set):Int;
	public var hf(get, set):Int;
	public var de(get, set):Int;
	public var bc(get, set):Int;
	public var cf(get, set):Int;

	public var flags:Flags;

	public var values:Map<String, Int>;

	public function new()
	{
		flags = new Flags();

		values = new Map();

		reset();
	}

	public function reset()
	{
		for(reg in ALL)
		{
			values.set(reg, 0);
		}

		flags.carry = true;
		flags.half = true;
		flags.zero = true;
		flags.addsub = false;
	}

	public function toString():String
	{
		// return [
		// 	"SP  " + sp.hex() + "\t"	+"PC  " + pc.hex(4),
		// 	"A   " + a.hex() + "\t"+ "B   " + b.hex(),
		// 	"C   " + c.hex() + "\t"+ "D   " + d.hex(),
		// 	"E   " + e.hex() + "\t"+ "F   " + f.hex(),
		// 	"H   " + h.hex() + "\t"+ "L   " + l.hex(),
		// 	"DE  " + de.hex(4)
		// ].join("\n");

		return [
			"A   " + a.hex() + "\t"+ "F  " + f.hex(),
			"B  " + b.hex() + "\t"+ "C   " + c.hex(),
			"D   " + d.hex() + "\t"+ "E   " + e.hex(),
			"H   " + h.hex() + "\t"+ "L   " + l.hex()
		].join("\n");
	}

	function get_d():Int
	{
		return values[D];
	}

	function set_d(value:Int):Int
	{
		values[D] = value;

		return value;
	}

	function get_e():Int
	{
		return values[E];
	}

	function set_e(value:Int):Int
	{
		values[E] = value;

		return value;
	}

	function get_f():Int
	{
		return (flags.zero ? 0x80 : 0x00) | (flags.addsub ? 0x40 : 0) | (flags.half ? 0x20 : 0) | (flags.carry ? 0x10 : 0);
	}

	function set_f(value:Int):Int
	{
		flags.carry = (value & (1 << 4)) != 0;
		flags.half = (value & (1 << 5)) != 0;
		flags.addsub = (value & (1 << 6)) != 0;
		flags.zero = (value & (1 << 7)) != 0;

		values[F] = value; // ?

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
		return (values[H] << 8) | values[L];
	}

	function set_hl(value:Int):Int
	{
		values[H] = (value & 0xff00) >> 8;
		values[L] = value & 0xff;

		return value;
	}

	function get_hf():Int
	{
		return (values[H] << 8) | values[F];
	}

	function set_hf(value:Int):Int
	{
		values[H] = (value & 0xff00) >> 8;
		values[F] = value & 0xff;

		return value;
	}

	function get_de():Int
	{
		return (values[D] << 8) | values[E];
	}

	function set_de(value:Int):Int
	{
		values[D] = (value & 0xff00) >> 8;
		values[E] = value & 0xff;

		return value;
	}

	function get_bc():Int
	{
		return (values[B] << 8) | values[C];
	}

	function set_bc(value:Int):Int
	{
		values[B] = (value & 0xff00) >> 8;
		values[C] = value & 0xff;

		return value;
	}

	function get_cf():Int
	{
		return (values[C] << 8) | values[F];
	}

	function set_cf(value:Int):Int
	{
		values[C] = (value & 0xff00) >> 8;
		values[F] = value & 0xff;

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