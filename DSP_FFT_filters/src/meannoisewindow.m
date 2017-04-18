function [ signalback ] = meannoisewindow( signal,fs,accur )
    offset=0;
    
filter='mean';
 [ steps ] = meaninitializer( accur,signal,length(signal),20,filter ); %0.000001 accuracy here
%steps=100;
windo=((length(signal)-offset)/steps);
w = chebwin(windo)' ; % default eluminate the 100dB (noise)...(better because we have two many noise)
reader='no cut';
reduce=1; % smaller 60 pass only Hz
reduceup=50*windo./fs; %40hz no good accuracy of frequency spectrum (small window) so only a low pass of 60Hz
type='lp';%lpass
stepinit=1;%searching step if i need reduced of window %here not used...
baseofzero=180;%lp filter based  except the other frequency 
threashold=1;%or 25;% threshold cut at dB if it used

%handler for redused mean value and the small valued noise (threashold) here
[ xx2 ] = handlermine(windo,offset,signal,w,steps,baseofzero,threashold, reduce,reduceup,stepinit,type,reader,filter ,fs);
[ xx22 ] = handlermine(windo,offset,xx2,w,steps,baseofzero,threashold, reduce,reduceup,stepinit,type,reader,filter,fs );
 %every time we send the signal reduce the values so the amplifier only is
%not enough... so only one time smooth of mean value
[ signalback ] = looper( windo,offset,xx22,w,steps,baseofzero,threashold, reduce,reduceup,stepinit,type,reader,filter,fs,5 );
% FFT an signal after DSP



end

