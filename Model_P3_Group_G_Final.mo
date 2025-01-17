package Model_P3_Group_G
  model Initial_Circuit
    PhysicalFaultModeling.PFM_VariableResistor r_load(r = 500);
    PhysicalFaultModeling.PFM_Battery[3] bats(vn = {100, 100, 100}, r_int = {100, 100, 100});
    PhysicalFaultModeling.PFM_Switch[3] s;
    //(
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
    Real b_rload;
    //B * Rload
    Real v_out;
    Real over_t;
    //tolerable voltage over target
    Real under_t;
    //tolerable voltage under target
  algorithm
    under_t := target*tolerance;
    over_t := target*(2.0 - tolerance);
    b_rload := bat*r_load;
    v_out := (b_rload)/(r_load + int_r);
    new_n := 1;
    while v_out < under_t loop
      if new_n == max_n then
        return;
      end if;
      new_n := new_n + 1;
      v_out := (new_n*b_rload)/(new_n*r_load + int_r);
    end while;
    while v_out > over_t loop
      if new_n == 1 then
        return;
      end if;
      new_n := new_n - 1;
      v_out := (new_n*b_rload)/(new_n*r_load + int_r);
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

  model Circuit_Scenario4
    Initial_Circuit circ1;
    Integer on;
  equation
//changing of percentages between multiple values, all elements good
//Target voltage and tolerance
    circ1.target_v = 80.0;
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
      circ1.r_load.percentage = 10;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 1 then
      circ1.r_load.percentage = 15;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 2 then
      circ1.r_load.percentage = 90;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 3 then
      circ1.r_load.percentage = 20;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 4 then
      circ1.r_load.percentage = 80;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 5 then
      circ1.r_load.percentage = 75;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 6 then
      circ1.r_load.percentage = 60;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 7 then
      circ1.r_load.percentage = 100;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 8 then
      circ1.r_load.percentage = 95;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 9 then
      circ1.r_load.percentage = 45;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 9 then
      circ1.r_load.percentage = 70;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 10 then
      circ1.r_load.percentage = 40;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 11 then
      circ1.r_load.percentage = 30;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 12 then
      circ1.r_load.percentage = 14;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 13 then
      circ1.r_load.percentage = 97;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 14 then
      circ1.r_load.percentage = 68;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 15 then
      circ1.r_load.percentage = 10;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 16 then
      circ1.r_load.percentage = 58;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 17 then
      circ1.r_load.percentage = 5;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 18 then
      circ1.r_load.percentage = 40;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 19 then
      circ1.r_load.percentage = 11;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 20 then
      circ1.r_load.percentage = 73;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 21 then
      circ1.r_load.percentage = 35;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 22 then
      circ1.r_load.percentage = 92;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 23 then
      circ1.r_load.percentage = 41;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 24 then
      circ1.r_load.percentage = 69;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 25 then
      circ1.r_load.percentage = 31;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 26 then
      circ1.r_load.percentage = 82;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 27 then
      circ1.r_load.percentage = 22;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 28 then
      circ1.r_load.percentage = 42;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 29 then
      circ1.r_load.percentage = 68;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 30 then
      circ1.r_load.percentage = 34;
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
      experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-06, Interval = 0.1));
  end Circuit_Scenario4;

  model Circuit_Scenario5
    Initial_Circuit circ1;
    Integer on;
  equation
//Target voltage and tolerance
    circ1.target_v = 70.0;
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
      circ1.r_load.percentage = 10;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 1 then
      circ1.r_load.percentage = 15;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 2 then
      circ1.r_load.percentage = 90;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 3 then
      circ1.r_load.percentage = 20;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 4 then
      circ1.r_load.percentage = 80;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 5 then
      circ1.r_load.percentage = 75;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 6 then
      circ1.r_load.percentage = 60;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 7 then
      circ1.r_load.percentage = 100;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 8 then
      circ1.r_load.percentage = 95;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 9 then
      circ1.r_load.percentage = 45;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 9 then
      circ1.r_load.percentage = 70;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 10 then
      circ1.r_load.percentage = 40;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 11 then
      circ1.r_load.percentage = 30;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 12 then
      circ1.r_load.percentage = 14;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 13 then
      circ1.r_load.percentage = 97;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 14 then
      circ1.r_load.percentage = 68;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 15 then
      circ1.r_load.percentage = 10;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 16 then
      circ1.r_load.percentage = 58;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 17 then
      circ1.r_load.percentage = 5;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 18 then
      circ1.r_load.percentage = 40;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 19 then
      circ1.r_load.percentage = 11;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 20 then
      circ1.r_load.percentage = 73;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 21 then
      circ1.r_load.percentage = 35;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 22 then
      circ1.r_load.percentage = 92;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 23 then
      circ1.r_load.percentage = 41;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 24 then
      circ1.r_load.percentage = 69;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 25 then
      circ1.r_load.percentage = 31;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 26 then
      circ1.r_load.percentage = 82;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 27 then
      circ1.r_load.percentage = 22;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 28 then
      circ1.r_load.percentage = 42;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 29 then
      circ1.r_load.percentage = 68;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 30 then
      circ1.r_load.percentage = 34;
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
      experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-06, Interval = 0.1));
  end Circuit_Scenario5;

  model Circuit_Scenario10
    Initial_Circuit circ1;
    Integer on;
  equation
