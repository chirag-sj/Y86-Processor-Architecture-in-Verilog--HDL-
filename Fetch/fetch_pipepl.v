module fetch (predpc,W_icode,M_icode,M_Cnd,W_valM,M_valA,E_valA,e_cnd,e_icode,
              icode,
              ifun,
              ra,
              rb,
              valc,
              valp,
              status,
              nextpredpc);

input [63:0] predpc;   
input [63:0] M_valA,W_valM;
input [3:0] W_icode,M_icode;
input M_Cnd;
input e_cnd;
input [63:0] E_valA;
input [3:0] e_icode;
output reg [2:0] status;
output reg [3:0] icode,ifun,ra,rb;
output reg [63:0] valc;
output reg [63:0] valp;
output reg [63:0] nextpredpc;
reg inst_valid;
reg imem_error;
reg [63:0] pc;
reg [7:0] split;
reg [7:0] align;
integer i;
reg [7:0] inst_mem[65535:0];
 

 initial begin
  

     inst_mem[10]=8'b0000_0011;     //irmovq
     inst_mem[11]=8'b0100_1111;
     inst_mem[10+2+0]=8'b0110_0100;
     inst_mem[10+2+1]=8'b0000_0000;
     inst_mem[10+2+2]=8'b0000_0000;
     inst_mem[10+2+3]=8'b0000_0000;
     inst_mem[10+2+4]=8'b0000_0000;
     inst_mem[10+2+5]=8'b0000_0000;
     inst_mem[10+2+6]=8'b0000_0000;
     inst_mem[10+2+7]=8'b0000_0000; 



     inst_mem[20]=8'b0000_0011;     //irmovq
     inst_mem[21]=8'b0000_1111;
     inst_mem[20+2+0]=8'b0000_0110;
     inst_mem[20+2+1]=8'b0000_0000;
     inst_mem[20+2+2]=8'b0000_0000;
     inst_mem[20+2+3]=8'b0000_0000;
     inst_mem[20+2+4]=8'b0000_0000;
     inst_mem[20+2+5]=8'b0000_0000;
     inst_mem[20+2+6]=8'b0000_0000;
     inst_mem[20+2+7]=8'b0000_0000;
     
     inst_mem[30]=8'b0000_0011;     //irmovq
     inst_mem[31]=8'b0001_1111;
     inst_mem[30+2+0]=8'b0000_0001;
     inst_mem[30+2+1]=8'b0000_0000;
     inst_mem[30+2+2]=8'b0000_0000;
     inst_mem[30+2+3]=8'b0000_0000;
     inst_mem[30+2+4]=8'b0000_0000;
     inst_mem[30+2+5]=8'b0000_0000;
     inst_mem[30+2+6]=8'b0000_0000;
     inst_mem[30+2+7]=8'b0000_0000; 

     inst_mem[40]=8'b0000_0011;     //irmovq
     inst_mem[41]=8'b0101_1111;
     inst_mem[40+2+0]=8'b0000_0101;
     inst_mem[40+2+1]=8'b0000_0000;
     inst_mem[40+2+2]=8'b0000_0000;
     inst_mem[40+2+3]=8'b0000_0000;
     inst_mem[40+2+4]=8'b0000_0000;
     inst_mem[40+2+5]=8'b0000_0000;
     inst_mem[40+2+6]=8'b0000_0000;
     inst_mem[40+2+7]=8'b0000_0000; 



     inst_mem[50]=8'b0000_0100;            //rmmovq
     inst_mem[51]=8'b0001_0011;
     inst_mem[50+2+0]=8'b0000_0000;
     inst_mem[50+2+1]=8'b0000_0000;
     inst_mem[50+2+2]=8'b0000_0000;
     inst_mem[50+2+3]=8'b0000_0000;
     inst_mem[50+2+4]=8'b0000_0000;
     inst_mem[50+2+5]=8'b0000_0000;
     inst_mem[50+2+6]=8'b0000_0000;
     inst_mem[50+2+7]=8'b0000_0000;

     inst_mem[60]=8'b0000_0110;    //addq
     inst_mem[60+1]=8'b0011_0001;

     inst_mem[62]=8'b0011_0010;    //ccmove
     inst_mem[62+1]=8'b0001_0000;

     inst_mem[64]=8'b0000_1010;    //pushq
     inst_mem[64+1]=8'b1111_0000;

     inst_mem[66]=8'b0001_0110;    //subq
     inst_mem[66+1]=8'b0011_0001;


 
 //////-----------------Ret---------------------
    // inst_mem[10]=8'b0000_0011;     //irmovq
    // inst_mem[11]=8'b0100_1111;
    // inst_mem[10+2+0]=8'b0110_0100;
    // inst_mem[10+2+1]=8'b0000_0000;
    // inst_mem[10+2+2]=8'b0000_0000;
    // inst_mem[10+2+3]=8'b0000_0000;
    // inst_mem[10+2+4]=8'b0000_0000;
    // inst_mem[10+2+5]=8'b0000_0000;
    // inst_mem[10+2+6]=8'b0000_0000;
    // inst_mem[10+2+7]=8'b0000_0000; 
