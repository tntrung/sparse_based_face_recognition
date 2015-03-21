classdef (ConstructOnLoad) PartitionDict
    %PARTITIONDICT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = private)
        nPartitions;
        nElements;%number of elements of each part
        DictList;
    end
    
    methods           
        function PD = PartitionDict(nPartitions)
            if(nargin <1)
                PD.nPartitions = 0;
                PD.nElements = 0;
                PD.DictList = '';            
            else 
                PD.nPartitions = nPartitions;
                PD.nElements = 0;
                PD.DictList = '';
            end
        end
        
        function obj = AddElement(obj, X)
            Parts = '';
            %Parts = PartitionPart(X, 2);
            %Parts = [Parts PartitionPart(X, 4)];            
            Parts = [Parts PartitionPart(X, 16)];
            Parts = [Parts PartitionPart(X, 8, sqrt(0.5))];
            Parts = [Parts PartitionPart(X, 4, sqrt(0.25))];
            Parts = [Parts PartitionPart(X, 2, sqrt(0.125))];
            %Parts = [Parts PartitionPart(X, 16)];
            if(obj.nPartitions == 0)
                obj.nPartitions = size(Parts, 2);
                obj.DictList = cell(1, obj.nPartitions);
            end
            if(obj.nElements == 0)
                for i=1:obj.nPartitions
                    obj.DictList{i} = Parts{i};
                end
            else
                for i=1:obj.nPartitions
                    obj.DictList{i}(:,end+1) = Parts{i};
                end            
            end
            obj.nElements = obj.nElements + 1;
        end
        
        function Out = GetPart(obj, nPart)
            Out = obj.DictList{nPart};
        end
        
        function Out = GetTestTrain(obj, class)
            global TrainSize;
            global TestImageSize;
            
            Out = [];
            
            Width = TestImageSize(2);
            Height = TestImageSize(1);
            
            xHalf = fix(Width / 4);
            yHalf = fix(Height / 4);
            
            bId = (class - 1) * TrainSize + 1;
            
            for (i=1:TrainSize)
                img = [];  
                nPart = 1;
                for(r=1:4)
                   row = [];
                   for(c=1:4)
                       part = obj.GetPart(nPart);
                       nPart = nPart + 1;
                       imgPart = part(:, bId + i - 1);
                       imgPart = reshape(imgPart, yHalf, xHalf);
                       row = [row imgPart];
                   end
                   img = [img; row];
                end
                Out = [Out img(:)];
            end 
        end
    end
    
end
