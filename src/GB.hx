package ;

class GB
{
	public static function main():Void
	{
		var cpu = new CPU(new Memory(256, BIOS.DMG));

		//untyped setInterval(cpu.cycle, 0);

		while(true)
		{
			cpu.cycle();
		}		
	}
}