//
    // inst_mem[20]=8'b0000_1000;     //call
    // inst_mem[20+1]=8'b0100_0000;
    // inst_mem[20+2]=8'b0000_0000;
    // inst_mem[20+3]=8'b0000_0000;
    // inst_mem[20+4]=8'b0000_0000;
    // inst_mem[20+5]=8'b0000_0000;
    // inst_mem[20+6]=8'b0000_0000;
    // inst_mem[20+7]=8'b0000_0000;
    // inst_mem[20+8]=8'b0000_0000;
//
    // inst_mem[29]=8'b0000_0011;     //irmovq 
    // inst_mem[30]=8'b0110_1111;
    // inst_mem[29+2+0]=8'b0000_0101;
    // inst_mem[29+2+1]=8'b0000_0000;
    // inst_mem[29+2+2]=8'b0000_0000;
    // inst_mem[29+2+3]=8'b0000_0000;
    // inst_mem[29+2+4]=8'b0000_0000;
    // inst_mem[29+2+5]=8'b0000_0000;
    // inst_mem[29+2+6]=8'b0000_0000;
    // inst_mem[29+2+7]=8'b0000_0000; 
//
    // inst_mem[64]=8'b0000_0011;     //irmovq       Target
    // inst_mem[65]=8'b0111_1111;
    // inst_mem[64+2+0]=8'b0000_0101;
    // inst_mem[64+2+1]=8'b0000_0000;
    // inst_mem[64+2+2]=8'b0000_0000;
    // inst_mem[64+2+3]=8'b0000_0000;
    // inst_mem[64+2+4]=8'b0000_0000;
    // inst_mem[64+2+5]=8'b0000_0000;
    // inst_mem[64+2+6]=8'b0000_0000;
    // inst_mem[64+2+7]=8'b0000_0000; 
//
    // inst_mem[74]=8'b0000_1001;   //ret
//
    // inst_mem[75]=8'b0000_0011;     //irmovq
    // inst_mem[76]=8'b0000_1111;
    // inst_mem[75+2+0]=8'b0000_0001;
    // inst_mem[75+2+1]=8'b0000_0000;
    // inst_mem[75+2+2]=8'b0000_0000;
    // inst_mem[75+2+3]=8'b0000_0000;
    // inst_mem[75+2+4]=8'b0000_0000;
    // inst_mem[75+2+5]=8'b0000_0000;
    // inst_mem[75+2+6]=8'b0000_0000;
    // inst_mem[75+2+7]=8'b0000_0000; 

//-------------------End of Ret-------------------------------






  //----------------Start of Branch Misprediction-------------
    /// inst_mem[10]=8'b0000_0011;     //irmovq
    /// inst_mem[11]=8'b0000_1111;
    /// inst_mem[10+2+0]=8'b0000_0001;
    /// inst_mem[10+2+1]=8'b0000_0000;
    /// inst_mem[10+2+2]=8'b0000_0000;
    /// inst_mem[10+2+3]=8'b0000_0000;
    /// inst_mem[10+2+4]=8'b0000_0000;
    /// inst_mem[10+2+5]=8'b0000_0000;
    /// inst_mem[10+2+6]=8'b0000_0000;
    /// inst_mem[10+2+7]=8'b0000_0000; 