//changing of percentages between multiple values, all elements good
//Target voltage and tolerance
    circ1.target_v = 70.0;
    circ1.tolerance = 0.9;
//initial states of batteries and switches
    circ1.bats[1].state = PhysicalFaultModeling.FaultType.ok;
    circ1.bats[2].state = PhysicalFaultModeling.FaultType.ok;
    circ1.bats[3].state = PhysicalFaultModeling.FaultType.ok;
    circ1.s[1].state = PhysicalFaultModeling.FaultType.ok;
  
    circ1.s[3].state = PhysicalFaultModeling.FaultType.ok;
    circ1.r_load.state = PhysicalFaultModeling.FaultType.ok;
//algorithm
    when initial() then
      circ1.r_load.percentage = 20;
      circ1.s[2].state = PhysicalFaultModeling.FaultType.ok;
      on = 1;
    elsewhen time > 0 then
      circ1.r_load.percentage = 20;
      circ1.s[2].state = PhysicalFaultModeling.FaultType.ok;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 1 then
      circ1.r_load.percentage = 20;
      circ1.s[2].state = PhysicalFaultModeling.FaultType.broken;
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
      experiment(StartTime = 0, StopTime = 2, Tolerance = 1e-06, Interval = 0.1));
  end Circuit_Scenario10;

  model Circuit_Scenario6
    Initial_Circuit circ1;
    Integer on;
  equation
//Target voltage and tolerance
    circ1.target_v = 60.0;
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
      circ1.r_load.percentage = 10;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 1 then
      circ1.r_load.percentage = 15;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 2 then
      circ1.r_load.percentage = 90;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 3 then
      circ1.r_load.percentage = 20;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 4 then
      circ1.r_load.percentage = 80;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 5 then
      circ1.r_load.percentage = 75;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 6 then
      circ1.r_load.percentage = 60;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 7 then
      circ1.r_load.percentage = 100;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 8 then
      circ1.r_load.percentage = 95;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 9 then
      circ1.r_load.percentage = 45;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 9 then
      circ1.r_load.percentage = 70;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 10 then
      circ1.r_load.percentage = 40;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 11 then
      circ1.r_load.percentage = 30;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 12 then
      circ1.r_load.percentage = 14;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 13 then
      circ1.r_load.percentage = 97;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 14 then
      circ1.r_load.percentage = 68;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 15 then
      circ1.r_load.percentage = 10;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 16 then
      circ1.r_load.percentage = 58;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 17 then
      circ1.r_load.percentage = 5;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 18 then
      circ1.r_load.percentage = 40;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 19 then
      circ1.r_load.percentage = 11;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 20 then
      circ1.r_load.percentage = 73;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 21 then
      circ1.r_load.percentage = 35;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 22 then
      circ1.r_load.percentage = 92;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 23 then
      circ1.r_load.percentage = 41;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 24 then
      circ1.r_load.percentage = 69;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 25 then
      circ1.r_load.percentage = 31;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 26 then
      circ1.r_load.percentage = 82;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 27 then
      circ1.r_load.percentage = 22;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 28 then
      circ1.r_load.percentage = 42;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 29 then
      circ1.r_load.percentage = 68;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 30 then
      circ1.r_load.percentage = 34;
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
      experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-06, Interval = 0.1));
  end Circuit_Scenario6;

  model Circuit_Scenario7
    Initial_Circuit circ1;
    Integer on;
  equation
