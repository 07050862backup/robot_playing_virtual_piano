%% 计算DH矩阵 參數a, alpha, d, cta
function [ans] = DH(a, alpha, d, cta)
    ans = [
        cos(cta)  -sin(cta)*cos(alpha)   sin(cta)*sin(alpha)  a*cos(cta); 
        sin(cta)   cos(cta)*cos(alpha)  -cos(cta)*sin(alpha)  a*sin(cta); 
               0            sin(alpha)            cos(alpha)           d;
               0                     0                     0           1];
end