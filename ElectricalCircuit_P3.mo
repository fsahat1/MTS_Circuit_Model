package ElectricalCircuit_P3
  //Modeling Technical Systems, WS2024 - S. Kocher, F. Šahat, L. Trojnar

model P3_Circuit_Example1
  PhysicalFaultModeling.PFM_VariableResistor r_load(r = 50);
  PhysicalFaultModeling.PFM_Battery b1(vn = 25, r_int = 5);
  PhysicalFaultModeling.PFM_Battery b2(vn = 15, r_int = 10);
  PhysicalFaultModeling.PFM_Battery b3(vn = 10, r_int = 10);
  PhysicalFaultModeling.PFM_Switch s1;
  PhysicalFaultModeling.PFM_Switch s2;
  PhysicalFaultModeling.PFM_Switch s3;
  PhysicalFaultModeling.PFM_Ground gnd;
equation
  connect(r_load.p, gnd.p);
  connect(r_load.m, b1.m);
  connect(r_load.m, b2.m);
  connect(r_load.m, b3.m);
  connect(b1.p, s1.p);
  connect(b2.p, s2.p);
  connect(b3.p, s3.p);
  connect(s1.m, r_load.p);
  connect(s2.m, r_load.p);
  connect(s3.m, r_load.p);
end P3_Circuit_Example1;

//Everything is working, Battery 3 provides energy

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

//R_load fails after some time

model P3Ex1_Testbench_2
  P3_Circuit_Example1 ex1;

equation
  ex1.r_load.percentage = 55;
  
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
    ex1.r_load.state = PhysicalFaultModeling.FaultType.ok;
  else
    ex1.r_load.state = PhysicalFaultModeling.FaultType.short;
  end if;
  annotation(
    experiment(StartTime = 0, StopTime = 3, Tolerance = 1e-06, Interval = 0.0001));
end P3Ex1_Testbench_2;

  
  
  //Extending Testbench_2: R_load is working, has a short and then breaks completely
  
  model P3Ex1_Testbench_3
    P3_Circuit_Example1 ex1;
  
  equation
    
    ex1.r_load.percentage = 55;
    
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
      ex1.r_load.state = PhysicalFaultModeling.FaultType.ok;
    elseif time >= 1 and time < 2 then
      ex1.r_load.state = PhysicalFaultModeling.FaultType.short;
    else
      ex1.r_load.state = PhysicalFaultModeling.FaultType.broken;
    end if;
    annotation(
      experiment(StartTime = 0, StopTime = 3, Tolerance = 1e-06, Interval = 0.0001));
  end P3Ex1_Testbench_3;
  
  //The battery which is supposed to provide energy is broken
  
  model P3Ex1_Testbench_4
    P3_Circuit_Example1 ex1;
  equation
    ex1.r_load.state = PhysicalFaultModeling.FaultType.ok;
    ex1.b1.state = PhysicalFaultModeling.FaultType.ok;
    ex1.b2.state = PhysicalFaultModeling.FaultType.ok;
    ex1.b3.state = PhysicalFaultModeling.FaultType.broken;
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
  end P3Ex1_Testbench_4;
  
  //Batteries 2 and 3 provide energy, but the switch 3 shorts and it provides always energy even after both switches close
  
  model P3Ex1_Testbench_5
    P3_Circuit_Example1 ex1;
  equation
    ex1.r_load.percentage = 55;
    ex1.r_load.state = PhysicalFaultModeling.FaultType.ok;
    ex1.b1.state = PhysicalFaultModeling.FaultType.ok;
    ex1.b2.state = PhysicalFaultModeling.FaultType.ok;
    ex1.b3.state = PhysicalFaultModeling.FaultType.ok;
    ex1.s1.state = PhysicalFaultModeling.FaultType.ok;
    ex1.s1.mode = PhysicalFaultModeling.OperationalMode.open;
   
    
    ex1.s3.state = PhysicalFaultModeling.FaultType.ok;
    
    
    if time < 1 then
      ex1.s2.mode = PhysicalFaultModeling.OperationalMode.close;
      ex1.s2.state = PhysicalFaultModeling.FaultType.ok;
      ex1.s3.mode = PhysicalFaultModeling.OperationalMode.close;
    elseif time < 2 then
      ex1.s2.mode = PhysicalFaultModeling.OperationalMode.close;
      ex1.s2.state = PhysicalFaultModeling.FaultType.short;
      ex1.s3.mode = PhysicalFaultModeling.OperationalMode.close;
    else
      ex1.s2.mode = PhysicalFaultModeling.OperationalMode.open;
      ex1.s2.state = PhysicalFaultModeling.FaultType.short;
      ex1.s3.mode = PhysicalFaultModeling.OperationalMode.open;
    end if;
    annotation(
      experiment(StartTime = 0, StopTime = 3, Tolerance = 1e-06, Interval = 0.0001));
  end P3Ex1_Testbench_5;
  
  model P3Ex1_Testbench_6
    P3_Circuit_Example1 ex1;
  equation
    ex1.r_load.percentage = 55;
    ex1.r_load.state = PhysicalFaultModeling.FaultType.ok;
    //ex1.b1.state = PhysicalFaultModeling.FaultType.ok;
    //ex1.b2.state = PhysicalFaultModeling.FaultType.ok;
   // ex1.b3.state = PhysicalFaultModeling.FaultType.ok;
    
    ex1.s1.state = PhysicalFaultModeling.FaultType.ok;
    ex1.s1.mode = PhysicalFaultModeling.OperationalMode.open;
    
    ex1.s2.state = PhysicalFaultModeling.FaultType.ok;
    ex1.s2.mode = PhysicalFaultModeling.OperationalMode.open;
    
    ex1.s3.state = PhysicalFaultModeling.FaultType.ok;
    ex1.s3.mode = PhysicalFaultModeling.OperationalMode.open;
    
    
    if time < 0.5 then
      ex1.b1.state = PhysicalFaultModeling.FaultType.ok;
      ex1.b2.state = PhysicalFaultModeling.FaultType.ok;
      ex1.b3.state = PhysicalFaultModeling.FaultType.ok;
    elseif time < 1 then
      ex1.b1.state = PhysicalFaultModeling.FaultType.ok;
      ex1.b2.state = PhysicalFaultModeling.FaultType.ok;
      ex1.b3.state = PhysicalFaultModeling.FaultType.empty;
    elseif time < 1.5 then
      ex1.b1.state = PhysicalFaultModeling.FaultType.ok;
      ex1.b2.state = PhysicalFaultModeling.FaultType.empty;
      ex1.b3.state = PhysicalFaultModeling.FaultType.empty;  
    else
      ex1.b1.state = PhysicalFaultModeling.FaultType.empty;
      ex1.b2.state = PhysicalFaultModeling.FaultType.empty;
      ex1.b3.state = PhysicalFaultModeling.FaultType.empty;
    end if;
    annotation(
      experiment(StartTime = 0, StopTime = 3, Tolerance = 1e-06, Interval = 0.0001));
  end P3Ex1_Testbench_6;

  function VoltageController
    //turns on batteries with the highest "unused" voltage until goal is reached
    input Modelica.Units.SI.Resistance r_int;
    input Modelica.Units.SI.Resistance target;
    input Integer len;
    input Modelica.Units.SI.Voltage bats[len];
    input Modelica.Units.SI.Resistance int_rs[len];
    input Boolean active_bats[len]; 
    output Boolean switches[len];
  protected
    Real num;
    Real denom;
    Real temp_num;
    Real temp_denom;
    Integer on_count;
    Integer found_switch;
  algorithm
    switches := active_bats;
    num := 0;
    denom := 0;
    temp_num := 0;
    temp_denom := 0;
    on_count := 0;
    found_switch := -1;
    for i in 1:len loop
      if active_bats[i] == true then 
        num := num + bats[i] / int_rs[i];
        denom := denom + 1.0 / int_rs[i];
        on_count := on_count + 1;
      end if; 
    end for;
  
    denom := denom + 1.0 / r_int;
  
    for j in 1:on_count loop
      (found_switch, temp_num, temp_denom) := ChooseSwitches(len, num, denom, target, bats, int_rs, active_bats); 
      if found_switch == -1 then
        return;
      elseif target - temp_num/temp_denom < 0 then
        switches[found_switch] := true;
        num := temp_num;
        denom := temp_denom;
        return;
      else
        switches[found_switch] := true;
        num := temp_num;
        denom := temp_denom;
      end if;
    end for;
  end VoltageController;

  function ChooseSwitches 
  //finds the battery with largest impact and turns it on
   input Integer len;
   input Real num;
   input Real denom;
   input Real target; 
   input Modelica.Units.SI.Resistance potential_rs[len];
   input Modelica.Units.SI.Voltage potential_vs[len];
   input Boolean active_switches[len];
   output Integer bat_num;
   output Real new_num;
   output Real new_denom;
  protected
   Real max_impact;
   Real temp;
   Real temp_num;
   Real temp_denom;
   Real diff;
  algorithm 
   diff := target - num/denom;
   max_impact := diff;
   bat_num := -1;
   for i in 1:len loop
      if active_switches[i] == false then
        (temp, temp_num, temp_denom) := CheckBalance(num, denom, potential_rs[i], potential_vs[i], target);
        if temp < max_impact then
          bat_num := i;
          max_impact := temp;
          new_num := temp_num;
          new_denom := temp_denom;
        end if;
      end if;
   end for; 
  end ChooseSwitches;
 

  function CheckBalance
  //checks individual impact on circuit
   input Real num;
   input Real denom;
   input Real res;
   input Real vol;
   input Real target;
   output Real epsilon;
   output Real vout_num;
   output Real vout_denom;
  protected
   parameter Real new_in_num;
   parameter Real new_in_denom;
  algorithm 
   new_in_num := vol / res;
   new_in_denom := 1.0 / res;
   
   vout_num := num + new_in_num;
   vout_denom := denom + new_in_denom;
   epsilon := target - num/denom;  
  end CheckBalance;

end ElectricalCircuit_P3;
