function [ signal ] = smoother( signal,times,reduce )
%a smoother of a signal for uunwanted peaks
% reduce or amplifier the signal of max values
o=length(signal);
for i=1: times
du=max(signal);
dm=min(signal);
signal(signal(1:o)==du)=du*reduce;
signal(signal(1:o)==dm)=dm*reduce;

end
end

