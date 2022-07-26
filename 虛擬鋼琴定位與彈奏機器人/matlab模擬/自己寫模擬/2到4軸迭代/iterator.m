%%�ѦҺ��} https://blog.csdn.net/mobius_strip/article/details/53760068
clear,clc,close all;
%% �w�q�Ѽ� ���`��+DH�Ѽ�
JOINT_SIZE = 4+1;
a = [7, 7, 7,7.5]'
alpha = [0, 0, 0,0]'*pi/180.0;
d = [0, 0, 0,0]';
cta = [0, 0, 0,0]'*pi/180.0;

%% �w�q�Ʋ�
T = cell(JOINT_SIZE);
R = cell(JOINT_SIZE);
P = cell(JOINT_SIZE);

%% �p�⥿�B�ʾ�
T{1} = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
P{1} = T{1}(1:3, 4);
R{1} = T{1}(1:3, 1:3);
for k=2:JOINT_SIZE
    T{k} = T{k-1}*DH(a(k-1), alpha(k-1), d(k-1), cta(k-1));
    P{k} = T{k}(1:3, 4);
    R{k} = T{k}(1:3, 1:3);
end
% ø��
figure(1)
clf;
DrawCoordinate('0', P{1}, R{1});
for k=2:JOINT_SIZE
    DrawLine(P{k-1}, P{k});     
    DrawCylinder(P{k-1}, R{k-1});
    DrawCoordinate('0'+k-1, P{k}, R{k});
end
axis equal;   % ��ܧ��жb���
view(0,90);   % ���w�l�Ϥ@������

%% ���N�k�D�f��
target = [8; 6; -90*pi/180.0]; % �ؼ��I
PATH_SIZE = 20;
save_cta = zeros(3,PATH_SIZE);
for i=1:PATH_SIZE
    save_cta(1:4,i) = cta;
    % �~�t
    error = [target(1) - P{JOINT_SIZE}(1); target(2) - P{JOINT_SIZE}(2); target(3) - (cta(1)+cta(2)+cta(3)+cta(4))]
    % ���J��A��ʨD����
    Jacob0 = [-a(4)*sin(cta(1)+cta(2)+cta(3)+cta(4))-a(2)*sin(cta(1)+cta(2))-a(1)*sin(cta(1))-a(3)*sin(cta(1)+cta(2)+cta(3))     -a(4)*sin(cta(1)+cta(2)+cta(3)+cta(4))-a(2)*sin(cta(1)+cta(2))-a(3)*sin(cta(1)+cta(2)+cta(3))     -a(4)*sin(cta(1)+cta(2)+cta(3)+cta(4))-a(3)*sin(cta(1)+cta(2)+cta(3))     -a(4)*sin(cta(1)+cta(2)+cta(3)+cta(4));    
               a(4)*cos(cta(1)+cta(2)+cta(3)+cta(4))+a(2)*cos(cta(1)+cta(2))+a(1)*cos(cta(1))+a(3)*cos(cta(1)+cta(2)+cta(3))      a(4)*cos(cta(1)+cta(2)+cta(3)+cta(4))+a(2)*cos(cta(1)+cta(2))+a(3)*sin(cta(1)+cta(2)+cta(3))      a(4)*cos(cta(1)+cta(2)+cta(3)+cta(4))+a(3)*cos(cta(1)+cta(2)+cta(3))      a(4)*cos(cta(1)+cta(2)+cta(3)+cta(4));                            
                                                                                                                          1                                                        1                               1 1]
    % �f�ѭ��N
    
    cta = cta + pinv(Jacob0)*error;
    
    % DH�k����
    T{1} = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
    P{1} = T{1}(1:3, 4);
    R{1} = T{1}(1:3, 1:3);
    for k=2:JOINT_SIZE
        T{k} = T{k-1}*DH(a(k-1), alpha(k-1), d(k-1), cta(k-1));
        P{k} = T{k}(1:3, 4);
        R{k} = T{k}(1:3, 1:3);
    end
        
    % �ƾڧ�s
    P_tool = T{JOINT_SIZE}(1:3, 4);
    R_tool = T{JOINT_SIZE}(1:3, 1:3);
    
    % ø��
    figure(2)
    clf;
    DrawCoordinate('0', P{1}, R{1});
    for k=2:JOINT_SIZE
        DrawLine(P{k-1}, P{k});     
        DrawCylinder(P{k-1}, R{k-1});
        DrawCoordinate('0'+k-1, P{k}, R{k});
    end
    axis equal;   % ��ܧ��жb���
    view(0,90);   % ���w�l�Ϥ@������
    drawnow;
end

figure(3)
subplot(3, 2, 1);
plot(1:PATH_SIZE, save_cta(1,1:PATH_SIZE));
title('���`1��m(����)');
subplot(3, 2, 2);
plot(1:PATH_SIZE, save_cta(2,1:PATH_SIZE));
title('���`2��m(����)');
subplot(3, 2, 3);
plot(1:PATH_SIZE, save_cta(3,1:PATH_SIZE));
title('���`3��m(����)');
subplot(3, 2, 4);
plot(1:PATH_SIZE, save_cta(4,1:PATH_SIZE));
title('���`4��m(����)');

degree1 = cta(1)*180/pi 
degree2 = cta(2)*180/pi 
degree3 = cta(3)*180/pi 
degree4 = cta(4)*180/pi 