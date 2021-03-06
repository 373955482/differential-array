%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% test first-order DMA
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% close all
% clear all;
%addpath(genpath('lib'));
c = 340; % speed of sound

%%
%% load recorded office noise audio

fs = 16000;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 
x = loadwav('../wav/4mic_r0.005/target_2mic_ganrao_90/');
d = 0.005*2;
% x = loadwav('wav/xmos/meetingroom_2/');
% d = 0.064;

x = loadpcm('E:\\work\\kws\\lanso\\录音\\录音1\\');
x = x(:,[1,2,3]);
d = 0.05;

%% process
% x = pcmread('../wav/STEREO_0024.pcm',2)';
% d = 0.025;
y = DMA2( x,d);

%% evaluate
%speech = sig.speech;
% [pesq_mos]= pesq_vec(speech, out,fs)
%rmpath(genpath('lib'));
visual( x(:,1),y);
% util.fig(out, fs);


