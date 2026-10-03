% 清理环境变量
clear; clc; close all;
%%画risk关于gamma和alignment的剖面图
% ==========================================
% 1. 设置系统参数
% ==========================================
r_squared = 2.33;       
sigma_squared = 1;   
M = 1;  % 常数 M
p = 200;  % 常数 p
sum_al=20; % spike和

% 定义网格范围
gamma1 = linspace(0.1, 0.99, 500);   
gamma2 = linspace(1.01, 10, 500);    
gamma_vec = [gamma1, NaN, gamma2]; 
A_vec = linspace(0.1,r_squared, 500); % A 代表 alignment程度,内积的平方

% ==========================================
% 2. 准备绘图窗口 (设置更宽的比例以容纳左右排版)
% ==========================================
%%%figure('Name', 'Risk Analysis Layout', 'Position', [100, 100, 1100, 650]);

% =======================================================
% 3. 左侧大图: 3D 曲面图 (占据 2x2 网格的第 1 和第 3 个位置)
% =======================================================
figure('Name', 'Risk Analysis Layout', ...
       'Position', [100, 100, 1100, 650]);

t = tiledlayout(2, 2, ...
    'TileSpacing', 'compact', ...
    'Padding', 'compact');

ax3d = nexttile([2, 1]);

[Gamma, A_grid] = meshgrid(gamma_vec, A_vec);
Z = NaN(size(Gamma)); 

% 计算 3D Z 值
mask1 = Gamma < 1;
Z(mask1) = sigma_squared * Gamma(mask1) ./ (1 - Gamma(mask1));
mask2 = Gamma > 1;
term1 = (sum_al - M) .* (1-1./Gamma(mask2)).^2 .* A_grid(mask2) ...
        + (1 - 1./Gamma(mask2)) .* r_squared;
term2 = (sigma_squared ./ (Gamma(mask2) - 1)) .* (sum_al/p + (p-M)/p);%方差项
Z(mask2) = term1 + term2;

% 画三维曲面
surf(Gamma, A_grid, Z, 'EdgeColor', 'none', 'FaceAlpha', 0.9);
colormap parula;
colorbar; 

% 3D 图美化
grid on;
xlabel('$\gamma$', 'Interpreter', 'latex', 'FontSize', 12);
hy = ylabel('$\left\langle\mathbf{u}_1,\mathbf{\beta}\right\rangle^2$', 'Interpreter', 'latex', 'FontSize', 14);
% 修改对齐方式，收缩默认的边框影响
hy.VerticalAlignment = 'bottom';
hy.HorizontalAlignment = 'right';
zlabel('Risk', 'FontSize', 12, 'FontWeight', 'bold');
title('(a) 3D Surface of Risk', 'FontSize', 14);
zlim([0, 30]); 
caxis([0, 30]); % 固定颜色映射区间，让高处变黄
view(ax3d, [-40, 25]);

% =======================================================
% 4. 右上小图: 固定 \gamma (假设对应 n=100)
% =======================================================
ax2 = nexttile(2);
% 假设 n=100 对应的 gamma 固定值为 2 (请根据你的实际推导修改)
gamma_fixed = 2; 


       
Z_slice1 = (sum_al - M) * (1-1/gamma_fixed)^2 * A_vec...
        + (1 - 1/gamma_fixed) * r_squared +...
       (sigma_squared / (gamma_fixed - 1)) * (sum_al/p + (p-M)/p);


plot(A_vec, Z_slice1, 'b-', 'LineWidth', 1.5);
grid on;
xlabel('$\left\langle\mathbf{u}_1,\mathbf{\beta}\right\rangle^2$', 'Interpreter', 'latex', 'FontSize', 11);
ylabel('Risk', 'FontSize', 11);
title(['(b) fixed $\gamma = ', num2str(gamma_fixed), '$ (e.g. $n=100$)'], 'Interpreter', 'latex', 'FontSize', 12);
ylim([0, 30]); % 根据需要调整 y 轴范围


% =======================================================
% 5. 右下小图: 固定夹角
% =======================================================
ax3 = nexttile(4);
A_fixed = 1;
Z_slice2 = NaN(size(gamma_vec));

% 分段计算关于 gamma_vec 的 2D 曲线
m1 = gamma_vec < 1;
Z_slice2(m1) = sigma_squared * gamma_vec(m1) ./ (1 - gamma_vec(m1));

m2 = gamma_vec > 1;
Z_slice2(m2) = (sum_al - M ) .* (1 - 1./gamma_vec(m2)) .^2 .*A_fixed +(1 - 1./gamma_vec(m2)) .*r_squared+ ...
               (sigma_squared ./ (gamma_vec(m2) - 1)) .* (sum_al/p + (p-M)/p);

plot(gamma_vec, Z_slice2, 'b-', 'LineWidth', 1.5);
hold on;
% 添加 gamma = 1 的奇点辅助虚线
xline(1, 'k:', 'LineWidth', 1); 
hold off;

grid on;
xlabel('$\gamma$', 'Interpreter', 'latex', 'FontSize', 11);
ylabel('Risk', 'FontSize', 11);
title(['(c) fixed $\left\langle\mathbf{u}_1,\mathbf{\beta}\right\rangle^2= ', num2str(A_fixed), '$'], 'Interpreter', 'latex', 'FontSize', 12);
ylim([0, 30]); % 根据需要调整 y 轴范围