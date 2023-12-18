   io = dir('./Masks/*.png');
    wind = hamming(128);
    olen = 64;
    nfft = 1024;
    for i=1:size(io,1)
    i
    name = io(i).name;

    [y,Fs] = audioread(['./Raw_audios/',name(1:end-4), '.wav' ]);

    ty = (0:length(y)-1)/Fs;
    % To hear, type sound(y,Fs)
    % sound(y,Fs)
    % figure,stft(y,Fs,'Window',wind,'OverlapLength',olen,'FFTLength',nfft)
    io2 = extractBetween(name,'_','.');
    if (size(io2,1)>0) && (isequal(io2{1},'left'))
        y = y(:,1);
        s = stft(y,Fs,'Window',wind,'OverlapLength',olen,'FFTLength',nfft);
    elseif (size(io2,1)>0) && (isequal(io2{1},'right'))
        y = y(:,2);
        s = stft(y,Fs,'Window',wind,'OverlapLength',olen,'FFTLength',nfft);
    else
        s = stft(y,Fs,'Window',wind,'OverlapLength',olen,'FFTLength',nfft);
    end
%     smag = abs(s);
%  predict_mask = imread(['./Predict_tt/',name]);
%     predict_mask = imread(['./Predict_Deeplabv3/',name]);
%     predict_mask = imread(['./Predict_Unet/',name]);
%       predict_mask = imread(['./Predict_U2net/',name]);
%       predict_mask = imread(['./Predict_MTUnet/',name]);
% predict_mask = imread(['./Predict_Segmenter/',name]);
predict_mask = imread(['./Predict_SegNet/',name]);
%     smag(predict_mask<1)=0;
    %% using stftmag2sig is too slow
%     [x,tx,info] = stftmag2sig(double(smag),handles.nfft,Fs,'Window',handles.wind,'OverlapLength',handles.olen);
%     [x2,tx,info] = stftmag2sig(gpuArray(double(smag)),gpuArray(handles.nfft),gpuArray(Fs),'Window',gpuArray(handles.wind),'OverlapLength',gpuArray(handles.olen));
    %% using inverse stft is much faster
    predict_mask = imresize(predict_mask,[size(s,1),size(s,2)]);
    s2 = s; s2(predict_mask<1)=0;
    [ix2,~] = istft(s2,Fs,'Window',wind,'OverlapLength',olen,'FFTLength',nfft);
    x = real(ix2);
%     audiowrite(['./Audio_denoised_predict_tt/',name(1:end-4), '.wav'],x,Fs);
%     audiowrite(['./Audio_denoised_predict_Deeplabv3/',name(1:end-4), '.wav'],x,Fs);
%     audiowrite(['./Audio_denoised_predict_Unet/',name(1:end-4), '.wav'],x,Fs); 
%     audiowrite(['./Audio_denoised_predict_U2net/',name(1:end-4), '.wav'],x,Fs); 
%     audiowrite(['./Audio_denoised_predict_MTUnet/',name(1:end-4), '.wav'],x,Fs); 
% audiowrite(['./Audio_denoised_predict_Segmenter/',name(1:end-4), '.wav'],x,Fs); 
audiowrite(['./Audio_denoised_predict_SegNet/',name(1:end-4), '.wav'],x,Fs); 
    x(end:end+size(y,1)-size(x,1))=0;
    SDR(i,4) = 10*log(norm(y)/(norm(x-y)));
    MS_E(i,4) = mean((y-x).^2);
    disp(SDR(i,:))
    end