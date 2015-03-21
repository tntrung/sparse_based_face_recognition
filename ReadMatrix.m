function [ A Class Test] = ReadMatrix(TrainSize, ReadMode, Partial)
    %ReadMode = 'Corruption';    
if nargin < 3,
	%OptTol = 1e-5;
    Partial = 'RightEye';
end            
    global TestImageSize;
    if(strcmp(ReadMode,'Corruption') == 1 | strcmp(ReadMode,'Occlusion') == 1)
        [A Class Test] = ReadCorruption(TrainSize);
        return;
    elseif(strcmp(ReadMode,'Partial') == 1 )
        [A Class Test] = ReadPartial(TrainSize, Partial);
        return;
    end
    global ImagePath
    DirListFileName = 'dir.lst';
    FileListFileName = 'file.lst';
    ReducingMode = 'DownSample';
    A= 0;
    Class = 0;
    Test = 0;      
    
    DirList = ReadList(DirListFileName);
    if(~iscell(DirList) | DirList{1}==0)
        A = 0;
        return;
    end
    
    OriDimension = 32256;
    RandomProject = 0;
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
    
    Class  = zeros(1, size(DirList,2));	
    for i = 1:size(DirList,2)        
        Dir = strcat(ImagePath, DirList{i});
        disp(Dir);
        FileList = ReadList(strcat(Dir,'\file.lst'));        
        if(~iscell(FileList) | FileList{1}==0)
            A = 0;
            disp 'Error !!!!!!!!!!'
            return;
        end
        %Class(1, i) = size(FileList,2)  - TestSize;
		Class(1, i) = size(FileList,2)  - TrainSize;
		RandomList = randperm(size(FileList,2));        
        for j = 1:size(FileList,2)
            File = strcat( Dir, '\');
            File = strcat(File, FileList{RandomList(j)});
            %disp(File);
			%File = strcat(File, FileList{j});
            tmp1 = imread(File);
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
                %tmp(:,1) = tmp(:,1) ./ 255;                
            end                       
            %if(j<=size(FileList,2) - TestSize)
			if (j<=TrainSize)
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

function [ A Class Test] = ReadCorruption(TrainSize)   
    global TestImageSize;
    global ImagePath;
    %ImagePath = '.\Images\EYB\';    
    TrainFileName = 'Subset12.txt';
	TestFileName = 'Subset3.txt';    
    ReducingMode = 'DownSample';
    A= 0;
    Class = 0;
    Test = 0;        

    DirListFileName = 'dir.lst';
    DirList = ReadList(DirListFileName);
    if(~iscell(DirList) | DirList{1}==0)
        A = 0;
        return;
    end
    
    OriDimension = 32256;
    RandomProject = 0;
    %nScale = 4;
    if (ReducingMode == 'RandomFace')        
        RD = TestImageSize(1) * TestImageSize(2);%2016;%8064;
        RandomProject = zeros(RD, OriDimension); %d X m m = 32256;
        for i = 1:RD
            RandomProject(i,:) = normrnd(0,1, 1, OriDimension);
            RandomProject(i,:) = RandomProject(i,:)./norm(RandomProject(i,:));
            %RandomProject(i,:) = (RandomProject(i,:)-min(RandomProject(i,:)))./(max(RandomProject(i,:))-min(RandomProject(i,:))) ;
        end
    elseif (ReducingMode == 'DownSample')        
        
    end        
    
    Class  = zeros(1, size(DirList,2));	
    for i = 1:size(DirList,2)        
        Dir = strcat(ImagePath, DirList{i});
        disp(Dir);                
        FileList1 = ReadList(sprintf('%s\\%s', Dir,TrainFileName));
        if(~iscell(FileList1) | FileList1{1}==0)
            A = 0;
            return;
        end
		FileList2 = ReadList(sprintf('%s\\%s', Dir,TestFileName));
		if(~iscell(FileList2) | FileList2{1}==0)
            A = 0;
            return;
        end
		
        %Class(1, i) = size(FileList,2)  - TestSize;
		Class(1, i) = size(FileList2,2);
		%RandomList = randperm(size(FileList,2));
		for k = 1:2
			if(k==1)
				FileList = FileList1;
			else FileList = FileList2; 
			end
			
			for j = 1:size(FileList,2)
                if(k==1 & j>TrainSize)
                    continue;
                end
				File = strcat( Dir, '\');
				%File = strcat(File, FileList{RandomList(j)});
				%disp(File);
				File = strcat(File, FileList{j});
				tmp1 = imread(File);
				if (ReducingMode == 'DownSample')
					%tmp1 = imresize(tmp1, fix(size(tmp1)/nScale));
                    tmp1 = imresize(tmp1, TestImageSize);
				end            
				tmp1 = tmp1(:);
				tmp = zeros(size(tmp1,1),1);				
				
				if (ReducingMode == 'RandomFace')
					tmp(:,1) = cast(tmp1(:,1), 'double');
					tmp = RandomProject*tmp;
				else
					tmp(:,1) = cast(tmp1(:,1), 'double');
					%tmp(:,1) = tmp(:,1)./norm(tmp(:,1));
					tmp(:,1) = tmp(:,1)./255;
				end                       
				%if(j<=size(FileList,2) - TestSize)
				if(k==1)
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
end

function [ A Class Test] = ReadPartial(TrainSize, Partial)
    %ReadMode = 'Corruption';
    global TestImageSize;
    
    ImagePath = '.\Images\EYB\';    
    DirListFileName = 'dir.lst';
    FileListFileName = 'file.lst';
    ReducingMode = 'DownSample';
    A= 0;
    Class = 0;
    Test = 0;      
    
    DirList = ReadList(DirListFileName);
    if(~iscell(DirList) | DirList{1}==0)
        A = 0;
        return;
    end
    
    OriDimension = 32256;
    RandomProject = 0;
    %nScale = 4;    
    
    Class  = zeros(1, size(DirList,2));	
    for i = 1:size(DirList,2)        
        Dir = strcat(ImagePath, DirList{i});
        disp(Dir);
        FileList = ReadList(strcat(Dir,'\file.lst'));        
        if(~iscell(FileList) | FileList{1}==0)
            A = 0;
            return;
        end
        %Class(1, i) = size(FileList,2)  - TestSize;
		Class(1, i) = size(FileList,2)  - TrainSize;
		RandomList = randperm(size(FileList,2));
        for j = 1:size(FileList,2)
            File = strcat( Dir, '\');
            File = strcat(File, FileList{RandomList(j)});
            
            tmp1 = imread(File);
            if (strcmp(ReducingMode, 'DownSample') == 1)                
                %tmp1 = imresize(tmp1, TestImageSize);
                tmp1 = PartialFeature(tmp1, Partial);
            end            
            tmp1 = tmp1(:);
            tmp = zeros(size(tmp1,1),1);            
            tmp(:,1) = cast(tmp1(:,1), 'double');
                        
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
