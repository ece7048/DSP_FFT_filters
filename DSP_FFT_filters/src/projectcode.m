%% PROJECT OF BIOMEDICAL SIGNAL PROCESSING!!

%% SECTION 1
% Reduce every kind of noise for the two signals of two chanels.
%%
%% Step 1: READ THE TWO SIGNALS OF ECGs
% from: C:\Users\ece\Desktop\signal prosecing\project\F1\
%%
close all

x=data(:,1);
x22=data(:,2);
figure (1);
plot(x);
figure (2);
plot(x22);
%show spectrume frequency of two signals
figure();
subplot(2,1,1), plot(10*log10(abs(fft(x))))
    subplot(2,1,2),plot(10*log10(abs(fft(x22))))
        
%% Step 2: DC-OFFSET
% as we can see the two signal has a variable DC offset so we have to take
% a window. So we will take a for loop with a fix hamming window of as we
%%
%CHANNEL 1

% Compute DC and remove it.
offset=0;
filter='mean';
 [ steps ] = meaninitializer( 100000,x,length(x),200,filter ); %0.000001 accuracy here
window=(length(x)-offset)/steps;
w = hanning(window)' ; % choose hanning window
reader='yes both';
reduce=(160*window/fs)-(0.2*window/fs); % smaller 60 pass only Hz
reduceup=(177*window/fs); %50hz no good accuracy of frequency spectrum (small window) so only a low pass of 60Hz
type='lp';%lpass
stepinit=10;%searching step if i need reduced of window %here not used...
baseofzero=180;%lp filter based  except the other frequencyfirst this then the reducer smaller than fs/2
threashold=50;% threshold cut at dB if it used
%handler for redused mean value and the small valued noise (threashold) here

[ xx ] = handlermine(window,offset,x,w,steps,baseofzero,threashold, reduce,reduceup,stepinit,type,reader,filter,fs );
[ xx1 ] = handlermine(window,offset,xx,w,steps,baseofzero,threashold, reduce,reduceup,stepinit,type,reader,filter,fs );
%every time we send the signal reduce the values so the amplifier only is
%not enough... so only one time 
[ xxf ] = looper( window,offset,xx1,w,steps,baseofzero,threashold, reduce,reduceup,stepinit,type,reader,filter,fs,5 );

%give it back again so smoother better results
figure();
subplot(3,1,1), plot(10*log10(abs(fft(xx1))));
subplot(3,1,2),plot(xx1)
subplot(3,1,3),plot(xxf)


 
%% reduce the random noise with wiener based filter

  %define the noise window
  fs=360;
  noise1=xxf(108200:150800);
   [ signalback ] = meannoisewindow( noise1,fs,1000 );
   [ signal1 ] = detecfilter( xxf,signalback,108200,150800,15,fs );
   
    signal1(108200:150800)=signal1(1:length(noise1));
 plot(signal1)
 %%
  noise2=signal1(194500:237800);
    [ signalback ] = meannoisewindow( noise2,fs,1000 );
   [ signal2 ] = detecfilter( signal1, signalback,194500,237800,15,fs );
   
    signal2(194500:237800)= signal2(1:length(noise2));
 plot(signal2)
 %%
  noise3=signal2(281000:323900);
   [ signalback ] = meannoisewindow( noise3,fs,1000 );
     [ signal3 ] = detecfilter( signal2,signalback,281000,323900,15,fs );
   
    signal3(281000:323900)=signal3(1:length(noise3));
 plot(signal3)
 %%
  noise4=signal3(367600:410500);
    [ signalback ] = meannoisewindow( noise4,fs,1000 );
  [ signal4 ] = detecfilter( signal3,signalback,367600,410500,15,fs );
  
    signal4(367600:410500)=signal4(1:length(noise4));
 plot(signal4)
 %%
  noise5=signal4(453400:496800);
    [ signalback ] = meannoisewindow( noise5,fs,10000 );
  [ signal5 ] = detecfilter( signal4,signalback,453400,496800,15,fs );
  
    signal5(453400:496800)=signal5(1:length(noise5));
 plot(signal5)
 %%
  noise6=signal5(540500:582800);
  [ signalback ] = meannoisewindow( noise6,fs,1000 );
  [ signal6 ] = detecfilter( signal5,signalback,540500,582800,15,fs );
    
    signal6((540500:582800))=signal6(1:length(noise6));
 plot(signal6)
 %%
  noise7=signal6(627000:end);
   [ signalback ] = meannoisewindow( noise7,fs,1000 );
  [ signal7 ] = detecfilter( signal6,signalback,627000,int64(627000-length( signalback )./2),15,fs );
   
    signal7(627000:end)=signal7(1:length(noise7));
 plot(signal7)
 
 %%
 
  %%
 % FINAL reduce the frequency spectrum