//changing of percentages between multiple values, all elements good
//Target voltage and tolerance
    circ1.target_v = 50.0;
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
      circ1.r_load.percentage = 10;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 1 then
      circ1.r_load.percentage = 15;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 2 then
      circ1.r_load.percentage = 90;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 3 then
      circ1.r_load.percentage = 20;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 4 then
      circ1.r_load.percentage = 80;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 5 then
      circ1.r_load.percentage = 75;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 6 then
      circ1.r_load.percentage = 60;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 7 then
      circ1.r_load.percentage = 100;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 8 then
      circ1.r_load.percentage = 95;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 9 then
      circ1.r_load.percentage = 45;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 9 then
      circ1.r_load.percentage = 70;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 10 then
      circ1.r_load.percentage = 40;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 11 then
      circ1.r_load.percentage = 30;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 12 then
      circ1.r_load.percentage = 14;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 13 then
      circ1.r_load.percentage = 97;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 14 then
      circ1.r_load.percentage = 68;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 15 then
      circ1.r_load.percentage = 10;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 16 then
      circ1.r_load.percentage = 58;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 17 then
      circ1.r_load.percentage = 5;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 18 then
      circ1.r_load.percentage = 40;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 19 then
      circ1.r_load.percentage = 11;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 20 then
      circ1.r_load.percentage = 73;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 21 then
      circ1.r_load.percentage = 35;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 22 then
      circ1.r_load.percentage = 92;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 23 then
      circ1.r_load.percentage = 41;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 24 then
      circ1.r_load.percentage = 69;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 25 then
      circ1.r_load.percentage = 31;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 26 then
      circ1.r_load.percentage = 82;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 27 then
      circ1.r_load.percentage = 22;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 28 then
      circ1.r_load.percentage = 42;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 29 then
      circ1.r_load.percentage = 68;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 30 then
      circ1.r_load.percentage = 34;
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
      experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-06, Interval = 0.1));
  end Circuit_Scenario7;

  model Circuit_Scenario8
    Initial_Circuit circ1;
    Integer on;
  equation
//changing of percentages between multiple values, all elements good
//Target voltage and tolerance
    circ1.target_v = 40.0;
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
      circ1.r_load.percentage = 10;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 1 then
      circ1.r_load.percentage = 15;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 2 then
      circ1.r_load.percentage = 90;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 3 then
      circ1.r_load.percentage = 20;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 4 then
      circ1.r_load.percentage = 80;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 5 then
      circ1.r_load.percentage = 75;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 6 then
      circ1.r_load.percentage = 60;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 7 then
      circ1.r_load.percentage = 100;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 8 then
      circ1.r_load.percentage = 95;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 9 then
      circ1.r_load.percentage = 45;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 9 then
      circ1.r_load.percentage = 70;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 10 then
      circ1.r_load.percentage = 40;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 11 then
      circ1.r_load.percentage = 30;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 12 then
      circ1.r_load.percentage = 14;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 13 then
      circ1.r_load.percentage = 97;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 14 then
      circ1.r_load.percentage = 68;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 15 then
      circ1.r_load.percentage = 10;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 16 then
      circ1.r_load.percentage = 58;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 17 then
      circ1.r_load.percentage = 5;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 18 then
      circ1.r_load.percentage = 40;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 19 then
      circ1.r_load.percentage = 11;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 20 then
      circ1.r_load.percentage = 73;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 21 then
      circ1.r_load.percentage = 35;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 22 then
      circ1.r_load.percentage = 92;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 23 then
      circ1.r_load.percentage = 41;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 24 then
      circ1.r_load.percentage = 69;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 25 then
      circ1.r_load.percentage = 31;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 26 then
      circ1.r_load.percentage = 82;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 27 then
      circ1.r_load.percentage = 22;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 28 then
      circ1.r_load.percentage = 42;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 29 then
      circ1.r_load.percentage = 68;
      on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    elsewhen time > 30 then
      circ1.r_load.percentage = 34;
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
      experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-06, Interval = 0.1));
  end Circuit_Scenario8;

  model Circuit_Scenario9
    Initial_Circuit circ1;
    Integer on;
  equation
