function [ fxf ] = reducer(reduce,fx1,length,reduceup,type )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if strcmp(type,'lp')
  fx1(reduceup:length-reduceup)=0; 
 fxf=fx1;
end
if strcmp(type,'hp')
fx1(1:reduce)=0;
fx1((length-reduce):length)=0;
fxf=fx1;
end
if strcmp(type,'bp')
   fx1(1:reduce)=0;
   fx1(reduceup:length-reduceup)=0;
   fx1(length-reduce:length)=0;
   fxf=fx1;
end   
if strcmp(type,'bs')
    fx1(reduce:reduceup)=0;
    fx1(length-reduceup:length-reduce)=0;
    fxf=fx1;
end

end

