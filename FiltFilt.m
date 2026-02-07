clear; clc; close all force; % ใช้ force เพื่อปิดหน้าต่างที่ค้างอยู่ให้หมด

% --- 1. Path & Files ---
folderPath = 'C:\Users\Akkarasaknarong\Documents\GitHub\LAB_Control_Data\Data_Difference_PWM_frequency';
files = {'Ramp_0.1_200Hz_rec3.mat', ...
         'Ramp_0.1_2000Hz_rec3.mat', ...
         'Ramp_0.1_20000Hz_rec3.mat'};
lineColors = {'r', 'g', 'b'}; 
legendNames = {'200 Hz', '2000 Hz', '20000 Hz'};

% สร้าง Figure และเก็บ Handle ไว้เช็คสถานะ
hFig = figure('Name', 'Comparison of 3 Records (Zero-Phase)', 'Color', 'w');
hold on;

% --- Parameters ---
cutoff_freq = 0.9;  
filter_order = 1;  

for i = 1:length(files)
    % Safety Check: ถ้าเผลอปิดหน้าต่างกลางคัน ให้หยุดทำงานทันที (กัน Error)
    if ~isvalid(hFig)
        disp('Graph window was closed. Stopping...');
        break;
    end

    fullPath = fullfile(folderPath, files{i});
    if ~isfile(fullPath), continue; end
    
    loaded = load(fullPath);
    
    if isfield(loaded, 'data')
        simData = loaded.data;
    elseif isfield(loaded, 'motor_data')
         simData = loaded.motor_data;
    else
        vars = fieldnames(loaded);
        simData = loaded.(vars{1});
    end
    
    t = simData{1}.Values.Time;
    y = simData{1}.Values.Data;
    
    % --- Zero-Phase Filtering ---
    dt = mean(diff(t)); 
    Fs = 1/dt; 
    Wn = cutoff_freq / (Fs/2);
    [b, a] = butter(filter_order, Wn, 'low');
    y_zerophase = filtfilt(b, a, y);
    
    plot(t, y_zerophase, 'Color', lineColors{i}, 'LineWidth', 2.0);
    
    % --- สำคัญมาก: บังคับอัปเดตกราฟิกทันที ---
    % ป้องกัน Error "SceneTree" โดยให้ MATLAB วาดให้เสร็จก่อนทำรอบต่อไป
    drawnow limitrate; 
end

if isvalid(hFig)
    title(['Comparison of PWM Frequencies (Cutoff: ' num2str(cutoff_freq) ' Hz)']);
    xlabel('Time (s)');
    ylabel('Angular velocity (rad/s)');
    legend(legendNames, 'Location', 'southeast');
    grid on;
    set(gca, 'GridColor', [0.5 0.5 0.5], 'GridAlpha', 0.5);
    hold off;
end