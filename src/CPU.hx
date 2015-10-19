package ;

class CPU
{
    var memory:Memory;
    var registers:Registers;

	public function new(memory:Memory)
	{
        this.memory = memory;
        this.registers = new Registers();

        for(x in 0x9FE0 ... 0x9FFF + 1) memory.writeByte(x, 0x11);

        trace(registers.toString());
	}

	public function reset()
	{
		registers.reset();
	}

    public function cycle()
    {
        var address = "0x" + StringTools.hex(registers.pc, 2);
        var opcode = memory.readByte(registers.pc);
        var opcodeHex = "0x" + StringTools.hex(opcode, 2);

        if(!Instruction.list.exists(opcode))
        {
            trace('Unknown Opcode ${opcodeHex} @ ${registers.pc}');
            registers.pc++;

            if(opcode == 0xCB) // BIT 7,H
	    	{
	    		//Z80._r.f &= 0x1F;
	    		// Z80._r.f |= 0x20;
	    		// Z80._r.f = (Z80._r.h & 0x80) ? 0 : 0x80; 
	    		// Z80._r.m=2;
	    		registers.f &= 0x1F;
	    		registers.f |= 0x20;
	    		registers.f = (registers.h & 0x80 == 1) ? 0 : 0x80; 

	    		registers.pc += 1;
	    	}

            return;
        }

        var instruction = Instruction.list[opcode];

        trace("-------------------------------------------------------------------------");
        var dataBytes = [ for(x in 1 ... instruction.size) memory.readByte(registers.pc + x) ].map(Tools.hex.bind(_, 2)).join(" ");
        trace('-- [${address}] ${instruction.tag} (Opcode: ${opcodeHex} Size: ${instruction.size}) ${dataBytes}');
        trace("-------------------------------------------------------------------------");

        // Break JUMP
        if(registers.pc > 24) {
            throw "Fak";
        };

        registers.pc++;

        //LD SP
        if(opcode == 0x31) LD("sp");
        if(opcode == 0xAF) XOR("a")();
        if(opcode == 0x21) LD("hl");
        if(opcode == 0x32)  //LDHLDA
    	{
			//MMU.wb((Z80._r.h<<8) + Z80._r.l, Z80._r.a);
    		memory.writeByte((registers.h << 8) + registers.l, registers.a);

    		// Z80._r.l = (Z80._r.l-1) & 255;
    		registers.l = registers.l - 1 & 255;
    		
    		//if(Z80._r.l==255) Z80._r.h = (Z80._r.h-1) & 255;
    		if(registers.l == 255) registers.h = (registers.h - 1) & 255;
    	}

    	if(opcode == 0x20)
    	{
    		//var i = MMU.rb(Z80._r.pc);
    		var i = memory.readByte(registers.pc);

    		trace("Reading Address: " + StringTools.hex(registers.pc, 2) + " = " + StringTools.hex(i, 2));
    		//throw "";

    		//if(i>127) i=-((~i+1)&255);
    		if(i > 127) i =- ((~i + 1) & 255);

    		//Z80._r.pc++;
    		registers.pc+= 2;

    		//Z80._r.m=2; 

    		// if((Z80._r.f&0x80) == 0x00)
    		// {
    		// 	Z80._r.pc+=i;
    		// 	Z80._r.m++;
    		// }

    		// ISsue is this should be true...
    		if((registers.f & 0x80) == 0x00) {
    			trace("return");
    			registers.pc += i;
    		}
    	}

        //if()size > 0
        registers.pc += instruction.size - 1;


        trace(registers.toString());
        memory.print(/*0x8000*/ 0x9FE0, 0x9FFF + 1);
        
    }

    // must be 16 bit register
    function LD(register:String)
    {    
    	var value = memory.readWord(registers.pc);

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
	        registers.f == 1 ? 0 : 0x80;
    	}
    }
}
