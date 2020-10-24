clear all;
%Constants:

g = 32.17405; %accel due to gravity (ft/s^2)
W_total = 43.19; %total weight (wet) (lbs)
m_total = W_total / g; %total mass (slugs)
W_sec = (2/3)*(W_total); %weight of heaviest section
m_sec = (W_sec)/(32.174); %mass of heaviest section
air_density = 0.002376; %density of air at sea level
m_payload = 0.0226807; %mass of payload (slugs)
W_payload = 0.729729946234; %weight of payload (lbs)
launch_angle = 7.5;
diameter = 5.5; %diameter of rocket
length_nose = 10;
CP_open_rocket = 76;

CG_open_rocket = 64;
length_forward_section = 49.5;
length_mid_section = length_forward_section + 24;
length_aft_section = length_mid_section + 31.5;
m_avionics = 0.03558663858462;%slugs
W_nosecone = 2.875;
W_forward_section = W_payload + W_nosecone;
m_main_parachute = 0.04273634; %mass of main parachute in slugs
drogue_deployment_height = 5250;
main_deployment_height = 600;
C_d_rocket = 0.75;
air_temp = 295.55; %air temperature in kelvins
N_fins = 3; %number of fins
KE_rule = 75; %ASK: why is this a rule?


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
W_fuel = 5.52; %weight of propellant in lbs
m_fuel = W_fuel / 32.174;
rate_fuel_consumption = m_fuel / 3.5;
m_dry = m_total - m_fuel;
W_dry = W_total - W_fuel;

% will be calculated in script:




%   Main Parachute Constants:
Cd_main = 2.2;
A_adj_main = 0.96;
r_main = 4.631; %min radius of main to achieve terminal velocity
D_main = 12;
A_main = 0.96*pi*(D_main/2)^2;

%   Drogue Parachute Constants:
Cd_drogue = 1.5;
A_adj_drogue = 0.96;
r_drogue = 0.807; %min radius of drogue to achieve main deployment velocity
D_drogue = 18/12;
A_drogue = 0.96*pi*(D_drogue/2)^2;