//Target voltage and tolerance
    circ1.target_v = 66.0;
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
      circ1.r_load.percentage = 20;
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
      experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-06, Interval = 0.1));
  end Circuit_Scenario9;

  model Circuit_Scenario11
    Initial_Circuit circ1;
    Integer on;
    // 1) Declare parameters or constants
    parameter Integer minR = 1 "Minimum resistance to test";
    parameter Integer maxR = 100 "Maximum resistance to test";
    parameter Real interval = 6 "Time [s] at each resistance";
    // Define a parameter for total simulation time so it’s a single numeric value:
    // parameter Real tStop = (maxR - minR + 1)*interval
    // "Total stop time computed from the range of resistances";
  equation
    circ1.target_v = 60.0;
    circ1.tolerance = 0.9;
//initial states of batteries and switches
    circ1.bats[1].state = PhysicalFaultModeling.FaultType.ok;
    circ1.bats[2].state = PhysicalFaultModeling.FaultType.ok;
    circ1.bats[3].state = PhysicalFaultModeling.FaultType.ok;
    circ1.s[1].state = PhysicalFaultModeling.FaultType.ok;
    circ1.s[2].state = PhysicalFaultModeling.FaultType.ok;
    circ1.s[3].state = PhysicalFaultModeling.FaultType.ok;
    circ1.r_load.state = PhysicalFaultModeling.FaultType.ok;
// (A) Define the load resistance over time in steps of 1 Ω
//circ1.r_load.r_int = minR + min(floor(time / interval), maxR - minR);
    circ1.r_load.percentage = minR + (maxR - minR)*min(floor(time/interval), 100)/100;
    on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
// (C) Switch control
    for i in 1:3 loop
      if i <= on then
        circ1.s[i].mode = PhysicalFaultModeling.OperationalMode.close;
      else
        circ1.s[i].mode = PhysicalFaultModeling.OperationalMode.open;
      end if;
    end for;
// Single annotation block
    annotation(
      experiment(StartTime = 0, StopTime = 606,  // use the parameter tStop here
      Tolerance = 1e-06, Interval = 0.1));
  end Circuit_Scenario11;

  model Circuit_ScenarioDataGeneration
    parameter Real stepTime = 6.0 "Seconds for each combination";
    parameter Integer maxVal = 100;
    Initial_Circuit circ1;
    Integer on;
    // N will store the 'step index' as a Real
    Real N "Incremented in steps of 1 every 'stepTime' seconds";
  equation
// 1) Define N = floor(time / stepTime)
//    This increments by 1 every 'stepTime' seconds
    N = floor(time/stepTime);
// 2) Use floor(...) and rem(...) to create 2D stepping:
//    - 'voltIndex' cycles from 0..99 in bigger time scales
//    - 'loadIndex' cycles from 0..99 more quickly
// 3) Map them into 1..100 with min(..., maxVal-1)
    circ1.target_v = 1 + min(floor(N/maxVal), maxVal - 1);
    circ1.r_load.r_int = 1 + min(rem(N, maxVal), maxVal - 1);
// If you use circ1.r_load.percentage instead of r_int, just replace:
//     circ1.r_load.percentage = 1 + min(rem(N, maxVal), maxVal -1);
// Tolerance and states
    circ1.tolerance = 0.9;
    circ1.bats[1].state = PhysicalFaultModeling.FaultType.ok;
    circ1.bats[2].state = PhysicalFaultModeling.FaultType.ok;
    circ1.bats[3].state = PhysicalFaultModeling.FaultType.ok;
    circ1.s[1].state = PhysicalFaultModeling.FaultType.ok;
    circ1.s[2].state = PhysicalFaultModeling.FaultType.ok;
    circ1.s[3].state = PhysicalFaultModeling.FaultType.ok;
    circ1.r_load.state = PhysicalFaultModeling.FaultType.ok;
// Switch control
    on = VoltageController(circ1.r_load.r_int, circ1.target_v, circ1.tolerance, circ1.bat_num, circ1.bats[1].vn, circ1.bats[1].r_int);
    for i in 1:3 loop
      if i <= on then
        circ1.s[i].mode = PhysicalFaultModeling.OperationalMode.close;
      else
        circ1.s[i].mode = PhysicalFaultModeling.OperationalMode.open;
      end if;
    end for;
    annotation(
      experiment(StartTime = 0, StopTime = 60000,  // e.g., 100*100*6 = 60000
      Tolerance = 1e-06, Interval = 1));
  end Circuit_ScenarioDataGeneration;
end Model_P3_Group_G;
