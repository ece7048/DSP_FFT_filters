function [ steps ] = meaninitializer( accur,data,length,cut,filter )
%is a scanner of the signal to see if there are differents offset of signal
%so to fit a perpose window for hanning filtering latter in the main code.
% accur: is the accuracy of the mean value where the user want (e.t.c.
% for 0.01 give 10,0.001 give 100...)
%cut is the itteration of search for have an intiger windows 
ena=0;
two=1;
i=2;

if strcmp(filter,'mean')
    while ena~=two
        run=length/i;
  
        mean1=mean(data(1:run));
        mean2=mean(data(run:run+run));
   
        if strcmp(filter,'median')
            mean1=median(data(1:run));
            mean2=median(data(run:run+run));
        end
        mean1=accur*mean1;
        mean2=accur*mean2;
        ena=int64(mean1);
        two=int64(mean2);
        if ena==two
            steps=i;
        else
            i=i+1;
        end
    end
end

if strcmp(filter,'median')
    while ena~=two
        run=length/i;
 
        median1=median(data(1:run));
        median2=median(data(run:run+run));
    
        median1=accur* median1;
        median2=accur* median2;
        ena=int64( median1);
        two=int64( median2);
        if ena==two
            steps=i;
        else
            i=i+1;
        end
    end
 end
% same more reps to have an integer sample of windows so we do not ose data
% from the signal
steps=i;

test3=length./steps;
test2=int64(test3);
o=0;
while test3~=test2
steps=steps+1;
test3=length./steps;
test2=int64(test3);
o=o+1;
if o>=cut
    steps=i;
    test3=length./steps;
    test2=int64(test3);
    while test3~=test2
       steps=steps-1;
       test3=length./steps;
       test2=int64(test3);
       o=o+1;
       if o>=cut
           steps=i+cut;
           test3=test2;
       end
   end
           
end
end


end


