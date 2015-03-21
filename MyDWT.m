function [coefs,sizes] = MyDWT(X, Level_Anal, Wave_Name)
    if(nargin<3)
        Wave_Name = 'haar';
    end
    if(nargin<2)
        Level_Anal = 3;
    end
    %Y = detcoef2('v',coefs,sizes,k);
    %[coefs,sizes] = wavedec2(img_anal,Level_Anal,Wave_Name);

    [coefs,sizes] = wavedec2(X, Level_Anal,Wave_Name);
end