///
    /// inst_mem[20]=8'b0011_0110;    //xorq
    /// inst_mem[20+1]=8'b0000_0000;
///
    /// 
    /// inst_mem[22]=8'b0100_0111;     //jne
    /// inst_mem[22+1]=8'b0100_0000;
    /// inst_mem[22+2]=8'b0000_0000;
    /// inst_mem[22+3]=8'b0000_0000;
    /// inst_mem[22+4]=8'b0000_0000;
    /// inst_mem[22+5]=8'b0000_0000;
    /// inst_mem[22+6]=8'b0000_0000;
    /// inst_mem[22+7]=8'b0000_0000;
    /// inst_mem[22+8]=8'b0000_0000;
///
    /// inst_mem[64]=8'b0000_0011;     //irmovq
    /// inst_mem[65]=8'b0010_1111;
    /// inst_mem[64+2+0]=8'b0000_0010;
    /// inst_mem[64+2+1]=8'b0000_0000;
    /// inst_mem[64+2+2]=8'b0000_0000;
    /// inst_mem[64+2+3]=8'b0000_0000;
    /// inst_mem[64+2+4]=8'b0000_0000;
    /// inst_mem[64+2+5]=8'b0000_0000;
    /// inst_mem[64+2+6]=8'b0000_0000;
    /// inst_mem[64+2+7]=8'b0000_0000; 
///
    /// inst_mem[74]=8'b0000_0011;     //irmovq
    /// inst_mem[75]=8'b0011_1111;
    /// inst_mem[74+2+0]=8'b0000_0011;
    /// inst_mem[74+2+1]=8'b0000_0000;
    /// inst_mem[74+2+2]=8'b0000_0000;
    /// inst_mem[74+2+3]=8'b0000_0000;
    /// inst_mem[74+2+4]=8'b0000_0000;
    /// inst_mem[74+2+5]=8'b0000_0000;
    /// inst_mem[74+2+6]=8'b0000_0000;
    /// inst_mem[74+2+7]=8'b0000_0000; 
///
    /// inst_mem[31]=8'b0000_0011;     //irmovq
    /// inst_mem[32]=8'b0000_1111;
    /// inst_mem[31+2+0]=8'b0000_0001;
    /// inst_mem[31+2+1]=8'b0000_0000;
    /// inst_mem[31+2+2]=8'b0000_0000;
    /// inst_mem[31+2+3]=8'b0000_0000;
    /// inst_mem[31+2+4]=8'b0000_0000;
    /// inst_mem[31+2+5]=8'b0000_0000;
    /// inst_mem[31+2+6]=8'b0000_0000;
    /// inst_mem[31+2+7]=8'b0000_0000; 
 ///
///
    /// inst_mem[41]=8'b0000_0110;     //addq
    /// inst_mem[42]=8'b0000_0000;
////----------------End of Branch-Misprediction------------







///---------------Load/Use Hazard---------------------
     ///////inst_mem[10]=8'b0000_0011;            //irmovq
     ///////inst_mem[11]=8'b0010_1111;
     ///////inst_mem[10+2+0]=8'b0000_1000;
     ///////inst_mem[10+2+1]=8'b0000_0000;
     ///////inst_mem[10+2+2]=8'b0000_0000;
     ///////inst_mem[10+2+3]=8'b0000_0000;
     ///////inst_mem[10+2+4]=8'b0000_0000;
     ///////inst_mem[10+2+5]=8'b0000_0000;
     ///////inst_mem[10+2+6]=8'b0000_0000;
     ///////inst_mem[10+2+7]=8'b0000_0000; 
///////
///////
 ///////
     ///////inst_mem[20]=8'b0000_0011;            //irmovq
     ///////inst_mem[21]=8'b0001_1111;
     ///////inst_mem[20+2+0]=8'b0000_1111;
     ///////inst_mem[20+2+1]=8'b0000_0000;
     ///////inst_mem[20+2+2]=8'b0000_0000;
     ///////inst_mem[20+2+3]=8'b0000_0000;
     ///////inst_mem[20+2+4]=8'b0000_0000;
     ///////inst_mem[20+2+5]=8'b0000_0000;
     ///////inst_mem[20+2+6]=8'b0000_0000;
     ///////inst_mem[20+2+7]=8'b0000_0000;
