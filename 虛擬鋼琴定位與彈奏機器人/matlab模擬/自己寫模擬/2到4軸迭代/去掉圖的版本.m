clear,clc,close all;
%% 定義參數 關節數+DH參數
JOINT_SIZE = 4+1;
a = [7, 7, 7,7.5]'
alpha = [0, 0, 0,0]'*pi/180.0;
d = [0, 0, 0,0]';
cta = [0, 0, 0,0]'*pi/180.0;



%% 計算正運動學
T{1} = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
P{1} = T{1}(1:3, 4);
R{1} = T{1}(1:3, 1:3);
for k=2:JOINT_SIZE
    T{k} = T{k-1}*DH(a(k-1), alpha(k-1), d(k-1), cta(k-1));
    P{k} = T{k}(1:3, 4);
    R{k} = T{k}(1:3, 1:3);
end



%% 迭代法求逆解
target = [7; -5; -90*pi/180.0]; % 目標點
PATH_SIZE = 20;
save_cta = zeros(4,PATH_SIZE);
for i=1:PATH_SIZE
    save_cta(1:4,i) = cta;
    % 誤差
    error = [target(1) - P{JOINT_SIZE}(1); target(2) - P{JOINT_SIZE}(2); target(3) - (cta(1)+cta(2)+cta(3)+cta(4))]
    % 雅克比，手動求偏導
    Jacob0 = [-a(4)*sin(cta(1)+cta(2)+cta(3)+cta(4))-a(2)*sin(cta(1)+cta(2))-a(1)*sin(cta(1))-a(3)*sin(cta(1)+cta(2)+cta(3))     -a(4)*sin(cta(1)+cta(2)+cta(3)+cta(4))-a(2)*sin(cta(1)+cta(2))-a(3)*sin(cta(1)+cta(2)+cta(3))     -a(4)*sin(cta(1)+cta(2)+cta(3)+cta(4))-a(3)*sin(cta(1)+cta(2)+cta(3))     -a(4)*sin(cta(1)+cta(2)+cta(3)+cta(4));    
               a(4)*cos(cta(1)+cta(2)+cta(3)+cta(4))+a(2)*cos(cta(1)+cta(2))+a(1)*cos(cta(1))+a(3)*cos(cta(1)+cta(2)+cta(3))      a(4)*cos(cta(1)+cta(2)+cta(3)+cta(4))+a(2)*cos(cta(1)+cta(2))+a(3)*sin(cta(1)+cta(2)+cta(3))      a(4)*cos(cta(1)+cta(2)+cta(3)+cta(4))+a(3)*cos(cta(1)+cta(2)+cta(3))      a(4)*cos(cta(1)+cta(2)+cta(3)+cta(4));                            
                                                                                                                          1                                                        1                               1 1]
    % 逆解迭代
    
    cta = cta + pinv(Jacob0)*error;
    
    % DH法正解
   
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