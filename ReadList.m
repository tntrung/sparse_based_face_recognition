function [ List ] = ReadList(ListFileName)
    fp = fopen(ListFileName, 'r+');
    if(fp<0)
        List = 0;
        %fclose(fp); 
        return
    end    
    
    str = fgetl(fp);
    List = '';
    while ischar(str)        
        List{end+1} = str;
        %str = fscanf(fp, '%s\n');
        str = fgetl(fp);
    end
    fclose(fp);        
end