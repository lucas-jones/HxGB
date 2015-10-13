package ;

import haxe.Resource;

class Z80
{
	public var pc:Int;	// Program Counter	
	public var sp:Int;	// Stack Pointer
	public var p:Int;	// Processor Flags

	public var a:Int;
	public var x:Int;
	public var y:Int;
}

class GB
{
	public static function main():Void
	{
		trace("Hello GB");

		var rom = Resource.getBytes("rom");

        trace(rom.length);
		
	}
}