package ;

using Tools;

class CPU
{
	var memory:Memory;
	var registers:Registers;
	var processor:Map<Int, Void->Void>;

	public function new(memory:Memory)
	{
		this.memory = memory;
		this.registers = new Registers();

		for(x in 0x9FE0 ... 0x9FFF + 1) memory.writeByte(x, 0x11);

		trace(registers.toString());

		processor = [
			0x31 => LD.bind(Registers.SP),
			0x0E => LD.bind(Registers.C),
			0x3E => LD_byte.bind(Registers.A),
			0x21 => LD.bind(Registers.HL),

			0xE2 => LDIOCA,

			0xAF => XOR(Registers.A),

			0x32 => LDHLDA,
			0xCB => BIT7H,
			0x20 => JRNZn,
			//0x3E => LDN.bind(Registers.A),

			0x0C => INC.bind(Registers.C)
		];
	}

	public function reset()
	{
		registers.reset();
	}

	public function dump()
	{
		var opcode = memory.readByte(registers.pc);
		var instruction = Instruction.list[opcode];

		var address = "0x" + StringTools.hex(registers.pc, 2);
		var opcodeHex = "0x" + StringTools.hex(opcode, 2);

		trace("-------------------------------------------------------------------------");
		var dataBytes = [ for(x in 1 ... instruction.size) memory.readByte(registers.pc + x) ].map(Tools.hex.bind(_, 2)).join(" ");
		trace('-- [${address}] ${instruction.tag} (Opcode: ${opcodeHex} Size: ${instruction.size}) ${dataBytes}');
		trace("-------------------------------------------------------------------------");

		trace(registers.toString());

		throw "Dump";
	}

	public function cycle()
	{
		var opcode = memory.readByte(registers.pc);


		if(!Instruction.list.exists(opcode))
		{
			// trace('Unknown Opcode ${opcodeHex} @ ${registers.pc}');
			registers.pc++;

			throw "";
		}

		// Break JUMP
		if(registers.pc == 0x001C) dump();

		registers.pc++;

		if(processor.exists(opcode))
		{
			processor.get(opcode)();
		}
		else
		{
			registers.pc--;
			trace("[WARNING] Missing Opcode: " + opcode.hex());
			dump();
		}

		var instruction = Instruction.list[opcode];
		registers.pc += instruction.size - 1;
		registers.pc &= 65535;
	}

	function INC(register:String)
	{
		trace(registers.values.get(register));
		var value = (registers.values.get(register) + 1) & 0xff;

		//registers.values.set(Registers.HF, (value & 0xf) == 0);

		registers.values.set(register, value & 0xff);
		trace(registers.values.get(register));
	}

	function LDN(register:String)
	{
		registers.values.set(register, memory.readByte(registers.pc + 1));
	}

	function LDIOCA()
	{
		memory.writeByte(0xFF00 | registers.c, registers.a);
		// MMU.wb(+Z80._r.c,Z80._r.a); Z80._r.m=2;
	}

	function JRNZn()
	{
		var i = memory.readByte(registers.pc);

		if(i > 127) i =- ((~i + 1) & 255);

		// ISsue is this should be true...
		if(registers.f != 0x00) {

			//trace("GOTO Address: " + (registers.pc + i).hex());
			registers.pc += i;
		}
		else
		{
			trace("[BREAK] " + (registers.pc).hex());
		}
	}

	function BIT7H()
	{
		var i = memory.readByte(registers.pc);

		if(i == 0x7C)
		{
			registers.f &= 0x1F;
			registers.f |= 0x20;
			registers.f = (registers.h & 0x80 == 0) ? 0 : registers.f;
		}
		else
		{
			throw "UNknown";
		}
	}

	function LDHLDA()
	{
		memory.writeByte((registers.h << 8) + registers.l, registers.a);

		registers.l = registers.l - 1 & 255;

		if(registers.l == 255) registers.h = (registers.h - 1) & 255;
	}

	// Must be 16 bit register
	function LD(register:String)
	{
		//trace(register);
		//if(register.length != 2) throw "Wrong Size Dude";

		var value = register.length == 2 ? memory.readWord(registers.pc) : memory.readByte(registers.pc);

		var valueHex = "0x" + StringTools.hex(value, register.length == 1 ? 2 : 4);
		trace("[LD] " + register + " = " + valueHex);

		Reflect.setProperty(registers, register, value);
	}

	function LD_byte(register:String)
	{
		//if(register.length != 1) throw "Wrong Size Dude";

		var value = memory.readByte(registers.pc);

		var valueHex = "0x" + StringTools.hex(value, 4);
		//trace(register + " = " + valueHex);

		Reflect.setProperty(registers, register, value);
	}

	function LD_ab(registerA:String, registerB:String)
	{
		registers.values[registerA] = registers.values[registerB];
	}

	function XOR(register:String)
	{
		var r = registers.values[register];

		return function()
		{
			r ^= r;
			r &= r;
			registers.f = r;
			registers.f = registers.f == 1 ? 0 : 0x80;
		}
	}
}

