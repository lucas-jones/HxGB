package ;

import haxe.io.Bytes;

using Lambda;
using Tools;

class Memory
{
	var memory:Bytes;

	public function new(size:Int = 255, defaultData:Array<Int> = null)
	{
		memory = Bytes.alloc(size);

		if(defaultData != null)
		{
			for (x in 0 ... defaultData.length)
			{
				writeByte(x, defaultData[x]);
			}
		}
	}

	public function readByte(address:Int):Int
	{
		return memory.get(address);
	}

	public function writeByte(address:Int, value:Int):Void
	{
		memory.set(address, value);
	}

	public function readWord(address:Int):Int
	{
		return (memory.get(address + 1) << 8) + memory.get(address);
	}

	public function print(start:Int, end:Int)
	{
		var result = "";

		for (x in start ... end)
		{
			if((x - start) % 60 == 0)
			{
				result += (x - start == 0 ? "" : "\n") + "[0x00" + x.hex() + "] ";
				result += readByte(x).hex().substring(2, 4) + " ";
			}
			else
			{
				result += readByte(x).hex().substring(2, 4) + " ";
			}
		}

		trace(result);
	}
}