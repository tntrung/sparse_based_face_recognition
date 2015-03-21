function [ Out ] = CheckDuplicate( Train, Test )
%CHECKDUPLICATE Summary of this function goes here
%   Detailed explanation goes here
    for i=1:size(Test,2)
        for j=1:size(Train,2)
            if(abs(pdist([Test(:,i) Train(:,j)]'))==0)
                Out = 1;
                return;
            end
        end
    end
    Out = 0;
end