fin1=fft(signal7);
power=40;%power level of abs fft cut, 100000*abs(fft)
down=0;
size=length(xx1);
 [ fxf] = finishit( size,fin1,power,down,'std' );
%lowpass the heart beat is at a frequency 5-40Hz
 fs=360;
reduceup=40*size/fs;%72240;%100Hz bp
reduce=0.5*size/fs;
type1='bp';
[ f1 ] = reducer(reduce,fxf,size,reduceup,type1 );
fp1=f1(1:200000);
final1=real(ifft(f1));
figure(101)
    subplot(3,1,1),plot(abs(fin1))
          
    subplot(3,1,2)
        axis([1 length(fp1) 10 100000]) ;
        semilogy(abs(fp1)) ;
     subplot(3,1,3), plot(final1)
 %%
% step smoothing signal 
 [ signalc2 ] = smoother( final1,100,0 );

 figure();
 subplot(2,1,2), plot(signalc2)
    subplot(2,1,1),plot(signal7)
 

 
 %% PLAY
 load handel;

player= audioplayer(10*signalc2,1000);
 play(player);
 %%
 filename='C:\Users\ece\Desktop\signal prosecing\project\code project\chanelonesectionone.wav';
  audiowrite(filename,10*signalc2,360);
  [y,Fs] = audioread(filename);
  sound(y,1000);
 %%
 %%
 %%
 %%
 %%
%%
%CHANNEL 2

% a small shifting compair the other channel here not used
SHIFT='NO';
if strcmp(SHIFT,'YES')
    x2new(1:length(x22))=0;
    delay=2000/4;
    xxxx=(length(x22)-delay+1);
    x2new(1:delay)=x22(xxxx:length(x22));
    x2new(delay:length(x22))=x22(1:xxxx);
    figure(23211)
    subplot(2,1,1), plot(xx2)
    subplot(2,1,2), plot(x2new)
else x2new=x22;
end

offset=0;
filter='mean';
 [ steps ] = meaninitializer( 10000,x2new,length(x2new),200,filter ); %0.000001 accuracy here
windo=((length(x22)-offset)/steps);
w = chebwin(windo)' ; % default eluminate the 100dB (noise)...(better because we have two many noise)
reader='yes both';
reduce=(160*windo/fs)-(0.2*windo/fs); % smaller 60 pass only Hz
reduceup=(178*windo/fs)+(0.2*windo/fs); %50hz no good accuracy of frequency spectrum (small window) so only a low pass of 60Hz
type='lp';%lpass
stepinit=10;%searching step if i need reduced of window %here not used...
baseofzero=180;%lp filter based  except the other frequency 
threashold=50;%or 25;% threshold cut at dB if it used

%handler for redused mean value and the small valued noise (threashold) here
[ xx2 ] = handlermine(windo,offset,x22,w,steps,baseofzero,threashold, reduce,reduceup,stepinit,type,reader,filter ,fs);
[ xx22 ] = handlermine(windo,offset,xx2,w,steps,baseofzero,threashold, reduce,reduceup,stepinit,type,reader,filter,fs );
 %every time we send the signal reduce the values so the amplifier only is
