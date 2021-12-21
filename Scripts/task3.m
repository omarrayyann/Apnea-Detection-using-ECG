% Run Number
run = '1';
% Opening Required Files
% ECG File
binaryECGData = fopen(strcat('a0', run, '.dat'),'r');
ECGData = fread(binaryECGData, 'int16');
if (ECGData == -1) 
		error('oops, ecg data file can''t be read'); 
end
% Plotting
% Setting the time to plot the first 2 seconds only
timeToPlot = 2;
% Setting the values from the header files
frequency = 100;
% Converting to Voltage 
ECGData=ECGData*.1/20;
% Setting the period
period = 1/frequency;
t = period:period:timeToPlot;
t = t.';
% Resampling data to 500 Hz
ECGData = resample(ECGData, 500, frequency);
frequency = 500;
period = 1/frequency;
t = period:period:timeToPlot;
% Plotting first 2 seconds after resampling
plot(period:period:timeToPlot, ECGData(1:timeToPlot/period), 'Color', 'Black'); 
hold on;
% Low Pass Filter
d = designfilt('lowpassfir', 'Filterorder', 5, 'CutoffFrequency', 12, 'SampleRate', frequency);
ECGData = filter(d, ECGData);
hold on;
plot(period:period:timeToPlot, ECGData(1:timeToPlot/period), 'Color', 'Red'); 
grid on
title(strcat('a0', run));
xlabel('Time (seconds)');
ylabel('Amplitude (Volts)');
legend({'unfiltered', 'filtered'});