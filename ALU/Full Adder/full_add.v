module full_add (a,b,cyin,sum,cyout);
     input a,b,cyin;
     output sum,cyout;
     wire k,x,y,z;
     xor g1 (k,a,b);
     xor g2 (sum,k,cyin);
     and g3 (x,a,b);
     and g4 (y,b,cyin);
     and g5 (z,cyin,a);
     or g6 (cyout,x,y,z);
endmodule