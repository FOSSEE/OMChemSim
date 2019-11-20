within Simulator.Files.ThermodynamicFunctions;

  function FindString
    extends Modelica.Icons.Function;
    input String Comp_A[:];
    input String Comp;
    output Integer Int;
  protected
    Integer i, Len = size(Comp_A, 1);
  algorithm
    Int := -1;
    i := 1;
    while Int == (-1) and i <= Len loop
      if Comp_A[i] == Comp then
        Int := i;
      end if;
      i := i + 1;
    end while;
  end FindString;
