function ExportTrain(Output)
	global A;
    global Class;
    global Test;
    global TrainSize;
    global Results;
    global TestImageSize;
	
	fid = fopen(Output, 'w');
	for i=1:size(A,2)
		fprintf(fid, '%d ', fix((i-1)/TrainSize + 1));
        for j=1:size(A,1)
            if(A(j,i) ~= 0)
                fprintf(fid, '%d:%.10g ',j, A(j,i));
            end
        end
        fprintf(fid, '\n');
	end
	fclose(fid);
end
