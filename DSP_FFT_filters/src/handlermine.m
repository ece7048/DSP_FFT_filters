function [ xx2 ] = handlermine( window,offset,x,w,steps,bas,thre,reduce,reduceup,stepinit,type,reader,filter,fs )
%an function for reduce with a step the boundary of reduce-reduceup (band
%pass filter) and see the changes as reduce the steps
%o=1;
reduce1=reduce;
reduceup1=reduceup;
%while reduce1<=reduceup1
%    reduce1=reduce1+stepinit;
 [ xx2 ] = digroffset( window,offset,x,w,steps,bas,thre,reduce1,reduceup1,type,reader,filter,fs );
% figure (o)
 %plot((xx2));
%o=o+1;
%end
%n=o;
%reduce2=reduce;
%reduceup2=reduceup;
%while reduce2<=reduceup2
%    reduceup2=reduceup2-stepinit;
% [ xx2,k ] = digroffset( window,offset,x,w,steps,bas,thre,reduce2,reduceup2,fftdat );
% figure (n)
% plot((xx2));
%    n=n+1;
%end
end

