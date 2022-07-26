clear;clc;close all;

syms a A d t
SIN=sin(t);
COS=cos(t);
TAll = [COS           -SIN*cos(a)        SIN*sin(a)          COS*A ;
        SIN           COS*cos(a)         -COS*sin(a)         A*SIN;
        0            sin(a)            cos(a)               d;
         0 0 0 1]
%subs(TAll, {A, D}, {sym('alpha'), 2})
%TAll = [COS           -SIN       0         A ;
%        SIN*cos(a)           COS*cos(a)         -sin(a)        -sin(a)*d;
%        SIN*sin(a)           COS*sin(a)         cos(a)        cos(a)*d;
%      0 0 0 1]
T0_1 = subs(TAll, {a, A,d,t}, {pi/2,  0, 5 ,{sym('t1')}} )
T1_2 = subs(TAll, {a, A,d,t}, {0,  7, 0 ,{sym('t2')}} )
T2_3 = subs(TAll, {a, A,d,t}, {0,  7, 0 ,{sym('t3')}} )
T3_4 = subs(TAll, {a, A,d,t}, {0,  7, 0 ,{sym('t4')}} )
T4_5 = subs(TAll, {a, A,d,t}, {0,  7.5, 0 ,{sym('t5')}} )
T0_5 = T0_1*T1_2*T2_3*T3_4*T4_5

t1 = 33*pi/180;
t2 = 51*pi/180;
t3 = -38*pi/180;
t4 = 0*pi/180;
t5 = -102*pi/180;
T0_1=double(subs(T0_1))
T1_2=double(subs(T1_2))
T2_3=double(subs(T2_3))
T3_4=double(subs(T3_4))
T4_5=double(subs(T4_5))
T0_5=double(subs(T0_5))


px=15;
py=15;
pz=10;

B0_5 =  px^2 + py^2;
Q0_5 = atan(py/px)^2;


