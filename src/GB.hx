package ;

class GB
{
	public static function main():Void
	{
		var cpu = new CPU(new Memory(256, BIOS.DMG));

		while(true)
		{
			cpu.cycle();
		}
	}
}