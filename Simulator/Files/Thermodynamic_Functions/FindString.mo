within Simulator.Files.Thermodynamic_Functions;

function FindString
  input String compound_array[:];
  input String compound;
  output Integer int;
protected
  Integer i, len = size(compound_array, 1);
algorithm
  int := -1;
  i := 1;
  while int == (-1) and i <= len loop
    if compound_array[i] == compound then
      int := i;
    end if;
    i := i + 1;
  end while;
end FindString;
