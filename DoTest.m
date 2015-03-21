function DoTest(TestMode)
    global A;
    global Class;
    global Test;
    global TrainSize;
    global Results;
    global TestImageSize;
    global FirstRidgeRegression;
    
    if(strcmp(TestMode,'Corruption') == 1)       
       Percent = 0.1:0.1:0.9; 
    elseif(strcmp(TestMode,'Occlusion') == 1)        
       Percent = 0.1:0.1:0.5; 
    else
        Percent = 1;
    end
    SaveName = 'MyTest';
    
    for p=1:size(Percent,2)
        disp( sprintf('%s_%s_%d_Percent.mat', SaveName, TestMode, Percent(p)*100));
        Acc = 0;
        Next = 0;
        %for i = 1:size(Test,2);    
        MinThreshold = 1;
        Results = zeros(size(Test,2), 2);
        for i = 1:size(Class,2)   
            for j  = 1:Class(1,i)
               x = Test(:, Next+j);
               %RightClass = fix((i-1)/TestSize)+1;    
               RightClass = i;
               if(strcmp(TestMode,'Normal')==1)
                   [ClassX SCI] = Classify(x);       
               elseif(strcmp(TestMode,'Occlusion')==1)
                   [ClassX SCI] = ClassifyOcclusion(RandomOcclusion(x, Percent(p)));
               elseif(strcmp(TestMode,'Corruption')==1)
                   [ClassX SCI] = ClassifyOcclusion(RandomCorrupt(x, Percent(p)));
               end       
               Results(Next+j, 1) = ClassX==RightClass;
               Results(Next+j, 2) = SCI;
               if(ClassX == RightClass)
                   Acc = Acc+1;
               else
                   if(MinThreshold > SCI)
                       MinThreshold = SCI;
                   end
               end
               Result = sprintf('Image %d    RightClass:    %d Classified:    %d	Acc: %d', Next + j, RightClass, ClassX, Acc);
               disp(Result) 
            end	
            Next = Next+ Class(1,i);
        end
        Acc = Acc/size(Test,2);
        disp(sprintf('Accuracy: %f      MinSCI: %f', Acc, MinThreshold));        
        save(sprintf('%s_%s_%d_Percent.mat', SaveName, TestMode, Percent(p)*100), 'Results');
    end
end