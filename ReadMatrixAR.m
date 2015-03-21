function [ A Class Test] = ReadMatrixAR(TrainSize, ReadMode, Partial)
    %ReadMode = 'Corruption';    
if nargin < 3,
	%OptTol = 1e-5;
    Partial = 'RightEye';
end            
    global TestImageSize;
    if(strcmp(ReadMode,'Disguise') == 1 )
        [A Class Test] = ReadDisguise(TrainSize);
        return;    
    end
    ImagePath = '.\Images\AR\';        
    FileListFileName = 'file.lst';
    ReducingMode = 'DownSample'
    A= 0;
    Class = 0;
    Test = 0;
    
    OriDimension = 19800;
    RandomProject = 0;
    nTotalSubset = 100;
    %nScale = 4;
    if (ReducingMode == 'RandomFace')        
        RD = TestImageSize(1) * TestImageSize(2);%2016;%8064
        RandomProject = zeros(RD, OriDimension); %d X m m = 32256;
        for i = 1:RD
            RandomProject(i,:) = normrnd(0,1, 1, OriDimension);
            RandomProject(i,:) = RandomProject(i,:)./norm(RandomProject(i,:));
            %RandomProject(i,:) = (RandomProject(i,:)-min(RandomProject(i,:)))./(max(RandomProject(i,:))-min(RandomProject(i,:))) ;
        end
    elseif (ReducingMode == 'DownSample')        
        
    end        
    
    Class  = zeros(1, nTotalSubset);	
    for i = 1:nTotalSubset        
        disp(sprintf('Reading subset %d', i)); 
        FileList = ReadSubsets (i, 'Normal');
        if(~iscell(FileList) | FileList{1}==0)
            A = 0;
            return;
        end        
		Class(1, i) = size(FileList,2)  - TrainSize;
		%RandomList = randperm(size(FileList,2));
        for j = 1:size(FileList,2)
            File = FileList{j};
            %disp(File);
			%File = strcat(File, FileList{j});
            [tmp1, map] = imread(File);
            tmp1 = rgb2gray(tmp1);
            %[coefs, sizes] = MyDWT(tmp1);
            %tmp1 = VisualizeDWT(coefs, sizes, sizes(size(sizes, 1),:));                
            if (ReducingMode == 'DownSample')
                %tmp1 = imresize(tmp1, fix(size(tmp1)/nScale));                                
                tmp1 = imresize(tmp1, TestImageSize);                                  
            end            
            tmp1 = tmp1(:);
            tmp = zeros(size(tmp1,1),1);
            
            if (strcmp(ReducingMode, 'RandomFace')==1)
                tmp(:,1) = cast(tmp1(:,1), 'double');
                tmp = RandomProject*tmp;
            else
                tmp(:,1) = cast(tmp1(:,1), 'double');
                tmp(:,1) = tmp(:,1)./norm(tmp(:,1));
                %tmp(:,1) = tmp(:,1)./255;
                
            end                       
            %if(j<=size(FileList,2) - TestSize)
			if(j<=TrainSize)
                if size(A,1) == 1
                    A = tmp;
                else A(:, end+1) = tmp;
                end                            
            else
                if Test == 0
                    Test = tmp;
                else Test(:, end+1) = tmp;
                end            
            end
            clear tmp;
        end        
    end    
end

function [ A Class Test] = ReadDisguise(TrainSize)   
    global TestImageSize;
    ImagePath = '.\Images\AR\';        
    FileListFileName = 'file.lst';
    ReducingMode = 'DownSample';
    A= 0;
    Class = 0;
    Test = 0;
    
    OriDimension = 19800;
    RandomProject = 0;
    nTotalSubset = 100;
    %nScale = 4;
    if (ReducingMode == 'RandomFace')        
        RD = TestImageSize(1) * TestImageSize(2);%2016;%8064
        RandomProject = zeros(RD, OriDimension); %d X m m = 32256;
        for i = 1:RD
            RandomProject(i,:) = normrnd(0,1, 1, OriDimension);
            RandomProject(i,:) = RandomProject(i,:)./norm(RandomProject(i,:));
            %RandomProject(i,:) = (RandomProject(i,:)-min(RandomProject(i,:)))./(max(RandomProject(i,:))-min(RandomProject(i,:))) ;
        end
    elseif (ReducingMode == 'DownSample')        
        
    end        
    
    Class  = zeros(1, nTotalSubset);	
    for i = 1:nTotalSubset        
        disp(sprintf('Reading subset %d', i)); 
        FileList = ReadSubsets (i, 'Disguise');
        if(~iscell(FileList) | FileList{1}==0)
            A = 0;
            return;
        end        
		Class(1, i) = size(FileList,2)  - TrainSize;
		%RandomList = randperm(size(FileList,2));
        for j = 1:size(FileList,2)
            File = FileList{j};
            %disp(File);
			%File = strcat(File, FileList{j});
            [tmp1, map] = imread(File);
            tmp1 = rgb2gray(tmp1);
            %[coefs, sizes] = MyDWT(tmp1);
            %tmp1 = VisualizeDWT(coefs, sizes, sizes(size(sizes, 1),:));                
            if (ReducingMode == 'DownSample')
                %tmp1 = imresize(tmp1, fix(size(tmp1)/nScale));                                
                tmp1 = imresize(tmp1, TestImageSize);                                  
            end            
            tmp1 = tmp1(:);
            tmp = zeros(size(tmp1,1),1);
            
            if (strcmp(ReducingMode, 'RandomFace')==1)
                tmp(:,1) = cast(tmp1(:,1), 'double');
                tmp = RandomProject*tmp;
            else
                tmp(:,1) = cast(tmp1(:,1), 'double');
                %tmp(:,1) = tmp(:,1)./norm(tmp(:,1));
                tmp(:,1) = tmp(:,1)./255;
                
            end                       
            %if(j<=size(FileList,2) - TestSize)
			if(j<=TrainSize)
                if size(A,1) == 1
                    A = tmp;
                else A(:, end+1) = tmp;
                end                            
            else
                if Test == 0
                    Test = tmp;
                else Test(:, end+1) = tmp;
                end            
            end
            clear tmp;
        end        
    end    
end


function [List] =  ReadSubsets (nSubset, Feature)
    if(nSubset<10)
        FileName = sprintf('Subset00%d.lst', nSubset);
    elseif(nSubset<100)
        FileName = sprintf('Subset0%d.lst', nSubset);
    else
        FileName = sprintf('Subset%d.lst', nSubset);
    end
    FileList = ReadList(FileName);
    if(~iscell(FileList) | FileList{1}==0)
        List = 0;
        return;
    end
    %Class(1, i) = size(FileList,2)  - TrainSize;
    %RandomList = randperm(size(FileList,2));
    List = '';
    if(strcmp(Feature,'Normal') == 1)
        for j = 1:size(FileList,2)        
            if(j < 8 | (j>13 & j<21))
                List{end+1} = FileList{j};
            end       
        end        
    end
    if(strcmp(Feature,'Disguise') == 1)
        for j = 1:size(FileList,2)        
            if(j < 5 | (j>13 & j<18))
                List{end+1} = FileList{j};
            end       
        end        
        %sun glass
        List{end+1} = FileList{8};
        List{end+1} = FileList{21};
        %scarf
        List{end+1} = FileList{11};
        List{end+1} = FileList{24};
    end
end