%not enough... so only one time smooth of mean value
[ xxf2 ] = looper( windo,offset,xx22,w,steps,baseofzero,threashold, reduce,reduceup,stepinit,type,reader,filter,fs,5 );
% FFT an signal after DSP
figure();
subplot(3,1,1), plot(10*log10(abs(fft(xx2))));
subplot(3,1,2),plot(xx2)
subplot(3,1,3),plot(xxf2)
   

     

  %% reduce the random noise with wiener based filter
  %define the noise window
  fs=360;
  noise1=xx2(108200:150900);
   [ signalback ] = meannoisewindow( noise1,fs,10000 );
   [ signal1 ] = detecfilter( xx2,signalback,108200,150900,15,fs );
   
    signal1(108200:150900)=signal1(1:length(noise1));
 plot(signal1)
 %%
  noise2=signal1(194700:237200);
    [ signalback ] = meannoisewindow( noise2,fs,10000 );
   [ signal2 ] = detecfilter( signal1, signalback,194700,237200,15,fs );
   
    signal2(194700:237200)= signal2(1:length(noise2));
 plot(signal2)
 %%
  noise3=signal2(281000:323900);
   [ signalback ] = meannoisewindow( noise3,fs,1000 );
     [ signal3 ] = detecfilter( signal2,signalback,281000,323900,15,fs );
   
    signal3(281000:323900)=signal3(1:length(noise3));
 plot(signal3)
 %%
  noise4=signal3(367600:410500);
    [ signalback ] = meannoisewindow( noise4,fs,1000 );
  [ signal4 ] = detecfilter( signal3,signalback,367600,410500,15,fs );
  
    signal4(367600:410500)=signal4(1:length(noise4));
 plot(signal4)
 %%
  noise5=signal4(453400:496800);
    [ signalback ] = meannoisewindow( noise5,fs,10000 );
  [ signal5 ] = detecfilter( signal4,signalback,453400,496800,15,fs );
  
    signal5(453400:496800)=signal5(1:length(noise5));
 plot(signal5)
 %%
  noise6=signal5(540500:582800);
  [ signalback ] = meannoisewindow( noise6,fs,1000 );
  [ signal6 ] = detecfilter( signal5,signalback,540500,582800,15,fs );
    
    signal6((540500:582800))=signal6(1:length(noise6));
 plot(signal6)
 %%
  noise7=signal6(627000:end);
   [ signalback ] = meannoisewindow( noise7,fs,100 );
  [ signal7 ] = detecfilter( signal6,signalback,627000,int64(627000-length( signalback )./2),15,fs );
   
    signal7(627000:end)=signal7(1:length(noise7));
 plot(signal7)
 
 %% 
% FINAL reduce the frequency spectrum
fin2=fft(signal7); % the signal is reverse so -signal
power=40;%power level of abs fft cut, 100000*abs(fft)
down=0;
size=length(fin2);
 [ fxf22] = finishit( size,fin2,power,down,'std' );
 
 windo=length(fxf22);
 fs=360;
  reduceup=(25*windo/fs); %72240;%40
reduce=(0.5*windo/fs); 
type1='bp';
[ f2 ] = reducer(reduce,fxf22,size,reduceup,type1 );
fp2=f2(1:200000);
final2=real(ifft(f2));
figure(101)
    subplot(3,1,1),plot(10*log10(abs(final2)))
          
    subplot(3,1,2)
        axis([1 length(fp2) 10 100000]) ;
        semilogy(abs(fp2)) ;
     subplot(3,1,3), plot(final2)
 
 %%
 %%
% step smoothing signal 
 [ signalc22 ] = smoother( final2,100,0 );

 figure();
 subplot(2,1,2), plot(signalc22)
    subplot(2,1,1),plot(signal7)
 

%% PLAY
 load handel;
 
player= audioplayer(10*signalc22(100000:end),1000);
 play(player);
 
  %%
 filename='C:\Users\ece\Desktop\signal prosecing\project\code project\chaneltwosectionone.wav';
  audiowrite(filename,10*signalc22,360);
  [y,Fs] = audioread(filename);
  sound(y,1000);

 %%
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%
%%%%
%%%
%

clear all
close all

%% SECTION 2
% % Reduce every kind of noise for the two signals of two chanels and found
% the heart beat every >0.5sec cound.
%%
%%
% QUESTION 1: REDUCE THE NOISE OF THE TWO CHANNELS?

%%
%% Step 1: READ THE TWO SIGNALS OF ECGs
% from: C:\Users\ece\Desktop\signal prosecing\project\F1\
%%
close all

y=data(:,1);
y22=data(:,2);
figure (1);
plot(y);
figure (2);
plot(y22);
%show spectrume frequency of two signals
figure();
subplot(2,1,1), plot(10*log10(abs(fft(y))))
    subplot(2,1,2),plot(10*log10(abs(fft(y22))))
        
