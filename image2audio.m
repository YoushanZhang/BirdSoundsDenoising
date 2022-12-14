%% This function converts a denoised image to denoised audio
% First version: 12/14/2022 by Youshan Zhang (youshan.zhang@yu.edu).
% Zhang, Youshan, and Li, Jialu. (2023). BirdSoundsDenoising: Deep Visual Audio Denoising for Bird Sounds. 
% In 2023 IEEE Winter Applications of Computer Vision (WACV).
% Inputs:
    % s: STFT complex values
    % mask: mask image of clean areas (can come from segmentation model)
    % Fs: sample rate 
    % Wind: spectral window
    % olen: number of overlapped samples
    % nfft: number of DFT points
    % For example: wind = hamming(128); olen = 64; nfft = 1024;
% Output:
    % reconstructed denoised audio

function x = image2audio(s,mask,Fs,wind,olen,nfft)
% make sure the mask size is equal to noise image size
if size(s,1)~=size(mask,1) || size(s,2)~=size(mask,2) 
    mask = imresize(mask,[size(s,1),size(s,2)]);
end
s(mask<1)=0; % Remove noise areas
[ix2,~] = istft(s,Fs,'Window',wind,'OverlapLength',olen,'FFTLength',nfft);
x = real(ix2); % Return the reconstructed denoised audio
% sound(x,Fs)
end
