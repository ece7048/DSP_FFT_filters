function [ signalfilt ] = wiener1D( signal,Hsys,SNR )
%filtering with wiener and threshold T the image image.
%wiener estimation

G=(1./Hsys).*((10*log10(abs(Hsys).^2))./((10*log10(abs(Hsys).^2))+1/SNR));
 [ Gop ] = real(ifft( G ));
 signalfilt=conv(signal,Gop,'same');
end

