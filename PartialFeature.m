function [ Out ] = PartialFeature( Image, Partial )
%PARTIALFEATURE Summary of this function goes here
%   Detailed explanation goes here\
    global TestImageSize;
    if(TestImageSize(1)~= 192 | TestImageSize(2)~= 168)
        error('Test Size must be [192 168]');
        return;
    end
    if(strcmp(Partial, 'MouthChin')==1)        
        Out = Image(116:192,:);
    elseif(strcmp(Partial, 'RightEye')==1)        
        Out = Image(16:75,1:84);
    elseif(strcmp(Partial, 'Nose')==1)        
        Out = Image(53:113,50:119);
    end
end

