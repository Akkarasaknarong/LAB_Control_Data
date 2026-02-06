%{  
    Script for comparing Model vs Multiple Real Data (Rec1, Rec2, Rec3)
    1. Loads Model Data once.
    2. Loops through Real Data files.
    3. Aligns time, calculates RMS and R-Squared.
    4. Plots comparison.
%}

clear; clc; close all;

% ================= PARAMETERS =================
motor_R = 3.69;
motor_L = 0.04016;
motor_Eff = 0.972957;
motor_Ke = 0.050013;
motor_J = 0.0000110153333;
motor_B = 0.000025762333;

fileCount = 3 ;
RMSE_all     = zeros(fileCount,1);
NRMSE_all    = zeros(fileCount,1);
R2_all       = zeros(fileCount,1);
ACC_all      = zeros(fileCount,1);

%% ================= 1. LOAD MODEL (Reference) =================
% ไฟล์ที่เป็น Main Reference (Model)
modelFile = 'C:\Users\Akkarasaknarong\Documents\GitHub\LAB_Control_Data\Result_Validation\Versus\Sine_VS_Stair.mat';
f1 = load(modelFile);
d1 = f1.data;

% Extract Model Data
time1 = squeeze(d1{1}.Values.Time);
velo1 = squeeze(d1{1}.Values.Data);

% Check input for Model
if length(d1) >= 2
    input1 = squeeze(d1{2}.Values.Data);
else
    input1 = zeros(size(velo1));
end

fprintf('Model Loaded: %s\n', modelFile);

%% ================= 2. PREPARE LOOP FOR REAL FILES =================
% กำหนด Path ของไฟล์ Real Data
basePath = 'C:\Users\Akkarasaknarong\Documents\GitHub\LAB_Control_Data\Data_for_Estimation\Stair';
filePrefix = 'Stair_1Hz_Rec'; % ส่วนต้นของชื่อไฟล์
fileCount = 3; % จำนวนไฟล์ (Rec1, Rec2, Rec3)

% สร้าง Figure รอไว้
figure('Name', 'Model vs Real Data Comparison', 'Color', 'w');

%% ================= 3. START LOOP (Rec1 -> Rec3) =================
for i = 1:fileCount
    
    % --- 3.1 Load Real Data Dynamic ---
    fileName = sprintf('%s%d.mat', filePrefix, i); % สร้างชื่อไฟล์ เช่น ...Rec1.mat
    fullPath = fullfile(basePath, fileName);
    
    if ~isfile(fullPath)
        fprintf('\n[WARNING] File not found: %s \n', fileName);
        continue; % ข้ามรอบนี้ไปถ้าหาไฟล์ไม่เจอ
    end
    
    f2 = load(fullPath);
    d2 = f2.data;
    
    % Extract Real Data
    time2 = squeeze(d2{1}.Values.Time);
    velo2 = squeeze(d2{1}.Values.Data);
    
    % --- 3.2 Time Alignment (Interpolation) ---
    % หาช่วงเวลาที่ซ้อนทับกัน (Common Time)
    t_start = max(time1(1), time2(1));
    t_end   = min(time1(end), time2(end));
    
    % สร้างแกนเวลาใหม่ 5000 จุด
    t_common = linspace(t_start, t_end, 5000);
    
    % Interpolate ให้ข้อมูลทั้งสองชุดอยู่บนเวลาเดียวกัน
    velo1_i  = interp1(time1, velo1, t_common, 'linear'); % Model (Reference)
    velo2_i  = interp1(time2, velo2, t_common, 'linear'); % Real (Trend Line)
    
    % --- 3.3 Calculate RMS Error ---
    rms_velo = sqrt(mean((velo1_i - velo2_i).^2));
    nrms_velo = (rms_velo / max(abs(velo1_i))) * 100;
    
    % --- 3.4 Calculate R-Squared ---
    % ตามเงื่อนไข: Model (velo1_i) เป็น Reference, Real (velo2_i) เป็น Trend Line
    y_obs  = velo1_i;  % Reference (Model)
    y_pred = velo2_i;  % Trend Line (Real Data)
    
    SS_res = sum((y_obs - y_pred).^2);     % Residual Sum of Squares
    y_mean = mean(y_obs);
    SS_tot = sum((y_obs - y_mean).^2);     % Total Sum of Squares
    
    R_sq = 1 - (SS_res / SS_tot);
    
    RMSE_all(i)  = rms_velo;
    NRMSE_all(i)= nrms_velo;
    R2_all(i)   = R_sq;
    ACC_all(i)  = R_sq * 100;

    
    % --- 3.6 Plot Graph (Subplot) ---
    subplot(fileCount, 1, i);
    plot(t_common, velo1_i, 'b', 'LineWidth', 1.5); hold on;
    plot(t_common, velo2_i, 'r--', 'LineWidth', 1.2);
    title(['Comparison: Model vs ' fileName]);
    xlabel('Time (s)'); ylabel('Velocity');
    legend('Model (Reference)', ['Real (Rec' num2str(i) ')']);
    grid on;
    
end

fprintf('\nRMSE\n');
fprintf('%.6f\n', RMSE_all);

fprintf('\nNRMSE (%%)\n');
fprintf('%.2f\n', NRMSE_all);

fprintf('\nR-Squared\n');
fprintf('%.4f\n', R2_all);

fprintf('\nAccuracy\n');
fprintf('%.2f\n', ACC_all);


fprintf('\n=== ALL PROCESSES COMPLETED ===\n');