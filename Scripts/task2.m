% Run Number
run = '1';
% Opening Required Files
% ECG File
binaryECGData = fopen(strcat('a0', run, '.dat'),'r');
ECGData = fread(binaryECGData, 'int16');
if (ECGData == -1) 
		error('oops, ecg data file can''t be read'); 
end
%Plotting
% Setting the time to plot to only 4 hours
timeToPlot = 4*60*60;
% Setting the values from the header files
frequency = 100;
% Convertin to Voltage 
ECGData=ECGData*.1/20;
% Setting the period
period = 1/frequency;
t = period:period:timeToPlot;
t = t.';
% Setting the time to plot the first 2 seconds only
timeToPlot = 2;
plot(period:period:timeToPlot, ECGData(1:timeToPlot/period), 'Color', 'Black'); 
hold on
% Resampling data to 500 Hz
ECGData = resample(ECGData, 500, frequency);
frequency = 500;
period = 1/frequency;
t = period:period:timeToPlot;
% Plotting first 2 seconds after resampling
plot(period:period:timeToPlot, ECGData(1:timeToPlot/period), 'Color', 'Red'); 
grid on
title(strcat('a0', run));
xlabel('Time (seconds)');
ylabel('Amplitude (Volts)');
legend('100 Hz', '500 Hz resampled')