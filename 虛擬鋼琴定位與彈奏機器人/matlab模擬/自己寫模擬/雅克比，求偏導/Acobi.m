% 參考資料 https://blog.csdn.net/weixin_42355349/article/details/82050451
clear,clc,close all;
syms alpha beta gamma A0 A1 A2 A3 A4 L1 L2 C1 C2 S1 S2 alpha_i alpha1 alpha2 alpha3 alpha4 theta1 theta2 theta3 theta4 theta5 theta6 theta_i Ai D1 D2 D3 D4 D5 D6 fun1 fun2 fun3 gun1 gun2 gun3;
syms   x y z d

%TAll = [cos(theta_i)                 -sin(theta_i)                      0          Ai ;
%        sin(theta_i)*cos(alpha_i)    cos(theta_i)*cos(alpha_i)   -sin(alpha_i)   -sin(alpha_i)*d;
%        sin(theta_i)*sin(alpha_i)    cos(theta_i)*sin(alpha_i)  cos(alpha_i)    cos(alpha_i)*d;
%      0 0 0 1]
TAll = [cos(theta_i)             -sin(theta_i)*cos(alpha_i)       sin(theta_i)*sin(alpha_i)          cos(theta_i)*Ai ;
        sin(theta_i)            cos(theta_i)*cos(alpha_i)         -cos(theta_i)*sin(alpha_i)         Ai*sin(theta_i);
        0            sin(alpha_i)            cos(alpha_i)               d;
         0 0 0 1]

T0_1 = subs(TAll, {theta_i, Ai,d,alpha_i}, {theta1 , A1 , 0 ,0})
T1_2 = subs(TAll, {theta_i, Ai,d,alpha_i}, {theta2 , A2 , 0,0 })
T2_3 = subs(TAll, {theta_i, Ai,d,alpha_i}, {theta3 , A3 , 0 ,0})
T3_4 = subs(TAll, {theta_i, Ai,d,alpha_i}, {theta4 , A4 , 0 ,0})
T0_2 = T0_1*T1_2;
T0_3 = T0_1*T1_2*T2_3;
T0_4 = T0_1*T1_2*T2_3*T3_4;


T0_0 = [1 0 0 0;0 1 0 0; 0 0 1 0; 0  0 0 1];

ox = T0_4(1,4); oy = T0_4(2,4);oz = T0_4(3,4);
w1 = T0_0(1:3,3);w2 = T0_1(1:3,3);w3 = T0_2(1:3,3);w4 = T0_3(1:3,3);
%Jw = [w1,w2,w3,w4,w5,w6];
J1_1 = diff(ox,theta1);J1_2 = diff(ox,theta2);J1_3 = diff(ox,theta3);J1_4 = diff(ox,theta4);
J2_1 = diff(oy,theta1);J2_2 = diff(oy,theta2);J2_3 = diff(oy,theta3);J2_4 = diff(oy,theta4);
J3_1 = diff(oz,theta1);J3_2 = diff(oz,theta2);J3_3 = diff(oz,theta3);J3_4 = diff(oz,theta4);

JT = [J1_1,J1_2,J1_3,J1_4;
      J2_1,J2_2,J2_3,J2_4;
      J3_1,J3_2,J3_3,J3_4;
       w1, w2, w3, w4];
simplify(JT)
