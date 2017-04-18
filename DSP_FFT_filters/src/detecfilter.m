function [ signal ] = detecfilter( signal,noisesignal,k,z,SNR,fs )
% a cutter of signal with a cut porposion of the length of signal (e.g.10)
% and filtering the noise area when the value of signal is bigger than a
% threshold this threshold finds the start enad and of noise window which
% then filter the wiener method based the filter befor and after the noise
o=int64(length(noisesignal));
        %1st area
       
            midle=int64(o/2);
            h=signal(k-midle:k);
            H=fft(h);
            signald= noisesignal(1:midle);
            %[ signalback ] = meannoisewindow( signald,fs );
            sign=signald;
             %SNR=snr(signald',fs);
            [ signalfilt ] = wiener1D( sign,H,SNR );
            signalfilt=signalfilt-mean(signalfilt);
              vv=signalfilt(1:midle);
                 kl=1;
            for i=k:k+midle-1
               
                signal(i)=vv(kl);
                kl=kl+1;
            end
             
        %second area
             h2=signal(z:z+midle);
            H2=fft(h2);
            signal2= noisesignal(midle:end);
             
            %SNR2=snr(signal2',fs);
              %[ signalback2 ] = meannoisewindow( signal2,fs );
              sign2=signal2;
            [ signalfilt2 ] = wiener1D(sign2,H2,SNR );
             signalfilt2=signalfilt2-mean(signalfilt2);
                kk=signalfilt2(1:midle);
              kl=1;
            for i=k+midle:z-1
               
                signal(i)=kk(kl);
                kl=kl+1;
            end
end

