package ;

import haxe.io.Bytes;

using Lambda;
using Tools;

class Memory
{
	var memory:Bytes;

	var debug = false;

	public function new(size:Int = 255, defaultData:Array<Int> = null)
	{
		memory = Bytes.alloc(size);

		for (x in 0 ... size)
		{
			writeByte(x, 0xFF);
		}

		if(defaultData != null)
		{
			for (x in 0 ... defaultData.length)
			{
				writeByte(x, defaultData[x]);
			}
		}

		debug = true;
	}

	public function readByte(address:Int):Int
	{
		return memory.get(address);
	}

	public function writeByte(address:Int, value:Int):Void
	{
		if(debug && address < 0xFF) throw "NOT ALLOWED";

		memory.set(address, value);

		// if(debug) trace(address.hex(4) + " = " + value.hex(2));
	}

	public function readWord(address:Int):Int
	{
		return (memory.get(address + 1) << 8) | memory.get(address);
	}

	public function print(start:Int, end:Int)
	{
		var result = "";

		for (x in start ... end)
		{
			if((x - start) % 16 == 0)
			{
				result += (x - start == 0 ? "" : "\n") + "[" + x.hex() + "] ";
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