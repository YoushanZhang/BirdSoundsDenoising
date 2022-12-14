%% This function converts an audio to an image
% First version: 12/14/2022 by Youshan Zhang (youshan.zhang@yu.edu).
% Zhang, Youshan, and Li, Jialu. (2023). BirdSoundsDenoising: Deep Visual Audio Denoising for Bird Sounds. 
% In 2023 IEEE Winter Applications of Computer Vision (WACV).
% Inputs:
    % y: audio signal
    % Fs: sample rate 
    % Wind: spectral window
    % olen: number of overlapped samples
    % nfft: number of DFT points
    % For example: wind = hamming(128); olen = 64; nfft = 1024;
% Output:
    % smag: converted audio image
    % s: complex values of STFT

function [smag, s] = audio2image(y,Fs,wind,olen,nfft)
% To hear, type sound(y,Fs)
% sound(y,Fs)
% figure,stft(y,Fs,'Window',wind,'OverlapLength',olen,'FFTLength',nfft)

s = stft(y,Fs,'Window',wind,'OverlapLength',olen,'FFTLength',nfft);
% Only return the real part as an image 
smag = abs(s);
end

