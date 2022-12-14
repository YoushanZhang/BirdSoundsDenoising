%% This is an exmaple to convert audio to image and convert the denoised image to audio
% First version: 12/14/2022 by Youshan Zhang (youshan.zhang@yu.edu).
% Zhang, Youshan, and Li, Jialu. (2023). BirdSoundsDenoising: Deep Visual Audio Denoising for Bird Sounds. 
% In 2023 IEEE Winter Applications of Computer Vision (WACV).

% Read the aduio
[y,Fs] = audioread('./Audio_example/XC41136.wav');
% To hear, type sound(y,Fs)
sound(y,Fs)
wind = hamming(128);
olen = 64;
nfft = 1024;

%% Convert auduo to image
[noise_img, s] = audio2image(y,Fs,wind,olen,nfft);
figure, imshow(noise_img)
title('Noise audio image')
% imwrite(noise_img, './Audio_example/XC41126_left.png')

%% Convert denoised image to denoised audio
% clean mask image, can come from the predictions of segmentation model
mask = imread('./Audio_example/XC41136_mask.png'); 

figure, imshow(labeloverlay(noise_img,mask))
title('Overlay of noise and mask image')
x = image2audio(s, mask,Fs,wind,olen,nfft);
pause(5)
% Play the denoised audio
sound(x, Fs)
% audiowrite('./Audio_example/XC41136_denoised.wav',x,Fs); 

