%Constants:
t = 0;
m_total = 1.087; %total mass (slugs)
g = 32.17405; %accel due to gravity (ft/s^2)
W_total = 35; %total weight (lbs)
W_sec = (2/3)*(W_total); %weight of heaviest section
m_sec = (W_sec)/(32.174); %mass of heaviest section
p = 0.002376; %density of air at sea level
m_payload = 0.0226807; %mass of payload (slugs)
W_payload = 0.729729946234; %weight of payload (lbs)
launch_angle = 7.5;
diameter = 5.5;
length_nose = 10;
CP = 76;
numFins = 3;
CG = 64;
length_forward_section = 49.5;
length_mid_section = length_forward_section + 24;
length_aft_section = length_mid_section + 31.5;
m_avionics = 0.03558663858462;%slugs
W_nosecone = 2.875;
W_forward_section = W_payload + W_nosecone;
m_main_parachute = 0.04273634; %mass of main parachute in slugs
drogue_deployment_height = 5250;
main_deployment_height = 600;


%questions:
%   if the wind force i



%need to find:
%   W_forward_section = 
%       W_weighted_ballast + 
%       W_payload_deployment_mech
%   W_mid_section = 
%       W_top_avionics_bay + 
%       W_main_parachute
%   W_aft_section = 
%       W_drogue_parachute + 
%       W_top_avionics_bay + 
%       W_air_brake
W_fuel;
rate_fuel_consumption = W_fuel / 3.5;
C_d_air;
lift_force;

% will be calculated in script:
apogee;




%   Main Parachute Constants:
Cd_main = 2.2;
A_adj_main = 0.96;
r_main = 4.631; %min radius of main to achieve terminal velocity
D_main = 4;
A_main = 0.96*pi*(D_main/2)^2;

%   Drogue Parachute Constants:
Cd_drogue = 1.5;
A_adj_drogue = 0.96;
r_drogue = 0.807; %min radius of drogue to achieve main deployment velocity
D_drogue = 15/12;
A_drogue = 0.96*pi*(D_drogue/2)^2;

%   Terminal velocities:
v_t_drogue = sqrt((2*W_total)/(A_drogue*Cd_drogue*p));
v_t_main = sqrt((2*W_total)/(A_main*Cd_main*p));
v_t_both = sqrt((2*W_total)/(p*(A_drogue*Cd_drogue+A_main*Cd_main)));
%       Terminal velocities after payload release (probably won't need):
v_t_drogue_wo_load = sqrt((2*(W_total-W_payload))/(A_drogue*Cd_drogue*p));
v_t_main_wo_load = sqrt((2*(W_total-W_payload))/(A_main*Cd_main*p));
v_t_both_wo_load = sqrt((2*(W_total-W_payload))/(p*(A_drogue*Cd_drogue+A_main*Cd_main)));










%Rocket Flight (ascent):
F_g = m_total* g;
F_thrust;
F_thrust_average = 1300;
F_thrust_y = F_thrust_average * cos(launch_angle);
h_current = 0;
F_d_ascent;


%   first 3.5 seconds:
F_y = F_thrust_y - F_g;
a_y_current;
v_y_current = 0;
v_x_current = 0;
delta_t = 0.1;

% atmospheric pressure constant:
L = 0.0065;
T = 288.15 - L*h_current;
R = 0.730240507295273; %ideal gas constant
M = 53.35; %Molar mass of dry air


while t < 3.5 
    t = t + delta_t;
    m_total = m_total - (rate_fuel_consumption*(1/delta_t) * t);
    a_y_current = F_y / m_total;%m_total will change with time since fuel is being used up
    h_current = h_current + v_y_current*(delta_t) + (1/2)*(a_y_current)*(delta_t)^2;
    p_height = p*(1 - (L*h)/288.15)^((g*M)/(R*L));
    F_d_ascent = (1/2)*C_d_air*A_rocket*p_height*(a_y_current*t)^2;
    F_y = F_y - F_d_ascent;

    v_y_current = a_y_current * t;

    %may not need:
    KE_ascent = (1/2)*(m_total)*v_y_current;
    U_ascent = m_total*g*h_current;
    E_rocket = KE_ascent+U_ascent;
end


%after thrust is done;
F_y = ((-1)*F_g) - F_d_ascent;
a_y_current = F_y / m_total;

while v_y_current ~= 0
    t = t+delta_t;
    v_y_current = v_y_current + a_y_current * t;
end


%Stability Margin:
stability_margin = (CP - CG)/diameter;


%Center of Pressure:


%Center of Gravity:


%Kinetic Energy:

%   KE at landing:
KE_landing =(1/2)*((m_sec - m_payload)*(v_t_both^2));


%Descent:


%Drift:
