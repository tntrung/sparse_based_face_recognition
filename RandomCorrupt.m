function [ OutSignal ] = RandomCorrupt( Signal, Percent )
%RANDOMCORRUPT Summary of this function goes here
%   Detailed explanation goes here
    nSize = size(Signal,1);
    nCorrupt = fix(nSize * Percent);
    RandomList = randperm(nSize);
    OutSignal = Signal;
    for i = 1:nCorrupt
       OutSignal(RandomList(i),1) = unifrnd(0,255); 
    end    
end