%% Step 2: DC-OFFSET
% as we can see the two signal has a variable DC offset so we have to take
% a window. So we will take a for loop with a fix hamming window of as we
%%
%CHANNEL 1

% Compute DC and remove it.
offset=0;
filter='mean';
 [ steps ] = meaninitializer( 100000,y,length(y),200,filter ); %0.000001 accuracy here
window=(length(y)-offset)/steps;
w = hanning(window)' ; % choose hanning window
reader='yes both';
reduce=(160*window/fs)-(0.2*window/fs); % smaller 60 pass only Hz
reduceup=(175*window/fs); %50hz no good accuracy of frequency spectrum (small window) so only a low pass of 60Hz
type='lp';%lpass
stepinit=10;%searching step if i need reduced of window %here not used...
baseofzero=180;%lp filter based  except the other frequencyfirst this then the reducer smaller than fs/2
threashold=50;% threshold cut at dB if it used
%handler for redused mean value and the small valued noise (threashold) here

[ yy ] = handlermine(window,offset,y,w,steps,baseofzero,threashold, reduce,reduceup,stepinit,type,reader,filter,fs );
[ yy1 ] = handlermine(window,offset,yy,w,steps,baseofzero,threashold, reduce,reduceup,stepinit,type,reader,filter,fs );
%every time we send the signal reduce the values so the amplifier only is
%not enough... so only one time 
[ yyf ] = looper( window,offset,yy1,w,steps,baseofzero,threashold, reduce,reduceup,stepinit,type,reader,filter,fs,5 );
%[ yy2 ] = handlermine(window,offset,yy1,w,steps,baseofzero,threashold, reduce,reduceup,stepinit,type,reader,filter,fs );

%give it back again so smoother better results
figure();
subplot(3,1,1), plot(10*log10(abs(fft(yy1))));
subplot(3,1,3),plot(yyf)
subplot(3,1,2),plot(yy1)
 


%% reduce the random noise with wiener based filter

  %define the noise window
  fs=360;
  noise1=yyf(108200:151000);
   [ signalback ] = meannoisewindow( noise1,fs,1000 );
   [ signal1 ] = detecfilter( yyf,signalback,108200,151000,15,fs );
   
    signal1(108200:151000)=signal1(1:length(noise1));
 plot(signal1)
 %%
  noise2=signal1(194500:237800);
    [ signalback ] = meannoisewindow( noise2,fs,1000 );
   [ signal2 ] = detecfilter( signal1, signalback,194500,237800,15,fs );
   
    signal2(194500:237800)= signal2(1:length(noise2));
 plot(signal2)
 %%
  noise3=signal2(281000:323900);
   [ signalback ] = meannoisewindow( noise3,fs,1000 );
     [ signal3 ] = detecfilter( signal2,signalback,281000,323900,15,fs );
   
    signal3(281000:323900)=signal3(1:length(noise3));
 plot(signal3)
 %%
  noise4=signal3(367600:410500);
    [ signalback ] = meannoisewindow( noise4,fs,1000 );
  [ signal4 ] = detecfilter( signal3,signalback,367600,410500,15,fs );
  
    signal4(367600:410500)=signal4(1:length(noise4));
 plot(signal4)
 %%
  noise5=signal4(453400:496800);
    [ signalback ] = meannoisewindow( noise5,fs,10000 );
  [ signal5 ] = detecfilter( signal4,signalback,453400,496800,15,fs );
  
    signal5(453400:496800)=signal5(1:length(noise5));
 plot(signal5)
 %%
  noise6=signal5(540500:582800);
  [ signalback ] = meannoisewindow( noise6,fs,1000 );
  [ signal6 ] = detecfilter( signal5,signalback,540500,582800,15,fs );
    
    signal6((540500:582800))=signal6(1:length(noise6));
 plot(signal6)
 %%
  noise7=signal6(627000:end);
   [ signalback ] = meannoisewindow( noise7,fs,1000 );
  [ signal7 ] = detecfilter( signal6,signalback,627000,int64(627000-length( signalback )./2),15,fs );
   
    signal7(627000:end)=signal7(1:length(noise7));
 plot(signal7)
 
 %%
 
%%
 
 
 % FINAL reduce the frequency spectrum
fin1=fft(signal7);
power=40;%power level of abs fft cut, 100000*abs(fft)
down=0;
size=length(yy1);
 [ fxf] = finishit( size,fin1,power,down,'std' );
