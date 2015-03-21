function [ OutSignal ] = RandomOcclusion( Signal, Percent )
%RANDOMOCCLUSION Summary of this function goes here
%   Detailed explanation goes here
    nSize = size(Signal,1);
    nCorrupt = fix(nSize * Percent);
    newSize = fix(sqrt(nCorrupt));
    
    global TestImageSize;
    x = fix(unifrnd(1, TestImageSize(2) - newSize));
    y = fix(unifrnd(1, TestImageSize(1) - newSize));
    %x = 5;y=5;
    %disp(sprintf('x: %d y: %d', x, y));
    RandLocate = x * TestImageSize(1) + y;
    %load occlusion Image;
    a = imread('Occ.pgm');    
    a = imresize(a, [newSize newSize]);
    
    OutSignal = Signal;
    for j = 1:newSize
       for i = 1:newSize
           OutSignal(RandLocate + (j-1) * TestImageSize(1) + i - 1, 1) = a(i,j);
           %OutSignal(RandLocate + (j-1)*TestImageSize(1) + i - 1, 1) = cast(a(i,j),'double')/255.0;
       end
    end    
end

