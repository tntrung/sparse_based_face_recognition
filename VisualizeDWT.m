function [ Out ] = VisualizeDWT( coefs, sizes, Img_Size, Wave_Name, Level_Anal)
%VISUALIZEDWT Summary of this function goes here
%   Detailed explanation goes here

%    Img_Size = size(img_anal);
    %VirImage = Img_Size(1) * Img_Size
    if(nargin<5)
        Wave_Name = 'haar';
    end
    if(nargin<4)
        Level_Anal = 3;
    end    
    tmp = appcoef2(coefs,sizes,Wave_Name,Level_Anal);
    codemat_v = 1;%wimgcode('get',win_dw2dtool);
    NB_ColorsInPal = 256;
    trunc_p = [Level_Anal Img_Size(1) Img_Size(2)];    
    tmp = wimgcode('cod',1,tmp,NB_ColorsInPal,codemat_v,trunc_p);

    for k=Level_Anal:-1:1	
        YV = detcoef2('v',coefs,sizes,k);
        YD = detcoef2('d',coefs,sizes,k);
        YH = detcoef2('h',coefs,sizes,k);    

        trunc_p = [k Img_Size(1) Img_Size(2)];    
        YV = wimgcode('cod',1,YV,NB_ColorsInPal,codemat_v,trunc_p);
        YH = wimgcode('cod',1,YH,NB_ColorsInPal,codemat_v,trunc_p);
        YD = wimgcode('cod',1,YD,NB_ColorsInPal,codemat_v,trunc_p);

        tmp = [tmp YH; YV YD];
    end
        
    Out(:,:) = cast(tmp(:,:), 'uint8');
end

