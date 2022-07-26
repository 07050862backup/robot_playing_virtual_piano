%% 计算DH矩阵 參數a, alpha, d, ct
function [ans] = MDH(a, alpha, d, cta)
    ans = [
                   cos(cta)             -sin(cta)            0              a; 
        sin(cta)*cos(alpha)   cos(cta)*cos(alpha)  -sin(alpha)  -sin(alpha)*d; 
        sin(cta)*sin(alpha)   cos(cta)*sin(alpha)   cos(alpha)   cos(alpha)*d;
                          0                     0            0             1];
end