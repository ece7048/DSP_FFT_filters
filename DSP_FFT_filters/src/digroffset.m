function  [ xx2 ] = digroffset( window,offset,x,w,steps,baseup,threashold,reduce,reduceup,type,readerr,filter,fs )
% we elliminate the offset of signal
%base the number of filtering
%bound is based the scale of 1000*(abs(fx1) so given 1 leaves only the very
%strong amples and the signal
%examples
%readerr='yes both';
%filter='mean'
%w=w;
%x=x;
%offset=0;
%window=520;
%steps=1250;
%reduce=62%(62*window/fs)-(0.2*window/fs); % smaller 60 pass only Hz
%reduceup=50%(50*window/fs)+(0.2*window/fs); %50hz no good accuracy of frequency spectrum (small window) so only a low pass of 60Hz
%type='lp';%lpass
%baseup=120;%lp filter based  except the other frequency 
%threashold=100;% threshold cut at 100dB if it used
% build the 2/3window any time so start 1/3 before retake
xx2(1:length(x))=0;
xc(1:length(x))=0;
xc=xc';
xx2=xx2';
iwindow=int64(window);
remake=int64(1./3*window);
%Initialize!!step!!
i=1;
n=1;
   gg=(window+1/6.*window);
     m1=int64((i*iwindow)+offset)+0.5.*remake;
     w1=hanning(gg);
    if strcmp(filter,'mean')
        xw = x(n:m1)- mean(x(n:m1)) ;
    end
    if strcmp(filter,'median')
        xw = x(n:m1)- median(x(n:m1)) ;%leave the median
    end
        x1 = w1.*xw;
        fx1 = fft(x1) ;
        o=length(fx1);
  
        base=int64(baseup*window/fs);
        
        %filtering the first 5 value of freq domain
        %we do a reader of frequency domain if we have noise only the
        %frequency values will has little number we have only signal in low
        %frequencies so we will let only them in the windows where we have
        %many values of frequencies So:
        %the reader
           
        smooth=readerr;
      [ fx ] = reader( base,fx1,o,threashold,reduce,reduceup,type,smooth );
      
                 
    x11=real(ifft(fx)) ;
    x12 = x11./w1;
    xc(n:m1)=x12;
   
    xx2(n:m1)=xc(n:m1);
%Start
for i=2:steps
    n=(((i-1)*iwindow)-(1*remake)+offset+1);
    m=(i*iwindow)-(1*remake)+offset;
    n1=n+int64(0.5*remake);
     m1= m-int64(0.5*remake);
    if strcmp(filter,'mean')
        xw = x(n:m)- mean(x(n:m)) ;
    end
    if strcmp(filter,'median')
        xw = x(n:m)- median(x(n:m)) ;%leave the median
    end
        x122 = w.*xw';
        fx1 = fft(x122) ;
        o=length(fx1);
  
        base=int64(baseup*window/fs);
        
        %filtering the first 5 value of freq domain
        %we do a reader of frequency domain if we have noise only the
        %frequency values will has little number we have only signal in low
        %frequencies so we will let only them in the windows where we have
        %many values of frequencies So:
        %the reader
           
        smooth=readerr;
            [ fx ] = reader( base,fx1,o,threashold,reduce,reduceup,type,smooth );
      
                 
    x11=real(ifft(fx)) ;
    x12 = x11./w;
    x12=x12';
    xc(n:m)=x12;
    xx2(n1:m1)=xc(n1:m1);
end
%finishit TODO the reduce step at end


   xx2(length(xx2)+1:(length(xx2)+0.5*remake-1))=0;
end



