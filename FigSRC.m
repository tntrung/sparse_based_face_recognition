function [ output_args ] = FigSRC( SRCListFile )
%FIGSRC Summary of this function goes here
%   Detailed explanation goes here
    SRCList = ReadList(SRCListFile);
    if(~iscell(SRCList) | SRCList{1}==0)
        %5A = 0;
        return;
    end

    Dimension = str2num(SRCList{1});
    Acc_RandomFace = 0;
    Acc_DownSample = 0;    
    
    Results = load(SRCList{2});
    Results = Results.Results;
    Acc_DownSample = size(Results(Results(:,1)>0 ,:),1) / size(Results,1);    
    
    Results = load(SRCList{3});
    Results = Results.Results;
    Acc_RandomFace = size(Results(Results(:,1)>0 ,:),1) / size(Results,1);    
    
    for i=2:size(SRCList,2)/3
        Dimension(end+1) = str2num(SRCList{(i-1)*3+1});
        Results = load(SRCList{(i-1)*3+2});
        Results = Results.Results;
        Acc_DownSample(end+1) = size(Results(Results(:,1)>0 ,:),1) / size(Results,1);    

        Results = load(SRCList{(i-1)*3+3});
        Results = Results.Results;
        Acc_RandomFace(end+1) = size(Results(Results(:,1)>0 ,:),1) / size(Results,1);    
    end    	
	plot(Dimension, Acc_DownSample, Dimension, Acc_RandomFace, 'DisplayName', 'Results', 'YDataSource', 'Results'); figure(gcf)	
	axis([0 1000 0 1]);
    %grid(gca,'minor');
end

