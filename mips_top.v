module mips_top (clk,reset);
  input clk, reset;
  wire zero,nPC_sel,j_sel;
  wire [4:0]rsE;
  wire [15:0]imm_ifu;
  wire [31:0]insout;
  wire [25:0]j_imm;
  wire [31:0]pcplus4F;
  wire [5:0]opcode,funct;
  wire [4:0] rs,rt,rd,shamt;
  wire [15:0] imm;
  wire RegDstD, RegWrD,AluSrcD,MemWrD,MemtoregD;
  wire[31:0]pcplus4D;
  wire[31:0] instrD;
  wire [31:0] signD;
  wire[1:0] ExtOp;
  wire [1:0]AluctrD;
  wire RegWriteE, MemtoRegE,MemWriteE, npc_selE;
  wire [1:0]AluCtrE;
  wire AluSrcE;
  wire RegDstE,j_selE;
  wire [31:0]busaE,busbE;
  wire[4:0]rdE,rtE;
  wire [31:0]signE;
  wire [31:0] pcplus4E;
  wire [25:0] j_immE;
  wire [15:0] imm_ifuD,imm_ifuE;
  wire [4:0] rwE;
  wire [31:0] busw; 
  wire [31:0] busa, busb;
  wire RegWrM;
  wire [31:0] data_out;
  wire RegWriteM,MemtoRegM,MemWriteM,npc_selM,zeroM;
  wire [31:0]busbM,Alu_outM;
  wire[4:0]rwM;
  wire[31:0]pcoutM;
  wire [31:0]pcplus4M;
  wire [31:0]imm32;
  wire[31:0] busB_out;
  wire  [31:0]dout;
  wire RegWriteW, MemtoRegW;
  wire [31:0]dout_W,Alu_outW;
  wire[4:0]rwW;
  wire[31:0]t1;
  wire j_selM;
  wire [31:0]pcnew;
  wire [31:0]out_a,out_b;
  wire[1:0] ForwardAE,ForwardBE;
  wire StallF,StallD,FlushE,ForwardAD,ForwardBD;
  wire PCSrcD;
  wire [31:0] ca,cb;

 ifu ifu(clk,reset,insout,pcnew,imm_ifu,pcplus4F,StallF,zero,nPC_sel,j_sel);
 id id(instrD,opcode,rs,rt,rd,shamt,funct,imm,j_imm);
 ctrl ctrl(instrD,RegDstD,RegWrD,AluSrcD,MemWrD,MemtoregD,AluctrD,nPC_sel,ExtOp,j_sel); 
 gpr gpr(clk,reset,busw,RegWriteW,rwW,rs,rt,busa,busb,RegWriteM,Alu_outM,rwM);
 alu alu(out_a,busB_out,AluCtrE,data_out);
 ifu_extra ifu_extra(pcplus4D,imm_ifuD,j_imm,j_sel,t1);
 ext ext(imm,imm32,ExtOp);
 dm dm(clk,busbM,MemWriteM,Alu_outM,dout);
 hazard hazard(reset,RegWriteW,RegWriteM,rwW,rwM,ForwardAE,ForwardBE,rsE,rtE,StallF,StallD,nPC_sel,ForwardAD,ForwardBD,rs,rt,FlushE,rwE,MemtoRegE,RegWriteE,MemtoRegM);
 comparator comparator(ca,cb,nPC_sel,PCSrcD,zero); 
 PCnext PCnext(PCSrcD,j_sel,t1,pcplus4D,pcnew);
 
 IFID IFID(PCSrcD,StallD,clk,insout,imm_ifu,imm_ifuD,pcplus4F,pcplus4D,instrD);
 IDEX IDEX(FlushE,clk,RegWrD,MemtoregD,MemWrD,AluctrD,AluSrcD,RegDstD,busa,busb,rd,rt,imm32,pcplus4D,rs,RegWriteE,MemtoRegE,MemWriteE,AluCtrE,AluSrcE,RegDstE,busaE,busbE,rdE,rtE,signE,pcplus4E,rsE);
 EXMEM EXMEM(clk,RegWriteE,MemtoRegE,MemWriteE,out_b, data_out, rwE,RegWriteM,MemtoRegM,MemWriteM, busbM,Alu_outM, rwM);
 MEMWB MEMWB(clk,RegWriteM,MemtoRegM,dout,Alu_outM,rwM,RegWriteW, MemtoRegW, dout_W,Alu_outW,rwW);
  
 mux_5 mux_5(rdE,rtE,RegDstE,rwE);
 mux mux(signE,out_b,AluSrcE,busB_out);  
 mux mux2(dout,Alu_outW,MemtoRegW,busw);
 mux3_1 mux3_1_1(busaE,busw,Alu_outM,ForwardAE,out_a);
 mux3_1 mux3_1_2(busbE,busw,Alu_outM,ForwardBE,out_b);
 mux mux3(Alu_outM,busa,ForwardAD,ca);
 mux mux4(Alu_outM,busb,ForwardBD,cb);
 

endmodule
