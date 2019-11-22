within Simulator.Files.ThermodynamicFunctions;

   function LiquidFugacityCoeffcient
   extends Modelica.Icons.Function;
   
   input Integer Nc;
   input Real Tc[Nc];
   input Real Pc[Nc];
   input Real W_c[Nc];
   input Real T,P;
   input Real V_c[Nc];
   input Real S;
   input Real gma_c[Nc];
   
   output Real Philiq_c[Nc](each start = 2);
   protected Real Tr_c[Nc];
   protected Real Pr_c[Nc];
   protected Real v0_c[Nc](each start=2),v1_c[Nc](each start=2),v_c[Nc];
   protected Real A[10];
   
   algorithm
    
   
     for i in 1:Nc loop
     Tr_c[i] := T / Tc[i];
     Pr_c[i] := P / Pc[i];
    
     if(Tc[i] == 33.19) then
       A[1] := 1.50709;
       A[2] := 2.74283;
       A[3] := -0.0211;
       A[4] := 0.00011;
       A[5] := 0;
       A[6] := 0.008585;
       A[7] := 0;
       A[8] := 0;
       A[9] := 0;
       A[10] :=0;
     
          v0_c[i] := 10^(A[1] + (A[2]/Tr_c[i]) + (A[3]*Tr_c[i])+(A[4] *Tr_c[i] *Tr_c[i])+(A[5] *Tr_c[i]*Tr_c[i]*Tr_c[i])+((A[6] +(A[7] *Tr_c[i]) +(A[8]*Tr_c[i]*Tr_c[i]))*Pr_c[i])+((A[9] +(A[10]*Tr_c[i]))*(Pr_c[i]*Pr_c[i])) - (log10(Pr_c[i])));
         
      elseif(Tc[i] == 190.56) then 
       A[1] := 1.36822;
       A[2] := -1.54831;
       A[3] := 0;
       A[4] := 0.02889;
       A[5] := -0.01076;
       A[6] := 0.10486;
       A[7] := -0.02529;
       A[8] := 0;
       A[9] := 0;
       A[10] := 0;
    
      v0_c[i] := 10^(A[1] + (A[2]/Tr_c[i]) + (A[3]*Tr_c[i])+(A[4] *Tr_c[i] *Tr_c[i])+(A[5] *Tr_c[i]*Tr_c[i]*Tr_c[i])+((A[6] +(A[7] *Tr_c[i]) +(A[8]*Tr_c[i]*Tr_c[i]))*Pr_c[i])+((A[9] +(A[10]*Tr_c[i]))*(Pr_c[i]*Pr_c[i])) - (log10(Pr_c[i])));   
     
     else 
       A[1] := 2.05135;
       A[2] := -2.10889;
       A[3] := 0;
       A[4] := -0.19396;
       A[5] := 0.02282;
       A[6] := 0.08852;
       A[7] := 0;
       A[8] := -0.00872;
       A[9] := -0.00353;
       A[10] := 0.00203;
     
     v0_c[i] := 10^(A[1] + (A[2]/Tr_c[i]) + (A[3]*Tr_c[i])+(A[4] *Tr_c[i] *Tr_c[i])+(A[5] *Tr_c[i]*Tr_c[i]*Tr_c[i])+((A[6] +(A[7] *Tr_c[i]) +(A[8]*Tr_c[i]*Tr_c[i]))*Pr_c[i])+((A[9] +(A[10]*Tr_c[i]))*(Pr_c[i]*Pr_c[i])) - (log10(Pr_c[i])));
       
    end if;
    
      v1_c[i] := 10^(-4.23893 + (8.65808 * Tr_c[i]) - (1.2206 / Tr_c[i]) - (3.15224 * Tr_c[i] ^ 3) - 0.025 * (Pr_c[i] - 0.6));
    
    if(v1_c[i] == 0) then 
      v_c[i]  := 10^(log10(v0_c[i]) );
    else 
      v_c[i]  := 10^(log10(v0_c[i]) + (W_c[i] * log10(v1_c[i])));
    end if; 
     Philiq_c[i] := v_c[i] * gma_c[i];
   end for; 
   
   end LiquidFugacityCoeffcient;
