clear,clc,close all;
%�إ߾����H�ҫ�
%       theta    d        a        alpha     offset
L1=Link([0      5         0       pi/2     0      ]); %�w�q�s�쪺D-H�޼�
L2=Link([0       0        7         0         0      ]);
L3=Link([0       0        7         0         0      ]);
L4=Link([0       0        7         0          0      ]);
L5=Link([0       0        7.5       0          0      ]);
robot=SerialLink([L1 L2 L3 L4 L5],'name','manman'); %�s�u�s��A�����H���Wmanman

T1=transl(21,0,0)%�ھڵ��w�_�l�I�A�o��_�l�I�쫺
%T1=transl(0.5,0,0)
%T2=transl(0,0.5,0);%�ھڵ��w�פ��I�A�o��פ��I�쫺
q1=robot.ikine(T1, 'mask', [1 1 1 0 0 1])
q1 = q1 * 180 /pi
%q2=robot.ikine(T2)%�ھڲפ��I�쫺�A�o��פ��I���`��


%q1 = q1 * 180 / pi
robot.teach;