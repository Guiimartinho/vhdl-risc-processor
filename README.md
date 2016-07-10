#VRISC (VHDL-RISC) Architecture#

##Copyright and License##
All code and designs contained in this repository are (c) copyright 2016 Jay Valentine, and are released under the MIT License.
See LICENSE file for more details.

##Overview##
VRISC is a 32-bit, little-endian Harvard architecture RISC processor. <br>
It uses a fixed-length, 32-bit instruction format, with six addressing modes:
<table>
  <tr>
    <th>Addressing Mode</th>
    <th colspan="5">Instruction Fields</th>
  </tr>
  
  <tr>
    <td>Register Addressing</td>
    <td>opcode - 6 bits</td>
    <td>rd - 5 bits</td>
    <td>rs1 - 5 bits</td>
    <td>rs2 - 5 bits</td>
    <td>unused - 11 bits</td>
  </tr>
  
  <tr>
    <td>Immediate Addressing</td>
    <td>opcode - 6 bits</td>
    <td>rd - 5 bits</td>
    <td>rs1 - 5 bits</td>
    <td colspan="2">constant - 16 bits</td>
  </tr>
  
  <tr>
    <td>Offset Branch Addressing</td>
    <td>opcode - 6 bits</td>
    <td colspan="4">offset - 26 bits</td>
  </tr>
  
  <tr>
    <td>Offset Memory Addressing</td>
    <td>opcode - 6 bits</td>
    <td>rsd - 5 bits</td>
    <td>ro - 5 bits</td>
    <td colspan="2">address - 16 bits</td>
  </tr>
  
  <tr>
    <td>Absolute Block Addressing</td>
    <td>opcode - 6 bits</td>
    <td colspan="4">block address - 26 bits</td>
  </tr>
  
  <tr>
    <td>Register Block Addressing</td>
    <td>opcode - 6 bits</td>
    <td>ra - 5 bits</td>
    <td colspan="3">unused - 21 bits</td>
  </tr>
</table>
    
##Registers##

The VRISC architecture uses 5-bit register addressing, giving 32 register locations. 31 of these (0x01-0x1F) are general purpose registers which can be written to and read from. R0 (0x00) is hardcoded as having a value of 0, and cannot be written to. The registers store 32-bit values.

##Memory##

VRISC uses a block-based cache for instructions. Instructions are loaded in blocks of 512 into on-chip SRAM memory. Blocks are loaded automatically when the program counter address changes to an address not stored in the cache. This can happen as the result of a program counter increment, a branch instruction, or the SETIR and SETIC instructions, which set the program counter to the given address, allowing a block to be loaded manually.

The architecture uses a manual cache - or 'scratchpad' - for data, which can be written to and read from using the same instructions as for external memory. Data memory is divided into three segments - I/O, scratchpad, and external. The memory controller on the chip maps the memory as below:
```
0x00000000-0x0000000F - 16 8-bit I/O ports (can be grouped together to form bigger ports)
0x00000010-0x00000410 - 1024 bytes scratchpad memory
0x00000411-0xFFFFFFFF - external memory
```
These memory locations can all be written to and read from using the memory access instructions detailed in the next section. 

##Instructions##

The processor's instruction set is composed of 46 instructions, split into four categories - Arithmetic and Logic, Memory Access, Control, and Miscellaneous. In the table below, each instruction is given with its mnemonic, syntax, RTL description and functional description.

