% 绘制直線 參數：起始點向量p，結束點向量q
function DrawLine(p, q)
    % 以(x, y, z)为原点(R)为方向绘制坐标系
    plot3([p(1) q(1)], [p(2) q(2)], [p(3) q(3)], 'LineWidth', 5);
    R = [1 0 0; 0 1 0; 0 0 1];
    hold on;
end
