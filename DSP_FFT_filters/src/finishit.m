function [ fxf] = finishit( length,fin,power,down,type )
% is a smoother for boundary zone it leaves only the value inside the upper
% and down boundary
digrese=10*log10(abs(fin));%dB values
   
for i=1:length
if strcmp(type,'std')
    if digrese(i)>power
        
        fin(i)=power;
    end
    if digrese(i)<down
        fin(i)=down;
        
    end
end
   if strcmp(type,'ampl')
    if digrese(i)>down && digrese(i)< power
        fin(i)=power;
    end
   end
end

    
fxf=fin;
end

