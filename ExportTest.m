function ExportTest(Output)
	global A;
    global Class;
    global Test;
    global TrainSize;
    global Results;
    global TestImageSize;
	
	fid = fopen(Output, 'w');
    Next = 0;
	for i = 1:size(Class,2)               		
        for j = 1:Class(1,i)
            fprintf(fid, '%d ', i);
            for k=1:size(Test,1)                
                if(Test(k,Next + j) ~= 0)
                    fprintf(fid, '%d:%.10g ',k, Test(k,Next+j));
                end
            end
            fprintf(fid, '\n');
        end        
        Next = Next+ Class(1,i);
	end
	fclose(fid);
end
