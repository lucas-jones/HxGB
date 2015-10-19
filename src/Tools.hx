package ;

class Tools
{
	public static inline function hex(value:Int, size:Int = 1):String
	{
		var result = StringTools.hex(value, size);

		return (value < 0x10 ? "0x0" : "0x") + result;
	}
}