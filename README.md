#VRISC (VHDL-RISC) Architecture#

##Copyright and License##
All code contained in this repository is (c) copyright 2016 Jay Valentine, and is released under the MIT License.
See LICENSE file for more details.

##Overview##
VRISC is a 32-bit, little-endian Harvard architecture. <br>
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

The VRISC architecture uses 5-bit register addressing, giving 32 register locations. 31 of these (0x01-0x1F) are general purpose registers which can be written to and read from. R0 (0x00) is hardcoded as having a value of 0, and cannot be written to. The registers store 32-bit signed two's complement values.

##Instructions##

The processor's instruction set is composed of 37 instructions, split into four categories - Arithmetic and Logic, Memory Access, Control, and Miscellaneous. In the table below, each instruction is given with its mnemonic, syntax, RTL description and functional description.

####Arithmetic and Logic####
```
ADDR  - rd, rs1, rs2    - rd <= rs1 + rs2                           Add the contents of rs1 and rs2 together, storing the result in rd
ADDI  - rd, rs1, imm    - rd <= rs1 + imm                           Add immediate to the contents of rs1, storing the result in rd
ADDRC - rd, rs1, rs2    - rd <= rs1 + rs2 + overflow                Add the contents of rs1 and rs2 together, along with carry bit from the previous operation, storing the result in rd
ADDIC - rd, rs1, imm    - rd <= rs1 + imm + overflow                Add immediate to the contents of rs1, along with carry bit from the previous operation, storing the result in rd

SUBR  - rd, rs1, rs2    - rd <= rs1 - rs2                           Subtract the contents of rs2 from rs1, storing the result in rd
SUBI  - rd, rs1, imm    - rd <= rs1 - imm                           Subtract immediate from contents of rs1, storing the result in rd
SUBRB - rd, rs1, rs2    - rd <= rs1 - rs2 - overflow                Subtract the contents of rs2 from rs1, along with borrow bit from the previous operation, storing the result in rd
SUBIB - rd, rs1, imm    - rd <= rs1 - imm - overflow                Subtract immediate from contents of rs1, along with borrow bit from the previous operation, storing the result in rd

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
