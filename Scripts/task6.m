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

% Low Pass Filter
d = designfilt('lowpassfir', 'Filterorder', 5, 'CutoffFrequency', 12, 'SampleRate', frequency);
ECGData = filter(d, ECGData);

Average = [];
Minimum = [];
Maximum = [];

for y=1:240
    

filteredSampled60Seconds = ECGData((60*y-59)/period:y*60/period);
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
HR = [];
len = length(Peaks);
% finding the differences between successive peaks
for i = 2:len
 diff = Peaks(i) - Peaks(i-1);
 % check for outleirs
    if ((1/diff)*60)>150 || ((1/diff)*60) < 0.5
   HR = [80, HR];
    else
   HR = [((1/diff)*60), HR];
    end
end
Average(end+1) = mean(HR);
Minimum(end+1) = min(HR);
Maximum(end+1) = max(HR);

end


binaryECGData = fopen(strcat('a0', run, '.dat'),'r');
x = fread(binaryECGData, 'int16');
x=x*.1/20;
resampled = resample(x,4,100);
resampled = resampled(1:240);
fast = fft(resampled);
y = (1/(960))* abs(fast).^2;
y=y(1:120);
freq = 1/240:4/240:2;
plot(freq(1:120), y(1:120));
grid on;
title('Power Density');
xlabel('Time (Hours)')
ylabel('Power')





