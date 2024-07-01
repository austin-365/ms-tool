% This code illustrate how to compute and plot the modulation spectrum.
% The input audio is segmented into 6-second chunks and the modulation
% spectrum is calculated for each chunk and averaged.
% author: Nai Ding, ding_nai@zju.edu.cn

% Reference: 
% Temporal Modulations Reveal Distinct Rhythmic Properties of Speech and Music
% Nai Ding, Aniruddh Patel, Lin Chen, Henry Butler, Cheng Luo, David Poeppel
% bioRxiv 059683; doi: http://dx.doi.org/10.1101/059683


clear;clc
% specify the name of the audio file to analyze
filename='long-audio.wav';

% get the sampling rate, fs
[dum,fs]=wavread(filename,1);
% load 6-seconds duration non-overlapping chunks of the audio file
for ind=1:1000
  % load a 6-seconds duration chunk
  try  [x,fs]=wavread(filename,[fs*6*(ind-1)+1 fs*6*ind]);catch,break;end
  disp(['...' ' processing chunk ' num2str(ind)])
  % resample the recordign to 16 k Hz
  x=resample(x,16e3,fs);
  % generate the auditory spectrogram
  [v,cf]=wav2aud2(x,[5 8 -2 0]);
  % compute the narrow-band modulation spectrum
  [ms(:,ind),f]=Modulation_Spectrum(v,200,'log');
end
disp(['The analyzed audio file is segmented into ' num2str(ind) ' chunks.'])

% calculate the root-mean-square of the modulation spectrum
% across all the 6-second duration chunks
ms_rms=sqrt(mean(ms.^2,2));
ms_rms=ms_rms/max(ms_rms([f<32 & f>=.5]));
% plot the modulation spectrum averaged over chunks
figure;
plot(f(1:size(ms,1)),ms_rms)
xlim([.5 32]);
set(gca,'xscale','log')
set(gca,'xtick',[.5 1 2 4 8 16 32])
xlabel('frequency (Hz)')
ylabel('normalized amplitude')