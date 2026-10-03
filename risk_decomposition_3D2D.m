% 清理环境变量
clear; clc; close all;

% ==========================================
% 1. 设置系统常数 (参数保持不变)
% ==========================================
r_squared = 2.33;       
sigma_squared = 1;   
M = 5;              
p = 200;              

% 统一设置颜色，方便对应
color_bias = [0.2 0.6 1];   % 蓝色
color_var  = [1 0.5 0.1];   % 橙色

% ==========================================
% 2. 初始化排版布局 (左侧大图，右侧两个小图)
% ==========================================
figure('Name', 'Risk Surface and Cross Sections', 'Position', [100, 100, 1100, 650]);
% 使用 tiledlayout 创建 2行2列 的网格
t = tiledlayout(2, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

% ==========================================
% 3. 绘制左侧主 3D 图 (占据左边两行)
% ==========================================
nexttile([2, 1]); % 跨越 2 行 1 列
hold on; grid on;

% 准备 3D 数据
gamma1_3d = linspace(0.1, 0.99, 80);   
gamma2_3d = linspace(1.01, 10, 80);    
gamma_vec_3d = [gamma1_3d, NaN, gamma2_3d]; 
A_vec_3d = linspace(5, 60, 80);
[Gamma_3d, A_grid_3d] = meshgrid(gamma_vec_3d, A_vec_3d);

Z_bias_3d = NaN(size(Gamma_3d));
Z_var_3d = NaN(size(Gamma_3d));

% gamma < 1 区域
mask1 = Gamma_3d < 1;
Z_var_3d(mask1) = sigma_squared * Gamma_3d(mask1) ./ (1 - Gamma_3d(mask1));
Z_bias_3d(mask1) = 0;

% gamma > 1 区域
mask2 = Gamma_3d > 1;
Z_bias_3d(mask2) = (A_grid_3d(mask2) - M) .* (1 - 1./Gamma_3d(mask2)).^2+(1 - 1./Gamma_3d(mask2)) * r_squared;
Z_var_3d(mask2) = (sigma_squared ./ (Gamma_3d(mask2) - 1)) .* (A_grid_3d(mask2)/p + (p-M)/p);

% 绘制 3D 曲面
surf(Gamma_3d, A_grid_3d, Z_bias_3d, 'FaceColor', color_bias, 'EdgeColor', 'none', 'FaceAlpha', 0.7, 'DisplayName', 'Out-of-sample bias');
surf(Gamma_3d, A_grid_3d, Z_var_3d, 'FaceColor', color_var, 'EdgeColor', 'none', 'FaceAlpha', 0.7, 'DisplayName', 'Out-of-sample variance');

% 3D 图美化
view([-40, 25]);
xlabel('\gamma', 'FontWeight', 'bold');
hy = ylabel('$$\sum_{i=1}^{M}\alpha_i$$', 'Interpreter', 'latex', 'FontSize', 14);
hy.VerticalAlignment = 'bottom';
hy.HorizontalAlignment = 'right';

zlabel('Risk', 'FontWeight', 'bold');
title('(a) Risk Surface', 'FontSize', 12);
zlim([0, 25]);
legend('Location', 'northeast');

% ==========================================
% 4. 绘制右上角 2D 剖面图 (固定 \gamma = 2)
% ==========================================
nexttile(2); % 占用第 2 个网格 (右上)
hold on; grid on;

gamma_fixed = 2;
A_line = linspace(5, 60, 200);

% 由于 gamma = 2 > 1，直接代入大于 1 的公式
bias_line1 = (A_line - M + 1) .* (1 - 1./gamma_fixed) * r_squared;
var_line1 = (sigma_squared ./ (gamma_fixed - 1)) .* (A_line/p + (p-M)/p);

plot(A_line, bias_line1, '-', 'Color', color_bias, 'LineWidth', 2, 'DisplayName', 'Out-of-sample bias');
plot(A_line, var_line1, '-', 'Color', color_var, 'LineWidth', 2, 'DisplayName', 'Out-of-sample variance');

% 2D 图 1 美化
xlabel('$\sum_{i=1}^{M}\alpha_i$', 'Interpreter', 'latex', 'FontSize', 14);
ylabel('Risk', 'FontWeight', 'bold');
title(['(b) fixed \gamma = ', num2str(gamma_fixed)], 'FontSize', 12);
ylim([0, 25]);
legend('Location', 'northwest', 'FontSize', 8);

% ==========================================
% 5. 绘制右下角 2D 剖面图 (固定 \Sigma \alpha_i = 30)
% ==========================================
nexttile(4); % 占用第 4 个网格 (右下)
hold on; grid on;

A_fixed = 30;
gamma1_line = linspace(0.1, 0.99, 500);
gamma2_line = linspace(1.01, 10, 500);
gamma_line = [gamma1_line, NaN, gamma2_line];

bias_line2 = NaN(size(gamma_line));
var_line2 = NaN(size(gamma_line));

% gamma < 1
idx1 = gamma_line < 1;
bias_line2(idx1) = 0;
var_line2(idx1) = sigma_squared * gamma_line(idx1) ./ (1 - gamma_line(idx1));

% gamma > 1
idx2 = gamma_line > 1;
bias_line2(idx2) = (A_fixed - M + 1) .* (1 - 1./gamma_line(idx2)) * r_squared;
var_line2(idx2) = (sigma_squared ./ (gamma_line(idx2) - 1)) .* (A_fixed/p + (p-M)/p);

plot(gamma_line, bias_line2, '-', 'Color', color_bias, 'LineWidth', 2, 'DisplayName', 'Out-of-sample bias');
plot(gamma_line, var_line2, '-', 'Color', color_var, 'LineWidth', 2, 'DisplayName', 'Out-of-sample variance');
xline(1, 'k:', 'LineWidth', 1.5, 'HandleVisibility', 'off'); % 渐近线

% 2D 图 2 美化
xlabel('\gamma', 'FontWeight', 'bold');
ylabel('Risk', 'FontWeight', 'bold');
title(['(c) fixed $$\sum_{i=1}^{M}\alpha_i = ', num2str(A_fixed), '$$'], 'Interpreter', 'latex', 'FontSize', 12);
ylim([0, 25]);
legend('Location', 'northeast', 'FontSize', 8);
% 整体框架调整完毕
hold off;