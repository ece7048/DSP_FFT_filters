function [ xxf ] = looper( window,offset,signal,w,steps,baseofzero,threashold, reduce,reduceup,stepinit,type,reader,filter,fs,times )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for i=1:times
    
    [ xx1 ] = handlermine(window,offset,signal,w,steps,baseofzero,threashold, reduce,reduceup,stepinit,type,reader,filter,fs );
    
 
    
end
   xxf=xx1;
end