####Arithmetic and Logic####
```
ADDR  - rd, rs1, rs2    - rd <= rs1 + rs2                           Add signed values rs1 and rs2 together, storing the result in rd
ADDI  - rd, rs1, imm    - rd <= rs1 + imm                           Add immediate to signed value rs1, storing the result in rd
ADDUR - rd, rs1, rs2    - rd <= rs1 + rs2                           Add unsigned values rs1 and rs2 together, storing the result in rd
ADDUI - rd, rs1, imm    - rd <= rs1 + imm                           Add immediate to unsigned value rs1, storing the result in rd

SUBR  - rd, rs1, rs2    - rd <= rs1 - rs2                           Subtract signed values rs2 from rs1, storing the result in rd
SUBI  - rd, rs1, imm    - rd <= rs1 - imm                           Subtract immediate from signed value rs1, storing the result in rd
SUBUR - rd, rs1, rs2    - rd <= rs1 - rs2                           Subtract unsigned values rs2 from rs1, storing the result in rd
SUBUI - rd, rs1, imm    - rd <= rs1 - imm                           Subtract immediate from unsigned value rs1, storing the result in rd

SLL   - rd, rs1			- rd <= (rs1 << 1) & 0						Shift the contents of rs1 left by one bit, with the lsb of the new value being 0, storing the result in rd
SRL	  - rd, rs1			- rd <= 0 & (rs1 >> 1)						Shift the contents of rs1 right by one bit, with the msb of the new value being 0, storing the result in rd
SLA	  - rd, rs1			- rd <= (rs1 << 1) & lsb					Shift the contents of rs1 left by one bit, maintaining the lsb of the old value, storing the result in rd
SRA	  - rd, rs1			- rd <= msb & (rs1 >> 1)					Shift the contents of rs1 right by one bit, maintaining the msb of the old value, storing the result in rd

ANDR  - rd, rs1, rs2    - rd <= rs1 AND rs2                         AND the contents of rs1 and rs2, storing the result in rd
ANDI  - rd, rs1, imm    - rd <= rs1 AND imm                         AND immediate with the contents of rs1, storing the result in rd
ORR   - rd, rs1, rs2    - rd <= rs1 OR rs2                          OR the contents of rs1 and rs2, storing the result in rd
ORI   - rd, rs1, imm    - rd <= rs1 OR imm                          OR immediate with the contents of rs1, storing the result in rd
XORR  - rd, rs1, rs2    - rd <= rs1 XOR rs2                         XOR the contents of rs1 and rs2, storing the result in rd
XORI  - rd, rs1, imm    - rd <= rs1 XOR imm                         XOR immediate with the contents of rs1, storing the result in rd
NOT   - rd, rs1         - rd <= NOT rs1                             NOT the contents of rs1, storing the result in rd

ZERO  - rs1             - test <= 1 if rs1=0                        Update test flag with 1 if the value of rs1 is equal to zero
GRTR  - rs1, rs2        - test <= 1 if rs1>rs2                      Update test flag with 1 if the value of rs1 is greater than rs2
GRTI  - rs1, imm        - test <= 1 if rs1>imm                      Update test flag with 1 if the value of rs1 is greater than immediate
LESSR - rs1, rs2        - test <= 1 if rs1<rs2                      Update test flag with 1 if the value of rs1 is less than rs2
LESSI - rs1, imm        - test <= 1 if rs1<imm                      Update test flag with 1 if the value of rs1 is less than immediate
EQUR  - rs1, rs2        - test <= 1 if rs1=rs2                      Update test flag with 1 if the value of rs1 is equal to rs2
EQUI  - rs1, imm        - test <= 1 if rs1=imm                      Update test flag with 1 if the value of rs1 is equal to immediate
```

####Memory Access####
```
SETMR - ra              - block <= ra                               Set the current operating memory block address to the value of ra
SETMC - addr            - block <= addr                             Set the current operating memory block address to addr

LDB   - rd, addr, ro    - rd <= memory_byte[block + addr + ro]      Load byte at location addr + ro in memory into rd
LDHW  - rd, addr, ro    - rd <= memory_hword[block + addr + ro]     Load half-word at location addr + ro in memory into rd
LDW   - rd, addr, ro    - rd <= memory_word[block + addr + ro]      Load word at location addr + ro in memory into rd

STB   - rs, addr, r0    - memory_byte[block + addr + ro] <= rs      Store byte in rs at location addr + ro in memory
STHW  - rs, addr, r0    - memory_hword[block + addr + ro] <= rs     Store half-word in rs at location addr + ro in memory
STW   - rs, addr, r0    - memory_word[block + addr + ro] <= rs      Store word in rs at location addr + ro in memory
```

####Control####
```
SETIR - ra              - pc <= ra                                  Set pc to the value of ra
SETIC - addr            - pc <= addr                                Set pc to addr

BRA   - offset          - pc <= pc + offset                         Branch to instruction at location pc + offset
BRAT  - offset          - pc <= pc + offset if test=1               Branch to instruction at location pc + offset if test flag is 1
BRAC  - offset          - pc <= pc + offset if carry=1              Branch to instruction at pc + offset if carry flag is 1
BRAO  - offset          - pc <= pc + offset if overflow=1           Branch to instruction at pc + offset if overflow flag is 1

CALL  - offset          - stack[top] <= pc + 4, pc <= pc + offset	Branch to subroutine at location pc + offset, placing the return address onto the stack
CALLR - ra              - stack[top] <= pc + 4, pc <= ra            Branch to subroutine at location given by the value of ra, placing the return address onto the stack
CALLB - addr            - stack[top] <= pc + 4, pc <= addr          Branch to subroutine at location addr, placing the return address onto the stack
RET   -                 - pc <= stack[top]                          Return to address on the top of the stack
```

####Miscellaneous####
```
HALT  -                 -                                           Suspends processor operation indefinitely
NOP   -                 -                                           Stalls processor operation for one clock cycle
```
