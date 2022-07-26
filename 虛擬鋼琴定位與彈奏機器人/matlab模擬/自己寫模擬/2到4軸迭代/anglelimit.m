%%參考網址 https://blog.csdn.net/mobius_strip/article/details/53760068
clear,clc,close all;
%% 定義參數 關節數+DH參數
JOINT_SIZE = 4+1;
a = [7, 7, 7,7.5]'
alpha = [0, 0, 0,0]'*pi/180.0;
d = [0, 0, 0,0]';
cta = [0, 0, 0,0]'*pi/180.0;

%% 定義數組
T = cell(JOINT_SIZE);
R = cell(JOINT_SIZE);
P = cell(JOINT_SIZE);

%% 計算正運動學
T{1} = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
P{1} = T{1}(1:3, 4);
R{1} = T{1}(1:3, 1:3);
for k=2:JOINT_SIZE
    T{k} = T{k-1}*DH(a(k-1), alpha(k-1), d(k-1), cta(k-1));
    P{k} = T{k}(1:3, 4);
    R{k} = T{k}(1:3, 1:3);
end
% 繪圖
figure(1)
clf;
DrawCoordinate('0', P{1}, R{1});
for k=2:JOINT_SIZE
    DrawLine(P{k-1}, P{k});     
    DrawCylinder(P{k-1}, R{k-1});
    DrawCoordinate('0'+k-1, P{k}, R{k});
end
axis equal;   % 顯示坐標軸比例
view(0,90);   % 指定子圖一的視角

%% 迭代法求逆解
target = [8; -6; -90*pi/180.0]; % 目標點
PATH_SIZE = 20;
save_cta = zeros(3,PATH_SIZE);
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
    if cta(1)  < -92 * pi / 180.0
        cta(1) = -92 * pi / 180.0
    end
    if cta(1)  > 143 * pi / 180.0
        cta(1) = 143 * pi / 180.0
    end
    if cta(2)  < -92 * pi / 180.0
        cta(2) = -92 * pi / 180.0
    end
    if cta(2)  > 85 * pi / 180.0
        cta(2) = 85 * pi / 180.0
    end
    if cta(3)  < -92 * pi / 180.0
        cta(3) = -92 * pi / 180.0
    end
    if cta(3)  > 85 * pi / 180.0
        cta(3) = 85 * pi / 180.0
    end
    if cta(4)  < -92 * pi / 180.0
        cta(4) = -92 * pi / 180.0
    end
    if cta(4)  > 85 * pi / 180.0
        cta(4) = 85 * pi / 180.0
    end
    % DH法正解
    T{1} = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
    P{1} = T{1}(1:3, 4);
    R{1} = T{1}(1:3, 1:3);
    for k=2:JOINT_SIZE
        T{k} = T{k-1}*DH(a(k-1), alpha(k-1), d(k-1), cta(k-1));
        P{k} = T{k}(1:3, 4);
        R{k} = T{k}(1:3, 1:3);
    end
        
    % 數據更新
    P_tool = T{JOINT_SIZE}(1:3, 4);
    R_tool = T{JOINT_SIZE}(1:3, 1:3);
    
    % 繪圖
    figure(2)
    clf;
    DrawCoordinate('0', P{1}, R{1});
    for k=2:JOINT_SIZE
        DrawLine(P{k-1}, P{k});     
        DrawCylinder(P{k-1}, R{k-1});
        DrawCoordinate('0'+k-1, P{k}, R{k});
    end
    axis equal;   % 顯示坐標軸比例
    view(0,90);   % 指定子圖一的視角
    drawnow;
end

figure(3)
subplot(3, 2, 1);
plot(1:PATH_SIZE, save_cta(1,1:PATH_SIZE));
title('關節1位置(弧度)');
subplot(3, 2, 2);
plot(1:PATH_SIZE, save_cta(2,1:PATH_SIZE));
title('關節2位置(弧度)');
subplot(3, 2, 3);
plot(1:PATH_SIZE, save_cta(3,1:PATH_SIZE));
title('關節3位置(弧度)');
subplot(3, 2, 4);
plot(1:PATH_SIZE, save_cta(4,1:PATH_SIZE));
title('關節4位置(弧度)');

degree1 = cta(1)*180/pi 
degree2 = cta(2)*180/pi 
degree3 = cta(3)*180/pi 
degree4 = cta(4)*180/pi 