%lowpass the heart beat is at a frequency 5-40Hz

reduceup=40*size./fs;
reduce=0.5*size./fs;
type1='bp';
[ f1 ] = reducer(reduce,fxf,size,reduceup,type1 );
fp1=f1(1:200000);
final1=real(ifft(f1));
figure(101)
    subplot(3,1,1),plot(10*log10(abs(fp1)))
          
    subplot(3,1,2)
        axis([1 length(fp1) 10 100]) ;
        semilogy(abs(fp1)) ;
     subplot(3,1,3), plot(final1)

     

     %%    
%smoothing signal Worst the signal in sounfd i think
 [ signald ] = smoother( final1,100,0 );

 figure();
 subplot(2,1,2), plot(signald)
 subplot(2,1,1),plot(final1)
 
 %% PLAY
 load handel;
 
player= audioplayer(10*signald,1000);
 play(player);
  %%
 filename='C:\Users\ece\Desktop\signal prosecing\project\code project\chanelonesectiontwo.wav';
  audiowrite(filename,10*signald,360);
  [y,Fs] = audioread(filename);
  sound(y,1000);
 %%
%%
%CHANNEL 2
% a small shifting compair the other channel here not used
SHIFT='NO';
if strcmp(SHIFT,'YES')
    y2new(1:length(y22))=0;
    delay=2000/4;
    xxxx=(length(y22)-delay+1);
    y2new(1:delay)=y22(xxxx:length(x22));
    y2new(delay:length(y22))=y22(1:xxxx);
    figure(23211)
    subplot(2,1,1), plot(yy1)
    subplot(2,1,2), plot(x2new)
else y2new=y22;
end

offset=0;
filter='mean';
 [ steps ] = meaninitializer( 100000,y2new,length(y2new),200,filter ); %0.000001 accuracy here
 %%
window=(length(y22)-offset)/steps;
w = chebwin(window)' ; % default eluminate the 100dB (noise)...(better because we have two many noise)
reader='no filter';
reduce=(160*window/fs)-(0.2*window/fs); % smaller 60 pass only Hz
reduceup=(180*window/fs)+(0.2*window/fs); %small cut%50hz no good accuracy of frequency spectrum (small window) so only a low pass of 60Hz
type='lp';%lpass
stepinit=10;%searching step if i need reduced of window %here not used...
baseofzero=180;%lp filter based  except the other frequency 
threashold=40;% threshold cut at dB if it used

%handler for redused mean value and the small valued noise (threashold) here
[ yy ] = handlermine(window,offset,-y22,w,steps,baseofzero,threashold, reduce,reduceup,stepinit,type,reader,filter ,fs);
[ yy2 ] = handlermine(window,offset,yy,w,steps,baseofzero,threashold, reduce,reduceup,stepinit,type,reader,filter,fs );
 %every time we send the signal reduce the values so the amplifier only is
%not enough... so more time mean smoother 
[ yyf ] = looper( window,offset,yy2,w,steps,baseofzero,threashold, reduce,reduceup,stepinit,type,reader,filter,fs,5);
% FFT an signal after DSP
figure();
subplot(3,1,1), plot(10*log10(abs(fft(yy2))))
subplot(3,1,2),plot(yy2)
subplot(3,1,3),plot(yyf)
   


