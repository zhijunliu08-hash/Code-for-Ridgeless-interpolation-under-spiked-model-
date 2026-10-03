% 清理环境变量
clear; clc; close all;

% 1. 设置参数
r_squared_values = [1, 2.33, 3.66, 5]; 
sigma_squared = 1;
M=5; p=300;
sum_al=50;

% 2. 定义自变量 gamma 的取值范围，避开奇点 gamma = 1
gamma1 = linspace(0.1, 0.99, 500);   
gamma2 = linspace(1.01, 5, 500);    
gamma = [gamma1, NaN, gamma2];

% 创建图像并保持绘制状态
figure('Name', 'Risk vs \gamma', 'Position', [100, 100, 700, 500]);
hold on;
grid on;

% 设置颜色数组
colors = ['y', 'b', 'g', 'm']; 

% 3. 循环计算并绘制不同 r^2 下的图像及对应颜色的参考线
for i = 1:length(r_squared_values)
    r2 = r_squared_values(i);
    
    % 当 gamma < 1 时
    y1 = sigma_squared * gamma1 ./ (1 - gamma1);
    
    % 当 gamma > 1 时
    y2 = (sum_al-M)*(1-1./gamma2).^2*0+(1 - 1./gamma2) * r2 +sigma_squared * 1./(gamma2 - 1)*(sum_al/p+(p-M)/p);
    
    % 合并数据点，中间用 NaN 隔断
    y = [y1, NaN, y2];
    
    % 绘制当前 r^2 的主曲线
    plot(gamma, y, 'Color', colors(i), 'LineWidth', 2, 'DisplayName', ['SNR = ', num2str(r2)]);
    
    % 【修改点】：在循环内画出对应高度和颜色的水平虚线
    % 使用 colors(i) 确保虚线颜色和实线颜色完全一致
    yline(r2, '--', 'Color', colors(i), 'LineWidth', 1.2, 'HandleVisibility', 'off');
end

% 4. 图像美化与标注
xlabel('\gamma', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('risk', 'FontSize', 12, 'FontWeight', 'bold');
title('Risk vs \gamma for Different r^2', 'FontSize', 14);
ylim([-1, 15]); 

% 5. 基础公共参考线
yline(0, 'k--', 'LineWidth', 1, 'HandleVisibility', 'off'); % y=0 的黑色基准线
xline(1, 'r:', 'LineWidth', 1.5, 'DisplayName', 'Asymptote \gamma=1'); % gamma=1 渐近线



% 开启图例
legend('Location', 'best');
hold off;