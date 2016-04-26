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

###Arithmetic and Logic###
ADDR	- rd, rs1, rs2 		- rd <= rs1 + rs2				Add the contents of rs1 and rs2 together, storing the result in rd
ADDC	- rd, rs1, cons		- rd <= rs1 + cons				Add constant to the contents of rs1, storing the result in rd
ADDRC	- rd, rs1, rs2		- rd <= rs1 + rs2 + overflow			Add the contents of rs1 and rs2 together, along with carry bit from the previous operation, storing the result in rd
ADDCC	- rd, rs1, cons		- rd <= rs1 + cons + overflow			Add constant to the contents of rs1, along with carry bit from the previous operation, storing the result in rd

SUBR	- rd, rs1, rs2		- rd <= rs1 - rs2				Subtract the contents of rs2 from rs1, storing the result in rd
SUBC	- rd, rs1, cons		- rd <= rs1 - cons				Subtract constant from contents of rs1, storing the result in rd
SUBRB	- rd, rs1, rs2		- rd <= rs1 - rs2 - overflow 			Subtract the contents of rs2 from rs1, along with borrow bit from the previous operation, storing the result in rd
SUBCB	- rd, rs1, cons		- rd <= rs1 - cons - overflow			Subtract constant from contents of rs1, along with borrow bit from the previous operation, storing the result in rd

ANDR	- rd, rs1, rs2		- rd <= rs1 AND rs2				AND the contents of rs1 and rs2, storing the result in rd
ANDC	- rd, rs1, cons		- rd <= rs1 AND cons				AND constant with the contents of rs1, storing the result in rd
ORR	- rd, rs1, rs2		- rd <= rs1 OR rs2				OR the contents of rs1 and rs2, storing the result in rd
ORC	- rd, rs1, cons		- rd <= rs1 OR cons				OR constant with the contents of rs1, storing the result in rd
XORR	- rd, rs1, rs2		- rd <= rs1 XOR rs2				XOR the contents of rs1 and rs2, storing the result in rd
XORC	- rd, rs1, cons		- rd <= rs1 XOR cons				XOR constant with the contents of rs1, storing the result in rd	
NOT	- rd, rs1		- rd <= NOT rs1					NOT the contents of rs1, storing the result in rd

ZERO	- rs1			- test <= 1 if rs1=0, 0 otherwise		Update test flag with 1 if the value of rs1 is equal to zero 
GRT	- rs1, rs2		- test <= 1 if rs1>rs2, 0 otherwise		Update test flag with 1 if the value of rs1 is greater than rs2
LESS	- rs1, rs2		- test <= 1 if rs1<rs2, 0 otherwise		Update test flag with 1 if the value of rs1 is less than rs2
EQU	- rs1, rs2		- test <= 1 if rs1=rs2, 0 otherwise		Update test flag with 1 if the value of rs1 is equal to rs2

  
  
  
</table>