%% reduce the random noise with wiener based filter

  %define the noise window
  fs=360;
  noise1=yy2(108200:151000);
   [ signalback ] = meannoisewindow( noise1,fs,1000 );
   [ signal1 ] = detecfilter( yy2,signalback,108200,151000,15,fs );
   
    signal1(108200:151000)=signal1(1:length(noise1));
 plot(signal1)
 %%
  noise2=signal1(194500:237800);
    [ signalback ] = meannoisewindow( noise2,fs,1000 );
   [ signal2 ] = detecfilter( signal1, signalback,194500,237800,15,fs );
   
    signal2(194500:237800)= signal2(1:length(noise2));
 plot(signal2)
 %%
  noise3=signal2(281000:323900);
   [ signalback ] = meannoisewindow( noise3,fs,1000 );
     [ signal3 ] = detecfilter( signal2,signalback,281000,323900,15,fs );
   
    signal3(281000:323900)=signal3(1:length(noise3));
 plot(signal3)
 %%
  noise4=signal3(367600:410500);
    [ signalback ] = meannoisewindow( noise4,fs,1000 );
  [ signal4 ] = detecfilter( signal3,signalback,367600,410500,15,fs );
  
    signal4(367600:410500)=signal4(1:length(noise4));
 plot(signal4)
 %%
  noise5=signal4(453400:496800);
    [ signalback ] = meannoisewindow( noise5,fs,10000 );
  [ signal5 ] = detecfilter( signal4,signalback,453400,496800,15,fs );
  
    signal5(453400:496800)=signal5(1:length(noise5));
 plot(signal5)
 %%
  noise6=signal5(540500:582800);
  [ signalback ] = meannoisewindow( noise6,fs,1000 );
  [ signal6 ] = detecfilter( signal5,signalback,540500,582800,15,fs );
    
    signal6((540500:582800))=signal6(1:length(noise6));
 plot(signal6)
 %%
  noise7=signal6(626000:end);
   [ signalback ] = meannoisewindow( noise7,fs,1000 );
  [ signal7 ] = detecfilter( signal6,signalback,626000,int64(626000-length( signalback )./2),15,fs );
   
    signal7(626000:end)=signal7(1:length(noise7));
 plot(signal7)
 
 %%
%% 
% FINAL reduce the frequency spectrum
fin2=fft(signal7); % the signal is reverse so -signal
power=40;%power level of abs fft cut, 100000*abs(fft)
down=0;
size=length(fin2);
 [ fxf22] = finishit( size,fin2,power,down,'std' );
 

reduceup=40*size./fs;%72240;%100Hz bp
reduce=0.5*size./fs;
type1='bp';
[ f2 ] = reducer(reduce,fxf22,size,reduceup,type1 );
fp2=f2(1:200000);
final2=real(ifft(f2));
figure(101)
    subplot(3,1,1),plot(10*log10(abs(final2)))
          
    subplot(3,1,2)
        axis([1 length(fp2) 10 100000]) ;
        semilogy(abs(fp2)) ;
     subplot(3,1,3), plot(final2)
     
 
 %%    
% step smoothing signal 
 [ signal2 ] = smoother( final2,100,0 );
 %amplifier
 figure();
 subplot(2,1,2), plot(signal2)
 subplot(2,1,1),plot(final2)

%% PLAY
 load handel;
 
player= audioplayer(10*signal2,1000);
 play(player);
  %%
 filename='C:\Users\ece\Desktop\signal prosecing\project\code project\chaneltwosectiontwo.wav';
  audiowrite(filename,10*signal2,360);
  [y,Fs] = audioread(filename);
  sound(y,1000);
%%
%%
%QUESTION 2: FOUND THE HEART  BEAT FOR AN TIME AREA BIGGER THAN 0.5sec

%%
%sources: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC497048/, 
% mainly book biomedical signal processing. detection Pan and Tompkins
% p.243 
 
%Call the Pan and Tompkins function which we create base the book for
%Biomedical Signal analysis and the paper of Pan and Tompkins in 1985 'A
%Real-Time QRS Detection Algorithm'
%%
%Channel 1
%we needd any 30second so 360*30=10800 
N=10800;
no=0.5;
hear=0.06;
S=40;
[ heart,noise,yin ] = PanandTompkins( signald,N,2,no,hear,S); %30sec period so multiply with 2
figure()
 plot(heart)
 
%%
%Channel 2

 N=10800;%samples of window detection here 30sec
no=0.5;%noise threshold the half of the detection threshold
S=40; %sample which has the pulse of heart count in yin: the signal after the integration
hear=0.25; %given based the values which want to take account from the yin output 
[ heart2,noise2,yin2 ] = PanandTompkins( signal2,N,2,no,hear,S); %30sec period so multiply with 2

figure()
plot(heart2)
 
%% 
%Evaluation  heart rate
%evaluate results with a validate code of ecg heart rate detection:
%source: https://www.mathworks.com/matlabcentral/fileexchange/45404-ecg-q-r-s-wave-online-detector/content/peakdetect.m
%Channel 1 
 [R_i,R_amp,S_i,S_amp,~,T_amp,Q_i,Q_amp,heart_rate,buffer_plot]=peakdetect(signal2,360,30);
 
