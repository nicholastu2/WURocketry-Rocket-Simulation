%Constants:
m_total = 1.087; %total mass (slugs)
g = 32.17405; %accel due to gravity (ft/s^2)
W_total = 35; %total weight (lbs)
W_sec = (2/3)*(W_total); %weight of heaviest section
m_sec = (W_sec)/(32.174); %mass of heaviest section
p = 0.002376; %density of air

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










%Rocket Flight:


%Stability Margin:


%Center of Pressure:


%Center of Gravity:


%Kinetic Energy:


%Descent:


%Drift:
