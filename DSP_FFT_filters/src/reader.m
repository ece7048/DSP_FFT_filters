function [ fx ] = reader( base,fx1,lengtht,bound,reduce,reduceup,type,smooth )
%a fuction for cutting untill a boundary and filtering with reducer and low
%pass of a frequency which given from user

ag=unwrap(angle(fx1));
value=abs(fx1);
base=int64(base);
value=(value);
if strcmp(smooth,'yes both')
        for i=1:lengtht/2
            if value(i)>=bound %10^3 bound it is OK based the DATA of ECG where reduce the high volume of ecg and the stochastc noise
                
                fx1(i)=0;
                fx1(lengtht-i)=0;
                  
            end
        end
            fx1(base:(lengtht-base))=0; % low pass filter generall
            %now we want a second evaluate of signal here to dicrease more
            %the noise so we call reducer
           
            [ fxf ] = reducer(reduce,fx1,lengtht,reduceup,type);
             
            fx=fxf;
        
elseif strcmp(smooth,'no filter')
     for i=1:lengtht/2
            if value(i)>=bound %10^3 bound it is OK based the DATA of ECG where reduce the high volume of ecg and the stochastc noise
                
                fx1(i)=0;
                fx1(lengtht-i)=0;  
            end
     end
     fx=fx1;
elseif strcmp(smooth,'no cut')
            fx1(base:(lengtht-base))=0;
            %now we want a second evaluate of signal here to dicrease more
            %the noise so we call reducer
            bases=reduce;
             [ fxf ] = reducer(bases,fx1,lengtht,reduceup,type);
             
            fx=fxf;
elseif strcmp(smooth,'nothing')
    fx=fx1;
else
    ERROR 'Give in smooth (the last variable) the followin 'yes' for cutting in a value  'no cut' for only classical filters, 'no filter' only cut boundary, 'nothing' for no filtering'
    pause()
end
end

