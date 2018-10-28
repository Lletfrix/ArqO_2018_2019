onerror {resume}
quietly virtual signal -install /processor_tb { /processor_tb/iDataIn(31 downto 26)} OPCode
quietly virtual signal -install /processor_tb { /processor_tb/iDataIn(25 downto 21)} rs
quietly virtual signal -install /processor_tb { /processor_tb/iDataIn(20 downto 16)} rt
quietly virtual signal -install /processor_tb { /processor_tb/iDataIn(15 downto 0)} inmediate
quietly virtual signal -install /processor_tb { /processor_tb/iDataIn(15 downto 11)} rd
quietly virtual signal -install /processor_tb { /processor_tb/iDataIn(5 downto 0)} Funct
quietly virtual signal -install /processor_tb/i_processor { /processor_tb/i_processor/IDataInIFID(31 downto 26)} OpCodeIFID
quietly virtual signal -install /processor_tb/i_processor { /processor_tb/i_processor/IDataInIFID(25 downto 21)} rsIFID
quietly virtual signal -install /processor_tb/i_processor { /processor_tb/i_processor/IDataInIFID(20 downto 16)} rtIFID
quietly virtual signal -install /processor_tb/i_processor { /processor_tb/i_processor/IDataInIFID(5 downto 0)} FunctIFID
quietly virtual signal -install /processor_tb/i_processor { /processor_tb/i_processor/IDataInIFID(15 downto 11)} rdIFID
quietly virtual signal -install /processor_tb/i_processor { /processor_tb/i_processor/IDataInIFID(15 downto 0)} InmediateIFID
quietly WaveActivateNextPane {} 0
add wave -noupdate -label Clock /processor_tb/i_processor/Clk
add wave -noupdate -label Reset /processor_tb/i_processor/Reset
add wave -noupdate -label PC -radix unsigned /processor_tb/i_processor/PC
add wave -noupdate -expand -group DataMem -label dataAddr -radix unsigned -childformat {{/processor_tb/dAddr(31) -radix unsigned} {/processor_tb/dAddr(30) -radix unsigned} {/processor_tb/dAddr(29) -radix unsigned} {/processor_tb/dAddr(28) -radix unsigned} {/processor_tb/dAddr(27) -radix unsigned} {/processor_tb/dAddr(26) -radix unsigned} {/processor_tb/dAddr(25) -radix unsigned} {/processor_tb/dAddr(24) -radix unsigned} {/processor_tb/dAddr(23) -radix unsigned} {/processor_tb/dAddr(22) -radix unsigned} {/processor_tb/dAddr(21) -radix unsigned} {/processor_tb/dAddr(20) -radix unsigned} {/processor_tb/dAddr(19) -radix unsigned} {/processor_tb/dAddr(18) -radix unsigned} {/processor_tb/dAddr(17) -radix unsigned} {/processor_tb/dAddr(16) -radix unsigned} {/processor_tb/dAddr(15) -radix unsigned} {/processor_tb/dAddr(14) -radix unsigned} {/processor_tb/dAddr(13) -radix unsigned} {/processor_tb/dAddr(12) -radix unsigned} {/processor_tb/dAddr(11) -radix unsigned} {/processor_tb/dAddr(10) -radix unsigned} {/processor_tb/dAddr(9) -radix unsigned} {/processor_tb/dAddr(8) -radix unsigned} {/processor_tb/dAddr(7) -radix unsigned} {/processor_tb/dAddr(6) -radix unsigned} {/processor_tb/dAddr(5) -radix unsigned} {/processor_tb/dAddr(4) -radix unsigned} {/processor_tb/dAddr(3) -radix unsigned} {/processor_tb/dAddr(2) -radix unsigned} {/processor_tb/dAddr(1) -radix unsigned} {/processor_tb/dAddr(0) -radix unsigned}} -subitemconfig {/processor_tb/dAddr(31) {-height 16 -radix unsigned} /processor_tb/dAddr(30) {-height 16 -radix unsigned} /processor_tb/dAddr(29) {-height 16 -radix unsigned} /processor_tb/dAddr(28) {-height 16 -radix unsigned} /processor_tb/dAddr(27) {-height 16 -radix unsigned} /processor_tb/dAddr(26) {-height 16 -radix unsigned} /processor_tb/dAddr(25) {-height 16 -radix unsigned} /processor_tb/dAddr(24) {-height 16 -radix unsigned} /processor_tb/dAddr(23) {-height 16 -radix unsigned} /processor_tb/dAddr(22) {-height 16 -radix unsigned} /processor_tb/dAddr(21) {-height 16 -radix unsigned} /processor_tb/dAddr(20) {-height 16 -radix unsigned} /processor_tb/dAddr(19) {-height 16 -radix unsigned} /processor_tb/dAddr(18) {-height 16 -radix unsigned} /processor_tb/dAddr(17) {-height 16 -radix unsigned} /processor_tb/dAddr(16) {-height 16 -radix unsigned} /processor_tb/dAddr(15) {-height 16 -radix unsigned} /processor_tb/dAddr(14) {-height 16 -radix unsigned} /processor_tb/dAddr(13) {-height 16 -radix unsigned} /processor_tb/dAddr(12) {-height 16 -radix unsigned} /processor_tb/dAddr(11) {-height 16 -radix unsigned} /processor_tb/dAddr(10) {-height 16 -radix unsigned} /processor_tb/dAddr(9) {-height 16 -radix unsigned} /processor_tb/dAddr(8) {-height 16 -radix unsigned} /processor_tb/dAddr(7) {-height 16 -radix unsigned} /processor_tb/dAddr(6) {-height 16 -radix unsigned} /processor_tb/dAddr(5) {-height 16 -radix unsigned} /processor_tb/dAddr(4) {-height 16 -radix unsigned} /processor_tb/dAddr(3) {-height 16 -radix unsigned} /processor_tb/dAddr(2) {-height 16 -radix unsigned} /processor_tb/dAddr(1) {-height 16 -radix unsigned} /processor_tb/dAddr(0) {-height 16 -radix unsigned}} /processor_tb/dAddr
add wave -noupdate -expand -group DataMem -label WriteMemData -radix unsigned /processor_tb/dDataOut
add wave -noupdate -expand -group Registros -label {$31} -radix unsigned /processor_tb/i_processor/Registry/regs(31)
add wave -noupdate -expand -group Registros -label {$30} -radix unsigned /processor_tb/i_processor/Registry/regs(30)
add wave -noupdate -expand -group Registros -label {$29} -radix unsigned /processor_tb/i_processor/Registry/regs(29)
add wave -noupdate -expand -group Registros -label {$28} -radix unsigned /processor_tb/i_processor/Registry/regs(28)
add wave -noupdate -expand -group Registros -label {$27} -radix unsigned /processor_tb/i_processor/Registry/regs(27)
add wave -noupdate -expand -group Registros -label {$26} -radix unsigned /processor_tb/i_processor/Registry/regs(26)
add wave -noupdate -expand -group Registros -label {$25} -radix unsigned /processor_tb/i_processor/Registry/regs(25)
add wave -noupdate -expand -group Registros -label {$24} -radix unsigned /processor_tb/i_processor/Registry/regs(24)
add wave -noupdate -expand -group Registros -label {$23} -radix unsigned /processor_tb/i_processor/Registry/regs(23)
add wave -noupdate -expand -group Registros -label {$22} -radix unsigned /processor_tb/i_processor/Registry/regs(22)
add wave -noupdate -expand -group Registros -label {$21} -radix unsigned /processor_tb/i_processor/Registry/regs(21)
add wave -noupdate -expand -group Registros -label {$20} -radix unsigned /processor_tb/i_processor/Registry/regs(20)
add wave -noupdate -expand -group Registros -label {$19} -radix unsigned /processor_tb/i_processor/Registry/regs(19)
add wave -noupdate -expand -group Registros -label {$18} -radix unsigned /processor_tb/i_processor/Registry/regs(18)
add wave -noupdate -expand -group Registros -label {$17} -radix unsigned /processor_tb/i_processor/Registry/regs(17)
add wave -noupdate -expand -group Registros -label {$16} -radix unsigned /processor_tb/i_processor/Registry/regs(16)
add wave -noupdate -expand -group Registros -label {$15} -radix unsigned /processor_tb/i_processor/Registry/regs(15)
add wave -noupdate -expand -group Registros -label {$14} -radix unsigned /processor_tb/i_processor/Registry/regs(14)
add wave -noupdate -expand -group Registros -label {$13} -radix unsigned /processor_tb/i_processor/Registry/regs(13)
add wave -noupdate -expand -group Registros -label {$12} -radix unsigned /processor_tb/i_processor/Registry/regs(12)
add wave -noupdate -expand -group Registros -label {$11} -radix unsigned /processor_tb/i_processor/Registry/regs(11)
add wave -noupdate -expand -group Registros -label {$10} -radix unsigned /processor_tb/i_processor/Registry/regs(10)
add wave -noupdate -expand -group Registros -label {$9} -radix unsigned /processor_tb/i_processor/Registry/regs(9)
add wave -noupdate -expand -group Registros -label {$8} -radix unsigned /processor_tb/i_processor/Registry/regs(8)
add wave -noupdate -expand -group Registros -label {$7} -radix unsigned /processor_tb/i_processor/Registry/regs(7)
add wave -noupdate -expand -group Registros -label {$6} -radix unsigned /processor_tb/i_processor/Registry/regs(6)
add wave -noupdate -expand -group Registros -label {$5} -radix unsigned /processor_tb/i_processor/Registry/regs(5)
add wave -noupdate -expand -group Registros -label {$4} -radix unsigned /processor_tb/i_processor/Registry/regs(4)
add wave -noupdate -expand -group Registros -label {$3} -radix unsigned /processor_tb/i_processor/Registry/regs(3)
add wave -noupdate -expand -group Registros -label {$2} -radix unsigned /processor_tb/i_processor/Registry/regs(2)
add wave -noupdate -expand -group Registros -label {$1} -radix unsigned /processor_tb/i_processor/Registry/regs(1)
add wave -noupdate -expand -group Registros -label {$0} -radix unsigned -childformat {{/processor_tb/i_processor/Registry/regs(0)(31) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(30) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(29) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(28) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(27) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(26) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(25) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(24) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(23) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(22) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(21) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(20) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(19) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(18) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(17) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(16) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(15) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(14) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(13) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(12) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(11) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(10) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(9) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(8) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(7) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(6) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(5) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(4) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(3) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(2) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(1) -radix unsigned} {/processor_tb/i_processor/Registry/regs(0)(0) -radix unsigned}} -subitemconfig {/processor_tb/i_processor/Registry/regs(0)(31) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(30) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(29) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(28) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(27) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(26) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(25) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(24) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(23) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(22) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(21) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(20) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(19) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(18) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(17) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(16) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(15) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(14) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(13) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(12) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(11) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(10) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(9) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(8) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(7) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(6) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(5) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(4) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(3) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(2) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(1) {-height 16 -radix unsigned} /processor_tb/i_processor/Registry/regs(0)(0) {-height 16 -radix unsigned}} /processor_tb/i_processor/Registry/regs(0)
add wave -noupdate -group InstrDecode /processor_tb/i_processor/OpCodeIFID
add wave -noupdate -group InstrDecode -radix unsigned /processor_tb/i_processor/rsIFID
add wave -noupdate -group InstrDecode -radix unsigned /processor_tb/i_processor/rtIFID
add wave -noupdate -group InstrDecode -radix unsigned /processor_tb/i_processor/rdIFID
add wave -noupdate -group InstrDecode /processor_tb/i_processor/FunctIFID
add wave -noupdate -group InstrDecode -radix unsigned /processor_tb/i_processor/InmediateIFID
add wave -noupdate -group InstrDecode -radix unsigned /processor_tb/i_processor/PC4IFID
add wave -noupdate -group Execution -group ALUFlags -format Literal /processor_tb/i_processor/RegWriteIDEX
add wave -noupdate -group Execution -group ALUFlags -format Literal /processor_tb/i_processor/RegDstIDEX
add wave -noupdate -group Execution -group ALUFlags -format Literal /processor_tb/i_processor/MemWriteIDEX
add wave -noupdate -group Execution -group ALUFlags -format Literal /processor_tb/i_processor/MemReadIDEX
add wave -noupdate -group Execution -group ALUFlags -format Literal /processor_tb/i_processor/MemToRegIDEX
add wave -noupdate -group Execution -group ALUFlags -format Literal /processor_tb/i_processor/AluSrcIDEX
add wave -noupdate -group Execution -group ALUFlags -format Literal /processor_tb/i_processor/BranchIDEX
add wave -noupdate -group Execution -group InstructionFields -radix unsigned /processor_tb/i_processor/RTIDEX
add wave -noupdate -group Execution -group InstructionFields -radix unsigned /processor_tb/i_processor/ExtendedInmIDEX
add wave -noupdate -group Execution -group InstructionFields -radix unsigned /processor_tb/i_processor/RDIDEX
add wave -noupdate -group Execution -group InstructionFields /processor_tb/i_processor/FunctIDEX
add wave -noupdate -group Execution -expand -group ReadData /processor_tb/i_processor/ReadData1IDEX
add wave -noupdate -group Execution -expand -group ReadData -radix binary /processor_tb/i_processor/ReadData2IDEX
add wave -noupdate -group Execution -expand -group ReadData -label AluResult -radix unsigned /processor_tb/i_processor/DataAddr
add wave -noupdate -group Execution /processor_tb/i_processor/PC4IDEX
add wave -noupdate -group MemoryPhase -group ALUFlags /processor_tb/i_processor/RegWriteEXMEM
add wave -noupdate -group MemoryPhase -group ALUFlags /processor_tb/i_processor/MemWriteEXMEM
add wave -noupdate -group MemoryPhase -group ALUFlags /processor_tb/i_processor/MemToRegEXMEM
add wave -noupdate -group MemoryPhase -group ALUFlags /processor_tb/i_processor/MemReadEXMEM
add wave -noupdate -group MemoryPhase -radix unsigned /processor_tb/i_processor/RegDstMuxEXMEM
add wave -noupdate -group MemoryPhase /processor_tb/i_processor/ReadData2EXMEM
add wave -noupdate -group MemoryPhase -radix unsigned /processor_tb/i_processor/DataAddrEXMEM
add wave -noupdate -group WriteBack -group ALUFlags -format Literal -radix unsigned /processor_tb/i_processor/RegWriteMEMWB
add wave -noupdate -group WriteBack -group ALUFlags -format Literal -radix unsigned /processor_tb/i_processor/MemToRegMEMWB
add wave -noupdate -group WriteBack -radix unsigned /processor_tb/i_processor/RegDstMuxMEMWB
add wave -noupdate -group WriteBack /processor_tb/i_processor/DDataInMEMWB
add wave -noupdate -group WriteBack /processor_tb/i_processor/MemToRegMux
add wave -noupdate -group WriteBack /processor_tb/i_processor/DataAddrMEMWB
add wave -noupdate -group Forwarding -radix unsigned /processor_tb/i_processor/ForwardAMux
add wave -noupdate -group Forwarding -radix unsigned /processor_tb/i_processor/ForwardBMux
add wave -noupdate -group Forwarding /processor_tb/i_processor/ForwardA
add wave -noupdate -group Forwarding /processor_tb/i_processor/ForwardB
add wave -noupdate -expand -group Branch -format Literal /processor_tb/i_processor/Branch
add wave -noupdate -expand -group Branch -format Literal /processor_tb/i_processor/BranchIDEX
add wave -noupdate -expand -group Branch -radix unsigned /processor_tb/i_processor/BranchZMux
add wave -noupdate -expand -group Branch -format Literal /processor_tb/i_processor/Z
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {77398 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 401
configure wave -valuecolwidth 250
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {43910 ps} {155084 ps}
