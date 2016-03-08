package ;

class GB
{
	public static function main():Void
	{
		var cpu = new CPU(new Memory(0xFFFF, BIOS.DMG));

		//untyped setInterval(cpu.cycle, 0);

		while(true)
		{
			cpu.cycle();
		}
	}
}