function [ Out ] = ReshapeImage( Signal, row, col )
%RESHAPEIMAGE Summary of this function goes here
%   Detailed explanation goes here
    Out(:,1) = cast(Signal(:,1), 'uint8');
    Out = reshape(Out, row, col);    
end

