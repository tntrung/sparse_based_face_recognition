function [ Acc RReject MReject] = PickThreshold( ResultsFile )
bbc = load(ResultsFile);
MinTh = min(bbc.Results(bbc.Results(:,1)>0,2));
Thresholds = [MinTh:0.001:0.025];
[abc RReject MReject] = FigThreshold(Thresholds, bbc.Results);
plot(Thresholds, abc,Thresholds, RReject,Thresholds, MReject, 'DisplayName', 'Results', 'YDataSource', 'Results'); figure(gcf)