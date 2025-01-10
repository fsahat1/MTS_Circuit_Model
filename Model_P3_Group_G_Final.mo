package Model_P3_Group_G

model Initial_Circuit
  PhysicalFaultModeling.PFM_VariableResistor r_load(r = 500);
  PhysicalFaultModeling.PFM_Battery[3] bats(
    vn = {100, 100, 100}, 
    r_int = {100, 100, 100});
  PhysicalFaultModeling.PFM_Switch[3] s; //(
  //mode = {PhysicalFaultModeling.OperationalMode.close, PhysicalFaultModeling.OperationalMode.open, PhysicalFaultModeling.OperationalMode.open});
  PhysicalFaultModeling.PFM_Ground gnd;
  Modelica.Units.SI.Voltage target_v;
  Real tolerance;
  Integer bat_num;
equation
  bat_num = 3;
  connect(r_load.p, gnd.p);
  connect(r_load.m, bats[1].m);
  connect(r_load.m, bats[2].m);
  connect(r_load.m, bats[3].m);
  connect(bats[1].p, s[1].p);
  connect(bats[2].p, s[2].p);
  connect(bats[3].p, s[3].p);
  connect(s[1].m, r_load.p);
  connect(s[2].m, r_load.p);
  connect(s[3].m, r_load.p);
end Initial_Circuit;

  function VoltageController
    //turns batteries on/off sequentially until goal is reached
    input Modelica.Units.SI.Resistance r_load;
    input Modelica.Units.SI.Voltage target;
    input Real tolerance; 
    input Integer max_n;
    input Modelica.Units.SI.Voltage bat;
    input Modelica.Units.SI.Resistance int_r; 
    output Integer new_n;
  protected
    Real b_rload; //B * Rload
    Real v_out;
    Real over_t;  //tolerable voltage over target
    Real under_t; //tolerable voltage under target
  algorithm
    under_t := target * tolerance;
    over_t := target * (2.0 - tolerance);
    b_rload := bat * r_load;
    v_out := (b_rload) / (r_load + int_r);
    new_n := 1;
    while v_out < under_t loop
      if new_n == max_n then 
        return;
      end if;
      new_n := new_n + 1;
      v_out := (new_n * b_rload) / (new_n * r_load + int_r);
    end while;
    while v_out > over_t loop
      if new_n == 1 then 
        return;
      end if;
      new_n := new_n - 1;
      v_out := (new_n * b_rload) / (new_n * r_load + int_r);
    end while; 
  end VoltageController;


model Circuit_Scenario1
  Initial_Circuit circ1;
  Integer on;
equation
  //changing of percentages between multiple values, all elements good
  
  //Target voltage and tolerance
  circ1.target_v = 95.0;
  circ1.tolerance = 0.9;
  
  //initial states of batteries and switches
  circ1.bats[1].state = PhysicalFaultModeling.FaultType.ok;
  circ1.bats[2].state = PhysicalFaultModeling.FaultType.ok;
  circ1.bats[3].state = PhysicalFaultModeling.FaultType.ok;
  circ1.s[1].state = PhysicalFaultModeling.FaultType.ok;
  circ1.s[2].state = PhysicalFaultModeling.FaultType.ok;
  circ1.s[3].state = PhysicalFaultModeling.FaultType.ok;
  circ1.r_load.state = PhysicalFaultModeling.FaultType.ok;
 
 
  //algorithm
  
  when initial() then
    circ1.r_load.percentage = 100;
    on = 1;
  elsewhen time > 0 then
    circ1.r_load.percentage = 100;
    on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
  elsewhen time > 1 then
    circ1.r_load.percentage = 15;
    on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
  elsewhen time > 2 then
    circ1.r_load.percentage = 300;
    on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
   elsewhen time > 3 then
    circ1.r_load.percentage = 100;
    on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
  end when;
  for i in 1:3 loop
    if i <= on then
      circ1.s[i].mode = PhysicalFaultModeling.OperationalMode.close;
    else 
      circ1.s[i].mode = PhysicalFaultModeling.OperationalMode.open;
    end if;
  end for;
  annotation(
    experiment(StartTime = 0, StopTime = 6, Tolerance = 1e-06, Interval = 0.1));