///////
     ///////inst_mem[30]=8'b0000_0100;            //rmmovq
     ///////inst_mem[31]=8'b0010_0001;
     ///////inst_mem[30+2+0]=8'b0000_0000;
     ///////inst_mem[30+2+1]=8'b0000_0000;
     ///////inst_mem[30+2+2]=8'b0000_0000;
     ///////inst_mem[30+2+3]=8'b0000_0000;
     ///////inst_mem[30+2+4]=8'b0000_0000;
     ///////inst_mem[30+2+5]=8'b0000_0000;
     ///////inst_mem[30+2+6]=8'b0000_0000;
     ///////inst_mem[30+2+7]=8'b0000_0000;
///////
     ///////inst_mem[40]=8'b0000_0011;            //irmovq
     ///////inst_mem[41]=8'b0011_1111;
     ///////inst_mem[40+2+0]=8'b0000_0011;
     ///////inst_mem[40+2+1]=8'b0000_0000;
     ///////inst_mem[40+2+2]=8'b0000_0000;
     ///////inst_mem[40+2+3]=8'b0000_0000;
     ///////inst_mem[40+2+4]=8'b0000_0000;
     ///////inst_mem[40+2+5]=8'b0000_0000;
     ///////inst_mem[40+2+6]=8'b0000_0000;
     ///////inst_mem[40+2+7]=8'b0000_0000;
///////
     ///////inst_mem[50]=8'b0000_0101;            //mrmovq
     ///////inst_mem[51]=8'b0010_0000;
     ///////inst_mem[50+2+0]=8'b0000_0000;
     ///////inst_mem[50+2+1]=8'b0000_0000;
     ///////inst_mem[50+2+2]=8'b0000_0000;
     ///////inst_mem[50+2+3]=8'b0000_0000;
     ///////inst_mem[50+2+4]=8'b0000_0000;
     ///////inst_mem[50+2+5]=8'b0000_0000;
     ///////inst_mem[50+2+6]=8'b0000_0000;
     ///////inst_mem[50+2+7]=8'b0000_0000;
///////
     ///////inst_mem[60]=8'b0000_0110;           //addq       
     ///////inst_mem[61]=8'b0000_0011;    
///////
///////
     ///////inst_mem[62]=8'b0001_0110;           //subq       
     ///////inst_mem[63]=8'b0000_0011;
///////
     ///////inst_mem[64]=8'b0010_0110;           //andq       
     ///////inst_mem[65]=8'b0010_0001;
///////
///////-----------------End of LOAD USE HAZARD---------------------





     //inst_mem[30]=8'b0001_0110;            //subq
     //inst_mem[31]=8'b0001_0110;
//
     //inst_mem[32]=8'b0000_0010;            
     //inst_mem[33]=8'b0001_0110;     
//
     //inst_mem[34]=8'b0000_1000;            //callq
     //inst_mem[33+2+0]=8'b0100_0000;
     //inst_mem[33+2+1]=8'b0000_0000;
     //inst_mem[33+2+2]=8'b0000_0000;
     //inst_mem[33+2+3]=8'b0000_0000;
     //inst_mem[33+2+4]=8'b0000_0000;
     //inst_mem[33+2+5]=8'b0000_0000;
     //inst_mem[33+2+6]=8'b0000_0000;
     //inst_mem[33+2+7]=8'b0000_0000;

    // inst_mem[64]=8'b0000_0110;            //addq
    // inst_mem[65]=8'b0001_0110;     
     
     
     
     
     
     
     
     //inst_mem[34]=8'b0000_0100;            //rmmovq
     //inst_mem[35]=8'b0001_0110;
     //inst_mem[34+2+0]=8'b0001_1111;
     //inst_mem[34+2+1]=8'b0000_0000;
     //inst_mem[34+2+2]=8'b0000_0000;
     //inst_mem[34+2+3]=8'b0000_0000;
     //inst_mem[34+2+4]=8'b0000_0000;
     //inst_mem[34+2+5]=8'b0000_0000;
     //inst_mem[34+2+6]=8'b0000_0000;
     //inst_mem[34+2+7]=8'b0000_0000;
