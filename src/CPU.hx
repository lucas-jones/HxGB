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
			0x06 => LD.bind(Registers.B),
			0x11 => LD.bind(Registers.DE),

			0xE2 => LDIOCA,	// write(0xFF00 | c, a);
			0x32 => LDHLDA,	// write(hl--, a);

			0xAF => XOR(Registers.A),

			0x0C => INC.bind(Registers.C),
			0x13 => INC.bind(Registers.D),

			0xEA => function()
			{

				registers.a = memory.readWord(registers.pc);
			},

			0x20 => JRNZn,
			0xCB => BIT7H,

			0x77 => function()
			{
				memory.writeByte(registers.hl, registers.a);
			},

			0xE0 => function()
			{
				//write(0xff00 | readpc(), a);
				memory.writeByte(0xff00 | registers.pc, registers.a);
			},

			0x1A => LD_MEMORY.bind(Registers.A, Registers.DE),

			0xCD => CALL,

			0x4F => function()
			{
				registers.c = registers.a;
			},

			0xC5 => function()
			{
				PUSH_STACK(registers.bc);
				// registers.sp--;
				// trace("PUSH STACK: " + registers.bc.hex(4));
			},

			0x17 => RLA,

			0xC1 => function()
			{
				registers.bc = POP_STACK();

				// trace("POP STACK: " + registers.bc.hex(4));
			},

			0x05 => DEC.bind(Registers.B),
			0x3D => DEC.bind(Registers.A),

			// 0x28 => function()
			// {
			// 	if(registers.flags.zero)
			// 	{
			// 		var inc = memory.readByte(registers.pc);
			// 		registers.pc += inc;

			// 		trace("not exit?");
			// 	}
			// 	else
			// 	{
			// 		trace("EXIT?");
			// 		++registers.pc;
			// 	}
			// },

			0x22 => function()
			{
				memory.writeByte(registers.hl++, registers.a);
			},

			0x23 => function()
			{
				registers.hl++;
			},

			0xC9 => function()
			{
				trace("POPING STACK " + registers.pc);

				registers.pc = POP_STACK();

				trace(registers.pc.hex());
			}
		];

		memory.print(0, 0x100);
	}

	public function reset()
	{
		registers.reset();
	}

	public function cycle()
	{
		// Breakpoint
		// if(registers.pc == 0x00A7)
		// {
		// 	// memory.print(0, 0x100);
		// 	dump();
		// 	throw "";
		// }

		var opcode = memory.readByte(registers.pc);

		if(!Instruction.list.exists(opcode))
		{
			throw "Unknown Instruction " + opcode.hex() + " @ " + registers.pc.hex();
		}

		if(processor.exists(opcode))
		{
			trace("-> " + opcode.hex() + " @ " + registers.pc.hex(4) + " " + Instruction.list.get(opcode).tag);

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

	function POP_STACK()
	{
		// READ WORD?
		return (memory.readByte(registers.sp++) | (memory.readByte(registers.sp++) << 8)) & 0xffff;
	}

	function INC(register:String)
	{
		trace(registers.values.get(register));
		var value = (registers.values.get(register) + 1) & 0xff;

		//registers.values.set(Registers.HF, (value & 0xf) == 0);

		registers.values.set(register, value & 0xff);
		trace(registers.values.get(register));
	}

	function DEC(register:String)
	{
		var val = registers.values.get(register);

		val = (val - 1) & 0xff;

		registers.flags.zero = val == 0;
		registers.flags.half = val & 0xf == 0xf;
		registers.flags.addsub = true;

		registers.values.set(register, val & 0xff);
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
		// var i = memory.readByte(registers.pc);

		// if(i > 127) i =- ((~i + 1) & 255);

		// // ISsue is this should be true...
		// if(registers.f != 0x00) {

		// 	//trace("GOTO Address: " + (registers.pc + i).hex());
		// 	registers.pc += i;
		// }
		// else
		// {
		// 	trace("[BREAK] " + (registers.pc).hex());
		// }

		if(!registers.flags.zero)
		{
			var jump = (memory.readByte(registers.pc) ^ 0x80) - 0x80;
			registers.pc += jump;
			trace("Jump " + registers.pc.hex() + " - " + registers.b);
		}
		else
		{
			// ++registers.pc;
			trace("BREAK");
		}
	}

	function BIT7H()
	{
		var i = memory.readByte(registers.pc);

		if(i == 0x7C) // 0x4f: // BIT 1,A
		{
			registers.flags.half = true;
			registers.flags.addsub = false;
			registers.flags.zero = !((registers.h & (1 << 7)) != 0);

			// registers.f &= 0x1F;
			// registers.f |= (registers.h & 0x80 == 0);
			//registers.f = (registers.h & 0x80 == 0) ? 0 : registers.f;
		}
		else if(i == 0x11)
		{
			registers.c = rl(registers.c);
		}
		else
		{
			dump();

			registers.pc--;

			trace("???????");

			throw "Unknown BIT " + i.hex();


		}
	}

	function rl(value:Int)
	{
		var newCf = value > 0x7f;
		value = ((value << 1) & 0xff) | (registers.flags.carry ? 1 : 0);
		registers.flags.carry = newCf;

		registers.flags.half = registers.flags.addsub = false;
		registers.flags.zero = value == 0;

		return value & 0xff;
	}

	function RLA()
	{
		var carry = registers.flags.carry ? 1 : 0;

		registers.flags.carry = registers.a > 0x7f;

		registers.a = ((registers.a << 1) & 0xff) | carry;

		registers.flags.zero = registers.flags.addsub = registers.flags.half = false;
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

	function LD_MEMORY(registerA:String, registerB:String)
	{

		registers.values[registerA] =  memory.readByte(registers.de);

		//trace(registerA + " = " + registerB + "  -  " + registers.values[registerA] + " = " + registers.values[registerB].hex(4));

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