end Circuit_Scenario1;

model Circuit_Scenario2
  Initial_Circuit circ1;
  Integer on;

equation
  //changing of percentages between multiple values, all elements good
  
  //Target voltage and tolerance
  circ1.target_v = 75.0;
  circ1.tolerance = 0.95;
  
  //initial states of batteries and switches
  circ1.bats[1].state = PhysicalFaultModeling.FaultType.ok;
  circ1.bats[2].state = PhysicalFaultModeling.FaultType.ok;
  circ1.bats[3].state = PhysicalFaultModeling.FaultType.ok;
  circ1.s[1].state = PhysicalFaultModeling.FaultType.ok;
  circ1.s[2].state = PhysicalFaultModeling.FaultType.ok;
  circ1.s[3].state = PhysicalFaultModeling.FaultType.ok;
  circ1.r_load.state = PhysicalFaultModeling.FaultType.ok;
  
  //algorithm
  when initial() then
    circ1.r_load.percentage = 100;
    on = 1;
  elsewhen time > 0 then
    circ1.r_load.percentage = 15;
    on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
  elsewhen time > 1 then
    circ1.r_load.percentage = 30;
    on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
  elsewhen time > 2 then
    circ1.r_load.percentage = 60;
    on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
  elsewhen time > 3 then
    circ1.r_load.percentage = 120;
    on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
  elsewhen time > 4 then
    circ1.r_load.percentage = 240;
    on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
  end when;
  for i in 1:3 loop
    if i <= on then
      circ1.s[i].mode = PhysicalFaultModeling.OperationalMode.close;
    else 
      circ1.s[i].mode = PhysicalFaultModeling.OperationalMode.open;
    end if;
  end for;
  
  annotation(
    experiment(StartTime = 0, StopTime = 6, Tolerance = 1e-06, Interval = 0.1));
end Circuit_Scenario2;

  model Circuit_Scenario3
    Initial_Circuit circ1;
    Integer on;
  equation
    //changing of percentages between multiple values, all elements good
    
    //Target voltage and tolerance
    circ1.target_v = 90.0;
    circ1.tolerance = 0.95;
    
    //initial states of batteries and switches [circ1 will fail twice]
    //circ1.bats[1].state = PhysicalFaultModeling.FaultType.ok;
    circ1.bats[2].state = PhysicalFaultModeling.FaultType.ok;
    circ1.bats[3].state = PhysicalFaultModeling.FaultType.ok;
    circ1.s[1].state = PhysicalFaultModeling.FaultType.ok;
    circ1.s[2].state = PhysicalFaultModeling.FaultType.ok;
    circ1.s[3].state = PhysicalFaultModeling.FaultType.ok;
    circ1.r_load.state = PhysicalFaultModeling.FaultType.ok;
    
    //algorithm
    
    when initial() then
      circ1.r_load.percentage = 100;
      on = 1;
      circ1.bats[1].state = PhysicalFaultModeling.FaultType.ok;
      
    elsewhen time > 0 then
      circ1.r_load.percentage = 50;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
      circ1.bats[1].state = PhysicalFaultModeling.FaultType.ok;
      
    elsewhen time > 1 then
      circ1.r_load.percentage = 100;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
      circ1.bats[1].state = PhysicalFaultModeling.FaultType.ok;
      
    elsewhen time > 2 then
      circ1.r_load.percentage = 25;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
      circ1.bats[1].state = PhysicalFaultModeling.FaultType.empty;
      
    elsewhen time > 3 then
      circ1.r_load.percentage = 75;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
      circ1.bats[1].state = PhysicalFaultModeling.FaultType.ok;
      
    elsewhen time > 4 then
      circ1.r_load.percentage = 50;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
      circ1.bats[1].state = PhysicalFaultModeling.FaultType.empty;
    end when;
    for i in 1:3 loop
      if i <= on then
        circ1.s[i].mode = PhysicalFaultModeling.OperationalMode.close;
      else 
        circ1.s[i].mode = PhysicalFaultModeling.OperationalMode.open;
      end if;
    end for;
    annotation(
      experiment(StartTime = 0, StopTime = 6, Tolerance = 1e-06, Interval = 0.1));
  end Circuit_Scenario3;

end Model_P3_Group_G;
