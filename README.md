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
    <td>3-Register Addressing</td>
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

<table>
  <col width="100px" />
  <col width="150px" />
  <col width="250px" />
  <col />
  <tr>
    <th colspan="5">Arithmetic and Logic</th>
  </tr>
  
  <tr>
    <td>ADDR</td>
    <td>rd, rs1, rs2</td>
    <td>rd <= rs1 + rs2</td>
    <td>Add the contents of rs1 and rs2 together, storing the result in rd</td>
  </tr>
  <tr>
    <td>ADDC</td>
    <td>rd, rs1, cons</td>
    <td>rd <= rs1 + cons</td>
    <td>Add constant to the contents of rs1, storing the result in rd</td>
  </tr>
  <tr>
    <td>ADDRC</td>
    <td>rd, rs1, rs2</td>
    <td>rd <= rs1 + rs2 + overflow</td>
    <td>Add the contents of rs1 and rs2 together with carry bit from the previous operation, storing the result in rd</td>
  </tr>
  <tr>
    <td>ADDCC</td>
    <td>rd, rs1, cons</td>
    <td>rd <= rs1 + cons + overflow</td>
    <td>Add constant to the contents of rs1, along with carry bit from the previous operation, storing the result in rd</td>
  </tr>
  
  <tr>
    <td>SUBR</td>
    <td>rd, rs1, rs2</td>
    <td>rd <= rs1 - rs2</td>
    <td>Subtract the contents of rs2 from rs1, storing the result in rd</td>
  </tr>
  <tr>
    <td>SUBC</td>
    <td>rd, rs1, cons</td>
    <td>rd <= rs1 - cons</td>
    <td>Subtract constant from contents of rs1, storing the result in rd</td>
  </tr>
  <tr>
    <td>SUBRB</td>
    <td>rd, rs1, rs2</td>
    <td>rd <= rs1 - rs2 - overflow</td>
    <td>Subtract the contents of rs2 from rs1, along with borrow bit from the previous operation, storing the result in rd<td>
  </tr>
  <tr>
    <td>SUBCB</td>
    <td>rd, rs1, cons</td>
    <td>rd <= rs1 - cons - overflow</td>
    <td>Subtract constant from contents of rs1, along with borrow bit from the previous operation, storing the result in rd</td>
  </tr>
  
  
  
</table>
