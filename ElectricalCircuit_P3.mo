package ElectricalCircuit_P3
//Modeling Technical Systems, WS2024 - S. Kocher, F. Šahat, L. Trojnar 

model P3_Circuit_Example1
  PhysicalFaultModeling.PFM_VariableResistor r_load(r = 50);
  PhysicalFaultModeling.PFM_Battery b1(vn = 4.5, maxCharge = 10, r_int = 5);
  PhysicalFaultModeling.PFM_Battery b2(vn = 4.5, maxCharge = 15, r_int = 10);
  PhysicalFaultModeling.PFM_Battery b3(vn = 4.5, maxCharge = 5, r_int = 5);
  PhysicalFaultModeling.PFM_Switch s1;
  PhysicalFaultModeling.PFM_Switch s2;
  PhysicalFaultModeling.PFM_Switch s3;
equation
  connect(r_load.m, b1.m);
end P3_Circuit_Example1;

end ElectricalCircuit_P3;
