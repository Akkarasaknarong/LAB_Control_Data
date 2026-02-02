%{  
This script for prepare data and parameters for parameter estimator.
1. Load your collected data to MATLAB workspace.
2. Run this script.
3. Follow parameter estimator instruction.
%}

% R and L from experiment
motor_R = 4.23;
motor_L = 0.04;
% Optimization's parameters
motor_Eff = 0.5;
motor_Ke = 0.05;
motor_J = 0.001;
motor_B = 0.0001;

% Extract collected data
% Input_DATA = load("C:\Users\Akkarasaknarong\Documents\GitHub\LAB_Control_Data\Data_for_Estimation\Sinewave\Sinewave_1Hz_Rec1.mat") ;

Input_Data = load("Sinewave_1Hz_Rec2.mat") ;

Input = squeeze(data{2}.Values.Data);
Time = squeeze(data{1}.Values.Time);
Velo = squeeze(double(data{1}.Values.Data));

% Plot 
figure(Name='Motor velocity response')
plot(Time,Velo,Time,Input)

