function [I_thresholded] = detect_nipple_cand_adaptive_thresh(I_gray_original, C, filter_size)
    J = medfilt2(I_gray_original, [filter_size filter_size]);
    I_diff = J - I_gray_original;
    I_thresholded = imbinarize(I_diff, C);
end