clear,clc,close all;
%建立機器人模型
%       theta    d        a        alpha     offset
L1=Link([0      5         0       pi/2     0      ]); %定義連桿的D-H引數
L2=Link([0       0        7         0         0      ]);
L3=Link([0       0        7         0         0      ]);
L4=Link([0       0        7         0          0      ]);
L5=Link([0       0        7.5       0          0      ]);
robot=SerialLink([L1 L2 L3 L4 L5],'name','manman'); %連線連桿，機器人取名manman

T1=transl(21,0,0)%根據給定起始點，得到起始點位姿
%T1=transl(0.5,0,0)
%T2=transl(0,0.5,0);%根據給定終止點，得到終止點位姿
q1=robot.ikine(T1, 'mask', [1 1 1 0 0 1])
q1 = q1 * 180 /pi
%q2=robot.ikine(T2)%根據終止點位姿，得到終止點關節角


%q1 = q1 * 180 / pi
robot.teach;