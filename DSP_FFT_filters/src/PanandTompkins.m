function [ heart,noise,yin ] = PanandTompkins( signal,N,factor,no,hear,S )
%Values examples and explaination
% N=10800;%samples of window detection here 30sec
%no=0.5;%noise threshold the half of the detection threshold
%S=40; %sample which has the pulse of heart count in yin: the signal after the integration
%hear=0.06; %given based the values which want to take account from the yin output 
% no search back detection of Pan and Tompkins paper 1985 but the threshold given from
% the user and remain fixed 
%signal=yyf;
%N=10800;
%factor=2;
x=signal;
yn=signal(1);
heart(1)=0;
noise(1)=0;
e=1;
for i=2:length(signal)
  
        %low filter
        
        if i>2
        oo(i)=2*signal(i-1)-signal(i-2)+1./32*(signal(i));
        elseif i>6
         oo(i)=2*signal(i-1)-signal(i-2)+1./32*(signal(i)-2*signal(i-6));
        elseif i>12
         oo(i)=2*signal(i-1)-signal(i-2)+1./32*(signal(i)-2*signal(i-6)+signal(i-12));
        else 
          oo(i)=2*signal(i-1)+1./32*(signal(i));  
        end   
end           
  
for i=2:length(signal)
    %for i=o:N+o
        %high filter
        
        if i>16
        x(i)=-x(i-1)-(oo(i))+32*oo(i-16);   
        elseif i>32
        x(i)=-x(i-1)-(oo(i))+32*oo(i-16)+oo(i-32);
        else
         x(i)=-x(i-1)-(oo(i));   
        end
end 
for i=3:length(signal)-2
        %Derivative opertion
        if i>2
        y(i)=1./8*(-x(i-2)-2*x(i-1)+2*x(i+1)+x(i+2));
        end
        
end
        %Square
        ys=(y.^2);
  for i=42:length(signal)-42     
        
            % Integration of 41 samples
            for n=2:42
            yn(n)=((ys(i-(+42-n)))+yn(n-1));
            end
   
         yin(i)=(1./41*yn(42));
  end
      yin(1:42)=ys(1:42);
     yin=abs(yin(42:end));


spk=hear;
         npk=no;
         thr1=2*(npk+0.25*(spk-npk));
         thr2=2*(0.5*thr1);
         
 %     n=1;   
%for o=1:N:length(signal)-N
  %  th(n)=max(yin(o:o+N));
 %    n=n+1;
%end
%thr1=min(th);
   change=hear*0.01;  
for o=1:N:length(signal)-N
   %THRESHOLD
        zz=2;
        b=2;
         thr1=hear*max(yin(o:o+N));
         if o>1
              k=int64(0.1*(max(yin(o-N+1:o))));
              l=int64(0.1*(max(yin(o:o+N))));
                z=10*(k-l);   
            if (z>0) 
                thr1=(hear-z*change)*thr1;
            elseif  z<0 
                thr1=(hear+z*change)*thr1;
            elseif z==0
                thr1=hear*max(yin(o:o+N));
            end
         end  
       thr2=no*thr1;
       hea(1)=0;
       nois(1)=0;
        for i=o:S:N+o %the time step of pulse detection 40samples if see yin
                if yin(i)>=thr1
                    hea(zz)=hea(zz-1)+1; 
                    %spk=0.125*yin(i)+0.875*spk;
                    %npk=npk;
                    %thr1=npk+0.25*(spk-npk);
                    %thr2=0.5*thr1;
                    zz=zz+1;
                elseif yin(i)>=thr2
                    nois(b)=nois(b-1)+1;
                    %spk=spk;
                    %npk=0.125*yin(i)+0.875*npk;
                    %thr1=npk+0.25*(spk-npk);
                    %thr2=0.5*thr1;
                    b=b+1;
                end 
        end
   heart(e)=hea(end)*factor; % if 30 secoond here need a 2 from user ;
   noise(e)=nois(end);
   e=e+1;
end  
end            


