function [ output_args ] = FigOccResultCompare( SRCListFile, mode)
%FIGSRC Summary of this function goes here
%   Detailed explanation goes here
    SRCList = ReadList(SRCListFile);
    if(~iscell(SRCList) | SRCList{1}==0)
        %5A = 0;
        return;
    end
        
    for i=1:size(SRCList,2)        
        Results = load(SRCList{i});
		if(mode==1)
			Results = Results.Results1;
		elseif(mode==2)
			Results = Results.Results2;
		end
        
        Acc  = size(Results(Results(:,1)>0 ,:),1) / size(Results,1);    
		disp(sprintf('Experiment %s     Accuracy: %2.6g', SRCList{i}, Acc));
    end    
	%plot(Dimension, Acc_DownSample, Dimension, Acc_RandomFace, 'DisplayName', 'Results', 'YDataSource', 'Results'); figure(gcf)
    %grid(gca,'minor');
end

