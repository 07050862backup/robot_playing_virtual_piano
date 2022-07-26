clear,clc,close all;
%% �w�q�Ѽ� ���`��+DH�Ѽ�
JOINT_SIZE = 4+1;
a = [7, 7, 7,7.5]'
alpha = [0, 0, 0,0]'*pi/180.0;
d = [0, 0, 0,0]';
cta = [0, 0, 0,0]'*pi/180.0;



%% �p�⥿�B�ʾ�
T{1} = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
P{1} = T{1}(1:3, 4);
R{1} = T{1}(1:3, 1:3);
for k=2:JOINT_SIZE
    T{k} = T{k-1}*DH(a(k-1), alpha(k-1), d(k-1), cta(k-1));
    P{k} = T{k}(1:3, 4);
    R{k} = T{k}(1:3, 1:3);
end



%% ���N�k�D�f��
target = [7; -5; -90*pi/180.0]; % �ؼ��I
PATH_SIZE = 20;
save_cta = zeros(4,PATH_SIZE);
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
   
    for k=2:JOINT_SIZE
        T{k} = T{k-1}*DH(a(k-1), alpha(k-1), d(k-1), cta(k-1));
        P{k} = T{k}(1:3, 4);
        R{k} = T{k}(1:3, 1:3);
    end
end     


degree1 = cta(1)*180/pi 
degree2 = cta(2)*180/pi 
degree3 = cta(3)*180/pi 
degree4 = cta(4)*180/pi 