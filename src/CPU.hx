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


		processor = [
			0x31 => LD.bind(Registers.SP),
			0x0E => LD.bind(Registers.C),
			0x3E => LD.bind(Registers.A),
			0x21 => LD.bind(Registers.HL),

			0xE2 => LDIOCA,	// write(0xFF00 | c, a);
			0x32 => LDHLDA,	// write(hl--, a);

			0xAF => XOR(Registers.A),

			0x0C => INC.bind(Registers.C),

			0x20 => JRNZn,
			0xCB => BIT7H,

			0x77 => WRITE.bind(Registers.HL, Registers.A),

			0xE0 => function()
			{
				//write(0xff00 | readpc(), a);
				memory.writeByte(0xff00 | registers.pc, registers.a);
			},

			0x11 => LD.bind(Registers.DE),

			0x1A => function()
			{
				// a = read(de);
				trace(registers.pc.hex());

				registers.a = memory.readByte(registers.de);
				// trace("HELLO WORLD");
			},

			0xCD => CALL,

			0x4F => function()
			{
				registers.c = registers.a;
			}
		];
	}

	public function reset()
	{
		registers.reset();
	}

	public function cycle()
	{
		var opcode = memory.readByte(registers.pc);

		if(!Instruction.list.exists(opcode))
		{
			throw 'Unknown Instruction ${opcode.hex()} @ ${registers.pc}';
		}

		if(processor.exists(opcode))
		{
			//trace("-> " + opcode.hex() + " @ " + registers.pc.hex(4));

			registers.pc++;


			processor.get(opcode)();
		}
		else
		{
			dump();

			throw "Missing Opcode: " + opcode.hex();
		}

		registers.pc += Instruction.list[opcode].size - 1;
		registers.pc &= 65535;
	}

	function CALL()
	{
		var newSP = memory.readWord(registers.pc);

		PUSH_STACK(registers.pc);
		registers.pc = newSP + 1; // wat

		trace("CALL FUNCTION @ " + registers.pc.hex(4));
	}

	function PUSH_STACK(value:Int)
	{
		memory.writeByte((--registers.sp) & 0xffff, value >> 8);
		memory.writeByte((--registers.sp) & 0xffff, value & 0xff);

		registers.sp &= 0xffff;
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

	function WRITE(addressReg:String, valueReg:String)
	{
		memory.writeByte(registers.values[addressReg], registers.values[valueReg] & 0xff);
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

		if(i == 0x7C) // 0x4f: // BIT 1,A
		{
			registers.f &= 0x1F;
			registers.f |= 0x20;
			registers.f = (registers.h & 0x80 == 0) ? 0 : registers.f;
		}
		else
		{
			dump();

			registers.pc--;

			throw "Unknown BIT " + i.hex();


		}
	}

	function LDHLDA()
	{
		memory.writeByte((registers.h << 8) + registers.l, registers.a);

		registers.l = registers.l - 1 & 255;

		if(registers.l == 255) registers.h = (registers.h - 1) & 255;
	}

	// Magic can do 8 & 16 bit
	function LD(register:String)
	{
		var value = register.length == 2 ? memory.readWord(registers.pc) : memory.readByte(registers.pc);

		Reflect.setProperty(registers, register, value);

		trace("[LD] " + register + " = " + "0x" + StringTools.hex(value, register.length == 1 ? 2 : 4));
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

	public function dump()
	{
		trace("_______________________________________________________________________________________");
		trace("---------------------------------------------------------------------------------------");

		trace('');
		instruction();
		trace('');
		stack();
		trace('');
	}

	public function instruction()
	{
		var opcode = memory.readByte(registers.pc);
		var instruction = Instruction.list[opcode];

		var address = registers.pc.hex(2);
		var opcodeHex = opcode.hex(2);

		var dataBytes = [ for(x in 1 ... instruction.size) memory.readByte(registers.pc + x) ].map(Tools.hex.bind(_, 2)).join(" ");

		trace('\n\tInstruction\n\n');
		trace('\t\tOpcode\t\t${opcodeHex}\t${instruction.tag}');
		trace('\t\tLocation\t${address}');
		trace('\t\tSize\t\t${instruction.size}');
		if(dataBytes.length > 0) trace('\t\tData\t\t${dataBytes}');
	}

	public function stack()
	{
		trace('\n\tRegisters\n\n');
		trace('\t\t' + registers.toString().split("\n").join("\n\t\t"));
		trace('');
	}
}