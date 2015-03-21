function [ Acc RReject MReject] = FigThreshold( Thresholds, Results )
%FIGTHRESHOLD Summary of this function goes here
%   Detailed explanation goes here
    Acc = zeros(1, size(Thresholds,2));
    RReject = zeros(1, size(Thresholds,2));
    MReject = zeros(1, size(Thresholds,2));
    for i=1:size(Thresholds,2)
        Right = size(Results(Results(:,1)>0 & Results(:,2)>Thresholds(i),:));
        Miss = size(Results(Results(:,1)==0 & Results(:,2)>Thresholds(i),:));
        RReject(1,i) = Right(1)/size(Results(Results(:,1)>0,:),1);
        %MReject(1,i) = (size(Results(Results(:,1)==0,:),1) - Miss(1))/size(Results(Results(:,1)==0,:),1);
        MReject(1,i) = Miss(1)/size(Results(Results(:,1)==0,:),1);
        Acc(1,i) = Right/(Right+Miss);
    end
end

