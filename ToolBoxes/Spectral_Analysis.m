
Fs_M = 1/3600; % sample rate
Fs_G = 1/1200; 
Fs_B = 1/300;
NFFT_M = length(y_M);               % number of FFT points
NFFT_G = length(y_G);
NFFT_B = length(y_B);
segmentLength_M = 2^8;       % segment length
segmentLength_G = 2^9;
segmentLength_B = 2^13;

[PM,F_M] = pwelch(y_M,ones(segmentLength_M,1),0,NFFT_M,Fs_M,'power'); 
PM = movmean(PM,3);

[PG,F_G] = pwelch(y_G,ones(segmentLength_G,1),0,NFFT_G,Fs_G,'power');
PG =movmean(PG,3);

[PB,F_B] = pwelch(y_B,ones(segmentLength_B,1),0,NFFT_B,Fs_B,'power'); 
PB = movmean(PB,3);

helperFrequencyAnalysisPlot2(F_M,F_G,F_B,10*log10(PM),10*log10(PG),10*log10(PB),...
  'Periods in Hours','Acceleration Power Spectrum in dB',{'MSEAS','GSR','BGR'},[0 100])
xlim([2 400])
ylim([-100 -30])
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')

title('2 mab water velocity spectral analysis')