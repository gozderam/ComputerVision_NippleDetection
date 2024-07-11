function [human_body_mask] = human_body_segmentation(I_gray_original, threshold)
    I_body_mask = imbinarize(I_gray_original, threshold); 

    % morphological closing
    se_close = strel('disk',3);
    I_morph = imclose(I_body_mask, se_close);
    
    % morphological dilation
    se_dil = strel('disk', 10');
    I_morph = imdilate(I_morph, se_dil);
    human_body_mask = I_morph;
end