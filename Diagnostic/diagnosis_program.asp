
% --- Qualitative Voltage States ---
state(vmax). 
state((vmax,vmid)). 
state(vmid).
state((vmid,vlow)). 
state(vlow). 
state((vlow,null)). 
state(null).

% --- Increment (inc) Relations ---
inc(vmax, vmax).
inc((vmax,vmid), vmax).
inc(vmid, (vmax,vmid)).
inc((vmid,vlow), vmid).
inc(vlow, (vmid,vlow)).
inc((vlow,null), vlow).
inc(null, null).    % Or inc(null, (vlow,null)) based on design

% --- Decrement (dec) Relations ---
dec(vmax, (vmax,vmid)).
dec((vmax,vmid), vmid).
dec(vmid, (vmid,vlow)).
dec((vmid,vlow), vlow).
dec(vlow, (vlow,null)).
dec((vlow,null), null).
dec(null, null).

% --- Ordering Relations ---
less((vlow,null), null).
less(vlow, (vlow,null)).
less((vmid,vlow), vlow).
less(vmid, (vmid,vlow)).
less((vmax,vmid), vmid).
less(vmax, (vmax,vmid)).

% Transitive Closure for less/2
less(A,C) :- less(A,B), less(B,C).

% Greater Relation Defined via less
greater(X,Y) :- less(Y,X).

% --- Time Domain ---
time(0..5).  % Needs to be adjusted because it changes according to the data

% --- One Battery Voltage per Time Step ---
{ batteryVoltage(S,T) : state(S) } = 1 :- time(T).

% --- One Switch State per Battery per Time Step ---
{ switchState(B,S,T) : switch_state(S) } = 1 :- battery(B), time(T).

% Define switch states
switch_state(on).
switch_state(off).

% --- Fault Hypotheses ---
fault(battery1).
fault(battery2).
fault(battery3).
fault(switch1).
fault(switch2).
fault(switch3).

% Each fault can be either faulty or not
{ faulty(C) : fault(C) } <= 2.  % Limit to at most 2 simultaneous faults (adjust as needed)

% --- Stuck Switches ---
% If a switch is faulty and stuck on
stuck_on(switch1, T) :- faulty(switch1), switchState(switch1, on, T).
stuck_on(switch2, T) :- faulty(switch2), switchState(switch2, on, T).
stuck_on(switch3, T) :- faulty(switch3), switchState(switch3, on, T).

% If a switch is faulty and stuck off
stuck_off(switch1, T) :- faulty(switch1), switchState(switch1, off, T).
stuck_off(switch2, T) :- faulty(switch2), switchState(switch2, off, T).
stuck_off(switch3, T) :- faulty(switch3), switchState(switch3, off, T).

% --- Battery Connection Based on Switch States ---
% A battery is connected if its switch is on and not stuck off
batteryConnected(battery1, T) :- switchState(switch1, on, T), not stuck_off(switch1, T).
batteryConnected(battery2, T) :- switchState(switch2, on, T), not stuck_off(switch2, T).
batteryConnected(battery3, T) :- switchState(switch3, on, T), not stuck_off(switch3, T).

% A battery is disconnected if its switch is off and not stuck on
batteryDisconnected(battery1, T) :- switchState(switch1, off, T), not stuck_on(switch1, T).
batteryDisconnected(battery2, T) :- switchState(switch2, off, T), not stuck_on(switch2, T).
batteryDisconnected(battery3, T) :- switchState(switch3, off, T), not stuck_on(switch3, T).

% --- Any Battery Connected ---
anyBatteryConnected(T) :- batteryConnected(battery1, T).
anyBatteryConnected(T) :- batteryConnected(battery2, T).
anyBatteryConnected(T) :- batteryConnected(battery3, T).

% --- Constraint: If V_out < threshold, at least one battery should be connected ---
:- batteryVoltage(V, T), less(V, vlow), not anyBatteryConnected(T).

% --- Transition Rules based on Battery Connections ---
% Define expected transitions if no faults
% For simplicity, assume that if any battery is connected, V_out >= threshold

% Additional constraints can be added based on the specific behavior of your circuit


% Observed Data:
time(0).
batteryVoltage((vlow,null),0).
switchState(switch1,on,0).
switchState(switch2,on,0).
switchState(switch3,off,0).
time(1).
batteryVoltage((vlow,null),1).
switchState(switch1,on,1).
switchState(switch2,on,1).
switchState(switch3,off,1).
time(2).
batteryVoltage((vlow,null),2).
switchState(switch1,on,2).
switchState(switch2,on,2).
switchState(switch3,off,2).
time(3).
batteryVoltage((vlow,null),3).
switchState(switch1,on,3).
switchState(switch2,on,3).
switchState(switch3,off,3).
time(4).
batteryVoltage((vlow,null),4).
switchState(switch1,on,4).
switchState(switch2,on,4).
switchState(switch3,off,4).
time(5).
batteryVoltage((vlow,null),5).
switchState(switch1,on,5).
switchState(switch2,on,5).
switchState(switch3,off,5).
