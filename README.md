#VRISC (VHDL-RISC) Architecture#

##Copyright and License##
All code contained in this repository is (c) copyright 2016 Jay Valentine, and is released under the MIT License.
See LICENSE file for more details.

##Overview##
VRISC is a 32-bit, little-endian Harvard architecture. <br>
It uses a fixed-length, 32-bit instruction format, with six addressing modes:

3-Register Addressing <br>
|opcode - 6|rd - 5|rs1 - 5|rs2 - 5|unused - 11	|

Immediate Addressing <br>
|opcode - 6|rd - 5|rs1 - 5|constant - 16		|

Offset Branch Addressing <br>
|opcode - 6|offset - 26							|

Offset Memory Addressing <br>
|opcode - 6|rsd - 5|ro - 5|addr - 16			|

Absolute Block Addressing <br>
|opcode - 6|block addr - 26						|

Register Block Addressing <br>
|opcode - 6|ra - 5|unused - 21					|