%   Terminal velocities:
v_t_drogue = sqrt((2*W_sec)/(A_drogue*Cd_drogue*air_density));
v_t_main = sqrt((2*W_sec)/(A_main*Cd_main*air_density));
v_t_both = sqrt((2*W_sec)/(air_density*(A_drogue*Cd_drogue+A_main*Cd_main)));
%       Terminal velocities after payload release (probably won't need):
v_t_drogue_wo_load = sqrt((2*(W_total-W_payload))/(A_drogue*Cd_drogue*air_density));
v_t_main_wo_load = sqrt((2*(W_total-W_payload))/(A_main*Cd_main*air_density));
v_t_both_wo_load = sqrt((2*(W_total-W_payload))/(air_density*(A_drogue*Cd_drogue+A_main*Cd_main)));










%Rocket Flight (ascent):
F_g_current = m_total* g;
F_thrust_average = 293.3419504;%average thrust force in lbf
F_thrust_y = F_thrust_average * cosd(launch_angle);
h_current = 600;
A_rocket = 0.96*pi*(diameter / 2)^2;%affective area of rocket
v_y_current = 0;
t = 0;
F_d_ascent = 0;
h_above_ground = 0;
v_y_initial = 0;


%   first 3.5 seconds:
F_y = F_thrust_y - F_g_current;
a_y_current = F_y / m_total;
v_x_current = 0;
delta_t = 0.1;

% atmospheric pressure constant:
L_b = 0.0065;
P_b = 29.21; %reference pressure of huntsville in inHg
T_b = 290.928; %reference temperature of huntsville in kelvin
R_universal = 8.9494596*10^4; %universal gas constant
h_b = 600; %elevation of huntsville, AL in feet
M_earth = 28.9644; %molar mass of earth's air\

air_pressure_height = P_b*(T_b/(T_b+L_b*(h_current-h_b)))^((g*M_earth)/(R_universal*L_b));





%% 
%simulates the flight with thrust
while t < 3.5 
    t = t + delta_t;
    m_total = m_total - (rate_fuel_consumption * (delta_t));
    F_g_current = m_total * g;

    
    air_pressure_height = P_b*(T_b/(T_b+L_b*(h_current-h_b)))^((g*M_earth)/(R_universal*L_b));
    air_density = air_pressure_height/(53.35*T_b);
%     F_d_ascent = (1/2)*C_d_rocket*A_rocket*air_density*(v_y_current)^2; %may need to change
%     F_d_ascent_y = F_d_ascent * cosd(launch_angle);
    F_y = F_thrust_y - (m_total*g);% - F_d_ascent_y;
    a_y_current = F_y / m_total;%m_total will change with time since fuel is being used up
    
    h_current = h_current + v_y_current*(delta_t) + (1/2)*(a_y_current)*(delta_t)^2;
    h_above_ground = h_current - h_b;



    v_y_current = v_y_current + a_y_current * delta_t;
%     if t == 0.1
%         v_y_initial = v_y_current;
%     end
    %may not need:
    KE_ascent = (1/2)*(m_total)*v_y_current;
    U_ascent = m_total*g*h_current;
    E_rocket = KE_ascent+U_ascent;
end
% v_y_initial = v_y_current;

%after thrust is done;
F_y_after_thrust = ((-1)*(m_total*g)) - F_d_ascent;
a_y_after_thrust = F_y_after_thrust / m_total;
W_dry = m_total * g;
v_terminal_rocket = sqrt(2*W_dry/(C_d_rocket*A_rocket*air_density));
%% 

while v_y_current >= 0
    t = t+delta_t;
%     v_y_current = v_terminal_rocket*((v_y_initial-v_terminal_rocket*tand(t*g/v_terminal_rocket))/(v_terminal_rocket+v_y_initial*tand(t*g/v_terminal_rocket)));
%     h_current = ((v_terminal_rocket^2)/(2*g))*log((v_y_initial^2+v_terminal_rocket^2)/(v_y_current^2+v_terminal_rocket^2));
    air_pressure_height = P_b*(T_b/(T_b+L_b*(h_current-h_b)))^((g*M_earth)/(R_universal*L_b));
    air_density = air_pressure_height/(53.35*T_b);
    F_d_ascent = (1/2)*C_d_rocket*A_rocket*air_density*(v_terminal_rocket)^2; %may need to change
    F_d_ascent_y = F_d_ascent * cosd(launch_angle);
    F_y_after_thrust = ((-1)*(m_total*g)) - F_d_ascent_y;
    a_y_after_thrust = F_y_after_thrust / m_total;
    v_y_current = v_y_current + a_y_after_thrust * delta_t;
    h_current = h_current + v_y_current*delta_t;
end

apogee = h_current - h_b;


%Stability Margin:
original_stability_margin = (CP_open_rocket - CG_open_rocket)/diameter;


%Center of Pressure:
numFins = 3;
L_N = 10; %length of nose in inches
d_base_nose = 5.525; %diameter at base of nose in inches
C_R = 8; %fin root chord
C_T = 4; %fin tip chord
fin_height = 5.5;
fin_mid_chord = 2.5; 
X_R = 2.5; %distance between fin root leading edge and fin tip leading edge parallel to body
X_B = 87.936; %distance from nose tip to fin root chord leading edge
R_body = diameter / 2;
C_N_N = 2; %whatever this constant is
X_N = 0.466*L_N; %whatever this constant is for Ogive noses
C_N_F = (1+(R_body/(R_body + fin_height)))*((4*numFins*(fin_height/diameter)^2)/(1+sqrt(1+(2*fin_mid_chord)/((C_R+C_T)^2))));
X_F = X_B + (X_R / 3)*((C_R+2*C_T)/(C_R+C_T)) + (1/6)*((C_R + C_T)-((C_R*C_T)/(C_R+C_T)));
C_N_R = C_N_N + C_N_F;
CP_from_nose_tip = ((C_N_N*X_N) + (C_N_F*X_F))/C_N_R;

new_stability_margin = (CP_from_nose_tip - CG_open_rocket)/diameter;


%Center of Gravity:


%Kinetic Energy:

%   KE at landing:
KE_landing =(1/2)*((m_sec - m_payload)*(v_t_both^2));


%Descent:
F_d_descent = W_sec;
h_main_deployment = 600;
h_drogue = apogee - h_main_deployment; %height the rocket falls with only drogue deployed
t_fallen_drogue = h_drogue / v_t_drogue;

t_fallen_both = h_main_deployment / v_t_both;

t_fallen_total = t_fallen_drogue + t_fallen_both;




%Drift:

%   5mph:
v_wind_5mph = 7.33333; %v of wind at 5mph in ft/s
dist_drift_5mph = t_fallen_total * v_wind_5mph; %distance the rocket drifts when wind is 5mph in feet

%   10mph
v_wind_10mph = 14.6667; %v of wind at 10mph in ft/s
dist_drift_10mph = t_fallen_total * v_wind_10mph; %distance the rocket drifts when wind is 10mph in feet

%   15mph
v_wind_15mph = 22; %v of wind at 15mph in ft/s
dist_drift_15mph = t_fallen_total * v_wind_15mph; %distance the rocket drifts when wind is 15mph in feet

%   20mph
v_wind_20mph = 22; %v of wind at 20mph in ft/s
dist_drift_20mph = t_fallen_total * v_wind_20mph; %distance the rocket drifts when wind is 20mph in feet