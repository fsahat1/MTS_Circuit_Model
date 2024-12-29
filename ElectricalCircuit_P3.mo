package ElectricalCircuit_P3
  //Modeling Technical Systems, WS2024 - S. Kocher, F. Šahat, L. Trojnar

model P3_Circuit_Example1
  PhysicalFaultModeling.PFM_VariableResistor r_load(r = 50);
  PhysicalFaultModeling.PFM_Battery b1(vn = 4.5, r_int = 5);
  PhysicalFaultModeling.PFM_Battery b2(vn = 4.5, r_int = 10);
  PhysicalFaultModeling.PFM_Battery b3(vn = 4.5, r_int = 5);
  PhysicalFaultModeling.PFM_Switch s1;
  PhysicalFaultModeling.PFM_Switch s2;
  PhysicalFaultModeling.PFM_Switch s3;
  PhysicalFaultModeling.PFM_Ground gnd;
equation
  connect(r_load.p, gnd.p);
  connect(r_load.p, b1.m);
  connect(r_load.p, b2.m);
  connect(r_load.p, b3.m);
  connect(b1.p, s1.m);
  connect(b2.p, s2.m);
  connect(b3.p, s3.m);
  connect(s1.p, r_load.m);
  connect(s2.p, r_load.m);
  connect(s3.p, r_load.m);
end P3_Circuit_Example1;

model P3Ex1_Testbench
  P3_Circuit_Example1 ex1;
equation
  ex1.r_load.state = PhysicalFaultModeling.FaultType.ok;
  ex1.b1.state = PhysicalFaultModeling.FaultType.ok;
  ex1.b2.state = PhysicalFaultModeling.FaultType.ok;
  ex1.b3.state = PhysicalFaultModeling.FaultType.ok;
  ex1.s1.state = PhysicalFaultModeling.FaultType.ok;
  ex1.s1.mode = PhysicalFaultModeling.OperationalMode.open;
  ex1.s2.state = PhysicalFaultModeling.FaultType.ok;
  ex1.s2.mode = PhysicalFaultModeling.OperationalMode.open;
  ex1.s3.state = PhysicalFaultModeling.FaultType.ok;
  ex1.s3.mode = PhysicalFaultModeling.OperationalMode.close;
  if time < 1 then
    ex1.r_load.percentage = 55;
  elseif time < 2 then
    ex1.r_load.percentage = 90;
  else
    ex1.r_load.percentage = 25;
  end if;
  annotation(
    experiment(StartTime = 0, StopTime = 3, Tolerance = 1e-06, Interval = 0.0001));
end P3Ex1_Testbench;

end ElectricalCircuit_P3;