%%
%Channel 2
  [R_i,R_amp,S_i,S_amp,T_i,T_amp,Q_i,Q_amp,heart_rate,buffer_plot]=peakdetect(signal,360,30);
 
 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %%
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%
%%%%
%%%
%

clear all
close all


%% SECTION 3
% Reduce every kind of technical noise from ECG signal.
%%
%% Step 1: READ THE TWO SIGNALS OF ECGs
% from: C:\Users\ece\Desktop\signal prosecing\project\F1\
%%
close all
z=data(:,1);
figure (1);
plot(z);
%show spectrume frequency of signals
figure();
plot(10*log10(abs(fft(z))))
%%
%Reduce the frequency spectrum of signal between 0.5-25Hz
size=length(z);
  reduceup1=20*size./fs;
reduce1=214700; %not used
type1='lp';
[ f ] = reducer(reduce1,fft(z),size,reduceup1,type1 );
reducexaf=6*(size./fs); 
reduceupxaf=1; 
type1='hp';
[ fzz ] = reducer(reducexaf,f,size,reduceupxaf,type1 );
fzz(1)=0;
zstart=real(ifft(fzz));
%amplifing
zstart1=zstart;
% zstart1(zstart(1:end)>=max(zstart)-0.06)=max(zstart)-0.04;
figure()
subplot(2,1,1), plot(zstart(88000:118000))
subplot(2,1,2), plot(zstart1(88000:118000))
figure()
subplot(2,1,1), plot(zstart(40000:end-40000))
subplot(2,1,2), plot(zstart1(40000:end-40000))
%% PLAY
 load handel; 
player= audioplayer(50*zstart1(40000:end-40000),44100);
 play(player);
  %%
 filename='C:\Users\ece\Desktop\signal prosecing\project\code project\sectionthree.wav';
  audiowrite(filename,50*zstart1(40000:end-40000),44100);
  [y,Fs] = audioread(filename);
  sound(y,44100);
%%
% THE END
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%
%%%%%%%%
%%%%%%
%%%%%
%%%
%%
%























%% APPENDIX 
%EXTRA WORK
%%


%% Step 2: MOVING AVERAGE FILTERING FOR UNCORRELATION NOISE
%%

%Channel 1
newsignal = tsmovavg(final,'m',5,2);
figure(101)
    subplot(2,1,2), plot(newsignal)
subplot(2,1,1),plot(final)
%%
%Channel 2
newsignal2 = tsmovavg(final2,'m',5,2);
figure(102)
    subplot(2,1,1), plot(newsignal2)
subplot(2,1,2),plot(final2)

%% TODO: Step 3: kalman filter for better reduce of Gaussian noise


%% Step4: CROSS-Correlation

%%
%correlation now
crossx1=xcorr(signal) ;
crossx2=xcorr(signal2) ;


cross=xcorr(crossx1,crossx2);
cros = cross - mean(cross) ;
cro=xcorr(cros);
plot(cro);

%%
figure(1023)
    subplot(2,1,1),plot(crossx1)
    subplot(2,1,2),plot(cro1)
  
%write theory for cross corelation and statistic

crossx1=xcorr(xx1,'unbiased') ;
crossx2=xcorr(xx2,'unbiased') ;
cross=xcorr(crossx1,crossx2,'unbiased');
%cross = cross - mean(cross) ;
figure(12)
plot(crossx1) 
%as we can see if we give a 130000 shift in crossx2 we can have the same
%ecg with first chanel so we will do that and then do a x1-x2 tif zero keep
%it...
x2new(1:length(xx2))=0;
delay=2000/4;
xxxx=(length(xx2)-delay+1);
x2new(1:delay)=xx2(xxxx:length(xx2));
x2new(delay:length(xx2))=xx2(1:xxxx);
figure(23211)
subplot(2,1,1), plot(xx1)
subplot(2,1,2), plot(x2new)
%AUTOCORRELATION SEARCH
%we want to found the fourier frequencies where we have the bigger value
%(signal) TODO:provi it
crossx2=xcorr(x2new,'unbiased') ;
figure(13)
plot(crossx2)
figure(14)
plot(abs(fft(crossx1))) % 10790/2, 7218/2, 3587/2
figure(15)
plot(abs(fft(crossx2)))


