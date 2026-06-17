%% planar_spiral_inductance_and_field.m
clear; close all; clc;
mu0 = 4*pi*1e-7;
%% Adjustable coil parameters 
Nturns      = 8;          % number of turns
r_inner     = 5e-3;       % inner radius (m)
turn_spacing= 0.7e-3;     % radial spacing between adjacent turns (m)
wire_radius = 0.25e-3;    % conductor radius (m) 
points_per_turn = 360;    % resolution per turn 
I = 1.0;                  % current (A) for field plotting 
z_offset = 0;             % coil lies near z=0 plane 
%% =
% create spiral centerline 
theta = linspace(0, 2*pi*Nturns, Nturns*points_per_turn+1);
r = r_inner + (turn_spacing/(2*pi)) * theta;   % linear radial increase with theta
x = r .* cos(theta);
y = r .* sin(theta);
z = z_offset * ones(size(theta));  % planar

P1 = [x(1:end-1); y(1:end-1); z(1:end-1)]';
P2 = [x(2:end);   y(2:end);   z(2:end)]';
Nseg = size(P1,1);
% segment vectors and lengths
dL = P2 - P1;                
len = sqrt(sum(dL.^2,2));    % lengths
mid = (P1 + P2)/2;           % midpoints
fprintf('Segments: %d  | average segment length = %.3e m\n', Nseg, mean(len));

%%  Compute mutual inductance via discrete Neumann sum 
Lsum = 0;
mu_pref = mu0/(4*pi);
for i = 1:Nseg
    ri = mid(i,:);
    dli = dL(i,:);
    Rv = mid - ri;                  
    Rnorm = sqrt(sum(Rv.^2,2));      % distances
    Rnorm(i) = Inf;   
    dotdl = (dli * dL')';            
    contrib = dotdl ./ Rnorm;        % vector
    Lsum = Lsum + sum(contrib);
    % Lself_segment ≈ mu0 * length * (log(2*length/alpha) - 1)
    Li_self = mu0 * len(i) * (log(2*len(i)/wire_radius) - 1);
    Lsum = Lsum + (4*pi/mu0) * (Li_self);
end
Lsum_clean = 0;
for i = 1:Nseg
    ri = mid(i,:);
    dli = dL(i,:);
    for j = 1:Nseg
        if i==j
            continue;
        end
        rj = mid(j,:);
        dlj = dL(j,:);
        R = norm(ri - rj);
        Lsum_clean = Lsum_clean + (dli * dlj')/R;
    end
end
Lself_total = 0;
for i = 1:Nseg
    Lself_total = Lself_total + mu0 * len(i) * (log(2*len(i)/wire_radius) - 1);
end
L_total = mu_pref * Lsum_clean + Lself_total; 
fprintf('Estimated inductance (filament method): %.4f uH\n', L_total*1e6);

%%  Visualization: coil + field sampling (Biot-Savart)
figure('Color','w','Position',[100 100 900 600]);
subplot(1,2,1);
plot3(x,y,z,'-','LineWidth',1.5); hold on;
scatter3(mid(:,1), mid(:,2), mid(:,3), 8, 'filled');
axis equal; grid on;
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
title(sprintf('Planar Spiral: N=%d turns', Nturns));
% compute field on a XY plane slice at z = 0.5*turn_spacing 
subplot(1,2,2);
% grid for field sampling
Nx = 40; Ny = 40;
xv = linspace(-1.2*(r_inner+Nturns*turn_spacing), 1.2*(r_inner+Nturns*turn_spacing), Nx);
yv = linspace(-1.2*(r_inner+Nturns*turn_spacing), 1.2*(r_inner+Nturns*turn_spacing), Ny);
[XX,YY] = meshgrid(xv,yv);
ZZ = zeros(size(XX)) + 0.5*turn_spacing; % slice altitude
Bx = zeros(size(XX)); By = zeros(size(XX)); Bz = zeros(size(XX));
% Biot-Savart
for i = 1:Nseg
    r1 = P1(i,:);
    r2 = P2(i,:);
    dl = dL(i,:);
    % vectorized computation for all sample points
    Rx1 = XX - r1(1); Ry1 = YY - r1(2); Rz1 = ZZ - r1(3);
    Rx2 = XX - r2(1); Ry2 = YY - r2(2); Rz2 = ZZ - r2(3);
    r1vec = cat(3, Rx1, Ry1, Rz1);
    r2vec = cat(3, Rx2, Ry2, Rz2);
    % Biot-Savart for straight segment
    rmid = (r1 + r2)/2;
    Rm = cat(3, XX - rmid(1), YY - rmid(2), ZZ - rmid(3));
    Rm_norm = sqrt(Rm(:,:,1).^2 + Rm(:,:,2).^2 + Rm(:,:,3).^2) + 1e-12;
    % dl cross Rm
    dlxR = zeros(size(Rm));
    dlxR(:,:,1) = dl(2).*Rm(:,:,3) - dl(3).*Rm(:,:,2);
    dlxR(:,:,2) = dl(3).*Rm(:,:,1) - dl(1).*Rm(:,:,3);
    dlxR(:,:,3) = dl(1).*Rm(:,:,2) - dl(2).*Rm(:,:,1);
    Bx = Bx + (mu0/(4*pi)) * I * dlxR(:,:,1) ./ (Rm_norm.^3);
    By = By + (mu0/(4*pi)) * I * dlxR(:,:,2) ./ (Rm_norm.^3);
    Bz = Bz + (mu0/(4*pi)) * I * dlxR(:,:,3) ./ (Rm_norm.^3);
end
% plot vector field slice
skip = 2;
quiver(XX(1:skip:end,1:skip:end), YY(1:skip:end,1:skip:end), ...
       Bz(1:skip:end,1:skip:end), zeros(size(Bz(1:skip:end,1:skip:end))), 2.5);
axis equal; grid on;
xlabel('X (m)'); ylabel('Y (m)');
title(sprintf('B_z slice at z=%.3e m (arrows ~ B_z)', ZZ(1,1)));
% also show magnitude colormap
figure('Color','w');
imagesc(xv, yv, sqrt(Bx.^2 + By.^2 + Bz.^2));
axis xy equal; colorbar;
xlabel('X (m)'); ylabel('Y (m)');
title('|B| magnitude on slice');