//
//
//
//
     //inst_mem[44]=8'b0000_0010;            //rrmovq
     //inst_mem[45]=8'b1110_0110;




    // inst_mem[20]=8'b0000_0100;            //rmmovq
    // inst_mem[21]=8'b0001_0110;
    // inst_mem[20+2+0]=8'b0000_1111;
    // inst_mem[20+2+1]=8'b0000_0000;
    // inst_mem[20+2+2]=8'b0000_0000;
    // inst_mem[20+2+3]=8'b0000_0000;
    // inst_mem[20+2+4]=8'b0000_0000;
    // inst_mem[20+2+5]=8'b0000_0000;
    // inst_mem[20+2+6]=8'b0000_0000;
    // inst_mem[20+2+7]=8'b0000_0000; 
     
     
     //inst_mem[30]=8'b0000_0110;            //addq
     //inst_mem[31]=8'b1000_0111;
    
     //inst_mem[32]=8'b0001_0110;            //subq
     //inst_mem[33]=8'b0101_0010;
     
     //inst_mem[12]=8'b0000_0110;
     //inst_mem[13]=8'b0111_1000;
     //inst_mem[14]=8'b0001_0110;
     //inst_mem[15]=8'b0110_1001;
     //inst_mem[16]=8'b0011_0111;

     
     
     
     
    
 end



