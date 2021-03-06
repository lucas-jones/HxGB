package ;

class Instruction
{
    public static var list:Map<Int, Instruction> =
    [
        0x00 => new Instruction(1, 1, "NOP"),
        0x01 => new Instruction(3, 3, "LD BC, nn"),
        0x02 => new Instruction(1, 2, "LD (BC), A"),
        0x03 => new Instruction(1, 2, "INC BC"),
        0x04 => new Instruction(1, 1, "INC B"),
        0x05 => new Instruction(1, 1, "DEC B"),
        0x06 => new Instruction(2, 2, "LD B, n"),
        0x07 => new Instruction(1, 1, "RLCA"),
        0x08 => new Instruction(3, 5, "LD (nn), SP"),
        0x09 => new Instruction(1, 2, "ADD HL, BC"),
        0x0A => new Instruction(1, 2, "LD A, (BC)"),
        0x0B => new Instruction(1, 2, "DEC BC"),
        0x0C => new Instruction(1, 1, "INC C"),
        0x0D => new Instruction(1, 1, "DEC C"),
        0x0E => new Instruction(2, 2, "LD C, n"),
        0x0F => new Instruction(1, 1, "RRCA"),
        0x10 => new Instruction(1, 2, "STOP"),
        0x11 => new Instruction(3, 3, "LD DE, nn"),
        0x12 => new Instruction(1, 2, "LD (DE), A"),
        0x13 => new Instruction(1, 2, "INC DE"),
        0x14 => new Instruction(1, 1, "INC D"),
        0x15 => new Instruction(1, 1, "DEC D"),
        0x16 => new Instruction(2, 2, "LD D, n"),
        0x17 => new Instruction(1, 1, "RLA"),
        0x18 => new Instruction(0, 3, "JR, $+e"),
        0x19 => new Instruction(1, 2, "ADD HL, DE"),
        0x1A => new Instruction(1, 2, "LD A, (DE)"),
        0x1B => new Instruction(1, 2, "DEC DE"),
        0x1C => new Instruction(1, 1, "INC E"),
        0x1D => new Instruction(1, 1, "DEC E"),
        0x1E => new Instruction(2, 2, "LD E, n"),
        0x1F => new Instruction(1, 1, "RRA"),
        0x20 => new Instruction(2, 0, "JR NZ, nn"), // <-- Mine
        0x21 => new Instruction(3, 3, "LD HL, nn"),
        0x22 => new Instruction(1, 2, "LD (HLI), A"),
        0x23 => new Instruction(1, 2, "INC HL"),
        0x24 => new Instruction(1, 1, "INC H"),
        0x25 => new Instruction(1, 1, "DEC H"),
        0x26 => new Instruction(2, 2, "LD H, n"),
        0x27 => new Instruction(1, 1, "DAA"),
        0x28 => new Instruction(0, 0, "JR Z, $ + e"),
        0x29 => new Instruction(1, 2, "ADD HL, HL"),
        0x2A => new Instruction(1, 2, "LD A, (HLI)"),
        0x2B => new Instruction(1, 2, "DEC HL"),
        0x2C => new Instruction(1, 1, "INC L"),
        0x2D => new Instruction(1, 1, "DEC L"),
        0x2E => new Instruction(2, 2, "LD L, n"),
        0x2F => new Instruction(1, 1, "CPL"),
        0x30 => new Instruction(0, 0, "JR NC, $+e"),
        0x31 => new Instruction(3, 3, "LD SP, nn"),
        0x32 => new Instruction(1, 2, "LD (HLD), A"),
        0x33 => new Instruction(1, 2, "INC SP"),
        0x34 => new Instruction(1, 3, "INC (HL)"),
        0x35 => new Instruction(1, 3, "DEC (HL)"),
        0x36 => new Instruction(2, 3, "LD (HL), n"),
        0x37 => new Instruction(1, 1, "SCF"),
        0x38 => new Instruction(0, 0, "JR, C, $+e"),
        0x39 => new Instruction(1, 2, "ADD HL, SP"),
        0x3A => new Instruction(1, 2, "LD A, (HL-)"),
        0x3B => new Instruction(1, 2, "DEC SP"),
        0x3C => new Instruction(1, 1, "INC A"),
        0x3D => new Instruction(1, 1, "DEC A"),
        0x3E => new Instruction(2, 2, "LD A, n"),
        0x3F => new Instruction(1, 1, "CCF"),
        0x40 => new Instruction(1, 1, "LD B, B"),
        0x41 => new Instruction(1, 1, "LD B, C"),
        0x42 => new Instruction(1, 1, "LD B, D"),
        0x43 => new Instruction(1, 1, "LD B, E"),
        0x44 => new Instruction(1, 1, "LD B, H"),
        0x45 => new Instruction(1, 1, "LD B, L"),
        0x46 => new Instruction(1, 2, "LD B, (HL)"),
        0x47 => new Instruction(1, 1, "LD B, A"),
        0x48 => new Instruction(1, 1, "LD C, B"),
        0x49 => new Instruction(1, 1, "LD C, C"),
        0x4A => new Instruction(1, 1, "LD C, D"),
        0x4B => new Instruction(1, 1, "LD C, E"),
        0x4C => new Instruction(1, 1, "LD C, H"),
        0x4D => new Instruction(1, 1, "LD C, L"),
        0x4E => new Instruction(1, 2, "LD C, (HL)"),
        0x4F => new Instruction(1, 1, "LD C, A"),
        0x50 => new Instruction(1, 1, "LD D, B"),
        0x51 => new Instruction(1, 1, "LD D, C"),
        0x52 => new Instruction(1, 1, "LD D, D"),
        0x53 => new Instruction(1, 1, "LD D, E"),
        0x54 => new Instruction(1, 1, "LD D, H"),
        0x55 => new Instruction(1, 1, "LD D, L"),
        0x56 => new Instruction(1, 2, "LD D, (HL)"),
        0x58 => new Instruction(1, 1, "LD E, B"),
        0x59 => new Instruction(1, 1, "LD E, C"),
        0x5A => new Instruction(1, 1, "LD E, D"),
        0x5B => new Instruction(1, 1, "LD E, E"),
        0x5C => new Instruction(1, 1, "LD E, H"),
        0x5D => new Instruction(1, 1, "LD E, L"),
        0x5E => new Instruction(1, 2, "LD E, (HL)"),
        0x5F => new Instruction(1, 1, "LD E, A"),
        0x57 => new Instruction(1, 1, "LD D, A"),
        0x60 => new Instruction(1, 1, "LD H, B"),
        0x61 => new Instruction(1, 1, "LD H, C"),
        0x62 => new Instruction(1, 1, "LD H, D"),
        0x63 => new Instruction(1, 1, "LD H, E"),
        0x64 => new Instruction(1, 1, "LD H, H"),
        0x65 => new Instruction(1, 1, "LD H, L"),
        0x66 => new Instruction(1, 2, "LD H, (HL)"),
        0x67 => new Instruction(1, 1, "LD H, A"),
        0x68 => new Instruction(1, 1, "LD L, B"),
        0x69 => new Instruction(1, 1, "LD L, C"),
        0x6A => new Instruction(1, 1, "LD L, D"),
        0x6B => new Instruction(1, 1, "LD L, E"),
        0x6C => new Instruction(1, 1, "LD L, H"),
        0x6D => new Instruction(1, 1, "LD L, L"),
        0x6E => new Instruction(1, 2, "LD L, (HL)"),
        0x6F => new Instruction(1, 1, "LD L, A"),
        0x70 => new Instruction(1, 2, "LD (HL), B"),
        0x71 => new Instruction(1, 2, "LD (HL), C"),
        0x72 => new Instruction(1, 2, "LD (HL), D"),
        0x73 => new Instruction(1, 2, "LD (HL), E"),
        0x74 => new Instruction(1, 2, "LD (HL), H"),
        0x75 => new Instruction(1, 2, "LD (HL), L"),
        0x76 => new Instruction(1, 1, "HALT"),
        0x77 => new Instruction(1, 2, "LD (HL), A"),
        0x78 => new Instruction(1, 1, "LD A, B"),
        0x79 => new Instruction(1, 1, "LD A, C"),
        0x7A => new Instruction(1, 1, "LD A, D"),
        0x7B => new Instruction(1, 1, "LD A, E"),
        0x7C => new Instruction(1, 1, "LD A, H"),
        0x7D => new Instruction(1, 1, "LD A, L"),
        0x7E => new Instruction(1, 2, "LD A, (HL)"),
        0x7F => new Instruction(1, 1, "LD A, A"),
        0x80 => new Instruction(1, 1, "ADD A, B"),
        0x81 => new Instruction(1, 1, "ADD A, C"),
        0x82 => new Instruction(1, 1, "ADD A, D"),
        0x83 => new Instruction(1, 1, "ADD A, E"),
        0x84 => new Instruction(1, 1, "ADD A, H"),
        0x85 => new Instruction(1, 1, "ADD A, L"),
        0x86 => new Instruction(1, 2, "ADD A, (HL)"),
        0x87 => new Instruction(1, 1, "ADD A, A"),
        0x88 => new Instruction(1, 1, "ADC A, B"),
        0x89 => new Instruction(1, 1, "ADC A, C"),
        0x8A => new Instruction(1, 1, "ADC A, D"),
        0x8B => new Instruction(1, 1, "ADC A, E"),
        0x8C => new Instruction(1, 1, "ADC A, H"),
        0x8D => new Instruction(1, 1, "ADC A, L"),
        0x8E => new Instruction(1, 2, "ADC A, (HL)"),
        0x8F => new Instruction(1, 1, "ADC A, A"),
        0x90 => new Instruction(1, 1, "SUB B"),
        0x91 => new Instruction(1, 1, "SUB C"),
        0x92 => new Instruction(1, 1, "SUB D"),
        0x93 => new Instruction(1, 1, "SUB E"),
        0x94 => new Instruction(1, 1, "SUB H"),
        0x95 => new Instruction(1, 1, "SUB L"),
        0x96 => new Instruction(1, 2, "SUB (HL)"),
        0x97 => new Instruction(1, 1, "SUB A"),
        0x98 => new Instruction(1, 1, "SBC B"),
        0x99 => new Instruction(1, 1, "SBC C"),
        0x9A => new Instruction(1, 1, "SBC D"),
        0x9B => new Instruction(1, 1, "SBC E"),
        0x9C => new Instruction(1, 1, "SBC H"),
        0x9D => new Instruction(1, 1, "SBC L"),
        0x9E => new Instruction(1, 2, "SBC (HL)"),
        0x9F => new Instruction(1, 1, "SBC A"),
        0xA0 => new Instruction(1, 1, "AND B"),
        0xA1 => new Instruction(1, 1, "AND C"),
        0xA2 => new Instruction(1, 1, "AND D"),
        0xA3 => new Instruction(1, 1, "AND E"),
        0xA4 => new Instruction(1, 1, "AND H"),
        0xA5 => new Instruction(1, 1, "AND L"),
        0xA6 => new Instruction(1, 2, "AND (HL)"),
        0xA7 => new Instruction(1, 1, "AND A"),
        0xA8 => new Instruction(1, 1, "XOR B"),
        0xAA => new Instruction(1, 1, "XOR D"),
        0xAB => new Instruction(1, 1, "XOR E"),
        0xAC => new Instruction(1, 1, "XOR H"),
        0xAD => new Instruction(1, 1, "XOR L"),
        0xAE => new Instruction(1, 2, "XOR (HL)"),
        0xAF => new Instruction(1, 1, "XOR A"),
        0xB0 => new Instruction(1, 1, "OR B"),
        0xB1 => new Instruction(1, 1, "OR C"),
        0xB2 => new Instruction(1, 1, "OR D"),
        0xB3 => new Instruction(1, 1, "OR E"),
        0xB4 => new Instruction(1, 1, "OR H"),
        0xB5 => new Instruction(1, 1, "OR L"),
        0xB6 => new Instruction(1, 2, "OR (HL)"),
        0xB7 => new Instruction(1, 1, "OR A"),
        0xB8 => new Instruction(1, 1, "CP B"),
        0xB9 => new Instruction(1, 1, "CP C"),
        0xBA => new Instruction(1, 1, "CP D"),
        0xBB => new Instruction(1, 1, "CP E"),
        0xBC => new Instruction(1, 1, "CP H"),
        0xBD => new Instruction(1, 1, "CP L"),
        0xBE => new Instruction(1, 2, "CP (HL)"),
        0xBF => new Instruction(1, 1, "CP A"),
        0xC0 => new Instruction(0, 0, "RET NZ"),
        0xC1 => new Instruction(1, 3, "POP BC"),
        0xC2 => new Instruction(0, 0, "JP NZ, nn"),
        0xC3 => new Instruction(0, 4, "JP, nn"),
        0xC4 => new Instruction(0, 0, "CALL NZ, nn"),
        0xC5 => new Instruction(1, 4, "PUSH BC"),
        0xC6 => new Instruction(2, 2, "ADD A, n"),
        0xC7 => new Instruction(0, 4, "RST 00H"),
        0xC8 => new Instruction(0, 0, "RET Z"),
        0xC9 => new Instruction(0, 4, "RET"),
        0xCA => new Instruction(0, 0, "JP Z, nn"),
        0xCB => new Instruction(2, 0, "BIT 7, H"),
        0xCC => new Instruction(0, 0, "CALL Z, nn"),
        0xCD => new Instruction(0, 6, "CALL, nn"),
        0xCE => new Instruction(2, 2, "ADC n"),
        0xCF => new Instruction(0, 4, "RST 08H"),
        0xD0 => new Instruction(0, 0, "RET NC"),
        0xD1 => new Instruction(1, 3, "POP DE"),
        0xD2 => new Instruction(0, 0, "JP NC, nn"),
        0xD4 => new Instruction(0, 0, "CALL NC, nn"),
        0xD5 => new Instruction(1, 4, "PUSH DE"),
        0xD6 => new Instruction(2, 2, "SUB n"),
        0xD7 => new Instruction(0, 4, "RST 10H"),
        0xD8 => new Instruction(0, 0, "RET C"),
        0xD9 => new Instruction(0, 4, "RETI"),
        0xDA => new Instruction(0, 0, "JP C, nn"),
        0xDC => new Instruction(0, 0, "CALL C, nn"),
        0xDE => new Instruction(2, 2, "SBC A, n"),
        0xDF => new Instruction(0, 4, "RST 18H"),
        0xE0 => new Instruction(2, 3, "LD (FFn), A"),
        0xE1 => new Instruction(1, 3, "POP HL"),
        0xE2 => new Instruction(1, 2, "LD (C), A"),
        0xE5 => new Instruction(1, 4, "PUSH HL"),
        0xE6 => new Instruction(2, 2, "AND n"),
        0xE7 => new Instruction(0, 4, "RST 20H"),
        0xE8 => new Instruction(2, 4, "ADD SP, n"),
        0xE9 => new Instruction(0, 1, "JP HL"),
        0xEA => new Instruction(3, 4, "LD (nn), A"),
        0xEE => new Instruction(2, 2, "XOR n"),
        0xEF => new Instruction(0, 4, "RST 28H"),
        0xF0 => new Instruction(2, 3, "LD A, (n)"),
        0xF1 => new Instruction(1, 3, "POP AF"),
        0xF2 => new Instruction(1, 2, "LD A, (C)"),
        0xF3 => new Instruction(1, 1, "DI"),
        0xF5 => new Instruction(1, 4, "PUSH AF"),
        0xF6 => new Instruction(2, 2, "OR n"),
        0xF7 => new Instruction(0, 4, "RST 30H"),
        0xF8 => new Instruction(2, 3, "LD HL, SP+e"),
        0xF9 => new Instruction(1, 2, "LD SP, HL"),
        0xFA => new Instruction(3, 4, "LD A, (nn)"),
        0xFB => new Instruction(1, 1, "EI"),
        0xFE => new Instruction(2, 2, "CP n"),
        0xFF => new Instruction(0, 4, "RST 38H"),
    ];

    public var size(default, null):Int;
    public var cycles(default, null):Int;
    public var tag(default, null):String;

    public function new(size:Int, cycles:Int, tag:String = "UNK")
    {
        this.size = size;
        this.cycles = cycles;
        this.tag = tag;
    }
}