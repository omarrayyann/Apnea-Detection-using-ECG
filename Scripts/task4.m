% Run Number
run = '4';
% Opening Required Files
% ECG File
binaryECGData = fopen(strcat('a0', run, '.dat'),'r');
ECGData = fread(binaryECGData, 'int16');
if (ECGData == -1) 
		error('oops, ecg data file can''t be read'); 
end
% Plotting
% Setting the time to plot the first 2 seconds only
timeToPlot = 0.5;
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

% Low Pass Filter
d = designfilt('lowpassfir', 'Filterorder', 5, 'CutoffFrequency', 12, 'SampleRate', frequency);
ECGData = filter(d, ECGData);

filteredSampled60Seconds = ECGData(1:60/period);
timeToPlot = 60;
Peaks = [];
% finding the time at which the peaks occur
for i=2:length(filteredSampled60Seconds)-1
   if (filteredSampled60Seconds(i)>1 && (filteredSampled60Seconds(i)>filteredSampled60Seconds(i+1)) && (filteredSampled60Seconds(i)>filteredSampled60Seconds(i-1)))
      Peaks = [Peaks, i];
   end
end
Peaks = Peaks/frequency;
Peaks = Peaks(2:end);
HRVV = [];
len = length(Peaks);
% finding the differences between successive peaks
for i = 2:len
 diff = Peaks(i) - Peaks(i-1);
    HeartRate = ((1/diff)*60)
    if HeartRate>150 || HeartRate < 0.5 
    HeartRate = 80
    end
   HRVV = [HeartRate, HRV];
   endrea
plot(period:period:timeToPlot, filteredSampled60Seconds(1:timeToPlot/period), 'Color', 'Black'); 
grid on;
fprintf('Avergae HRV Value: %f\n', mean(HRVV));
fprintf('Maximum HRV Value: %f\n', max(HRVV));
fprintf('Minimum HRV Value: %f\n', min(HRVV));