always @ (*)
   begin
   if (W_icode==4'b1001)
      pc=W_valM;

   else if(M_icode==4'b0111 && M_Cnd==1'b0)
      pc=M_valA;


   else 
      pc=predpc;

   end

 
 

always @ (pc)
  begin
  
    split = inst_mem[pc];
    icode = split[3:0];
    ifun = split[7:4];

    if((icode ==4'b0000) && (ifun == 4'b0000))  //Halt
      begin
      valp = pc+1;
      inst_valid = 1'b1;
      end
    else if((icode ==4'b0001) && (ifun == 4'b0000))   //nop
      begin
      valp = pc+1;
      inst_valid = 1'b1;
      end

    else if(icode == 4'b0010)     //cmovXX
      begin
      
       align[7:0]=inst_mem[pc+1];
       ra=align[3:0];
       rb=align[7:4];
       valp=pc+2;
       inst_valid=1'b1;
       
      end

    else if((icode == 4'b0011)&&(ifun == 4'b0000))   //irmovq
      begin 
      align[7:0]=inst_mem[pc+1];
      ra=align[3:0];    
      rb=align[7:4]; 
      valc[7:0]<=inst_mem[pc+2];
      valc[15:8]<=inst_mem[pc+3];
      valc[23:16]<=inst_mem[pc+4];
      valc[31:24]<=inst_mem[pc+5];
      valc[39:32]<=inst_mem[pc+6];
      valc[47:40]<=inst_mem[pc+7];
      valc[55:48]<=inst_mem[pc+8];
      valc[63:56]<=inst_mem[pc+9];
      valp=pc+10;
      inst_valid=1'b1;
      end

    else if((icode == 4'b0100)&&(ifun == 4'b0000))   //rmmovq
      begin 
      align[7:0]=inst_mem[pc+1];
      ra=align[3:0];   
      rb=align[7:4]; 
      valc[7:0]<=inst_mem[pc+2];
      valc[15:8]<=inst_mem[pc+3];
      valc[23:16]<=inst_mem[pc+4];
      valc[31:24]<=inst_mem[pc+5];
      valc[39:32]<=inst_mem[pc+6];
      valc[47:40]<=inst_mem[pc+7];
      valc[55:48]<=inst_mem[pc+8];
      valc[63:56]<=inst_mem[pc+9];
      valp=pc+10;
      inst_valid=1'b1;
      end

    
    else if((icode == 4'b0101)&&(ifun == 4'b0000))   //mrmovq
      begin 
      align[7:0]=inst_mem[pc+1];
      ra=align[3:0];   
      rb=align[7:4]; 
      valc[7:0]<=inst_mem[pc+2];
      valc[15:8]<=inst_mem[pc+3];
      valc[23:16]<=inst_mem[pc+4];
      valc[31:24]<=inst_mem[pc+5];
      valc[39:32]<=inst_mem[pc+6];
      valc[47:40]<=inst_mem[pc+7];
      valc[55:48]<=inst_mem[pc+8];
      valc[63:56]<=inst_mem[pc+9];
      valp=pc+10;
      inst_valid=1'b1;
      end

    else if(icode == 4'b0110)   //opq
      begin
       if(ifun==4'b0000)       //addq
        begin
        align[7:0]=inst_mem[pc+1];
        ra=align[3:0];   
        rb=align[7:4]; 
        valp=pc+2;
        inst_valid=1'b1;
        end
       else if(ifun==4'b0001)   //subq
        begin
        align[7:0]=inst_mem[pc+1];
        ra=align[3:0];   
        rb=align[7:4]; 
        valp=pc+2;
        inst_valid=1'b1;
        end
       else if(ifun==4'b0010)   //andq
        begin
        align[7:0]=inst_mem[pc+1];
        ra=align[3:0];   
        rb=align[7:4]; 
        valp=pc+2;
        inst_valid=1'b1;
        end
       else if(ifun==4'b0011)   //xorq
        begin
        align[7:0]=inst_mem[pc+1];
        ra=align[3:0];   
        rb=align[7:4]; 
        valp=pc+2;
        inst_valid=1'b1;
        end
      end   
           
    
    else if(icode==4'b0111)   //jXX
      begin
      valc[7:0]<=inst_mem[pc+1];
      valc[15:8]<=inst_mem[pc+2];
      valc[23:16]<=inst_mem[pc+3];
      valc[31:24]<=inst_mem[pc+4];
      valc[39:32]<=inst_mem[pc+5];
      valc[47:40]<=inst_mem[pc+6];
      valc[55:48]<=inst_mem[pc+7];
      valc[63:56]<=inst_mem[pc+8];
      valp =pc+9;
      inst_valid=1'b1;
      end

    else if((icode==4'b1000)&&(ifun==4'b0000))   //call
      begin
      valc[7:0]<=inst_mem[pc+1];
      valc[15:8]<=inst_mem[pc+2];
      valc[23:16]<=inst_mem[pc+3];
      valc[31:24]<=inst_mem[pc+4];
      valc[39:32]<=inst_mem[pc+5];
      valc[47:40]<=inst_mem[pc+6];
      valc[55:48]<=inst_mem[pc+7];
      valc[63:56]<=inst_mem[pc+8];
      valp= pc+9;
      inst_valid=1'b1;
      end

    else if((icode==4'b1001)&&(ifun==4'b0000))   //ret
      begin
      valp = pc+1;
      inst_valid = 1'b1;
      end

    else if((icode==4'b1010)&&(ifun==4'b0000))   //pushq
      begin
      align[7:0]=inst_mem[pc+1];
      ra=align[3:0];
      rb=align[7:4];
      valp=pc+2;
      inst_valid=1'b1;
      end

    else if((icode==4'b1011)&&(ifun==4'b0000))   //popq
      begin
      align[7:0]=inst_mem[pc+1];
      ra=align[3:0];
      rb=align[7:4];
      valp=pc+2;
      inst_valid=1'b1;
      end

    else 
      inst_valid=1'b0;

    if (pc>65535)
       imem_error=1'b1;
    else
       imem_error=1'b0;

    if(inst_valid==1'b0)
       status=3'b011;              //INS  3'b011
    
    else if(imem_error==1'b1)
       status=3'b010;             //ADR  3'b010
    
    else if(icode==4'b0000)
       status=3'b100;               //HLT 3'b100
    else 
       status=3'b000;              //AOK 3'b000

    end

    always@(*)
    begin
    if ((icode==4'b0001) || (icode==4'b0010) ||(icode==4'b0011) ||(icode==4'b0100) ||(icode==4'b0101 )||(icode==4'b0110) ||(icode==4'b1001) ||(icode==4'b1010 )||(icode==4'b1011))
      nextpredpc = valp;
    if ((icode==4'b0111 )||(icode==4'b1000))
      nextpredpc=valc;   

    
   if((e_icode==4'b0111)&&(e_cnd==1'b0))
      nextpredpc=E_valA;

   if(W_icode==4'b000)
      nextpredpc=W_valM;
  
    end
    

    
  
endmodule
    

    

    

    
        

       
        


