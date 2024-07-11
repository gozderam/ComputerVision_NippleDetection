function [I_res] = exclude_tb_regions(I_nipple_cand, height_top, height_bottom)
    mask_top = ones(size(I_nipple_cand, 1), size(I_nipple_cand, 2));
    mask_top(1:height_top, :) = 0;
    mask_bottom = ones(size(I_nipple_cand, 1), size(I_nipple_cand, 2));
    mask_bottom(end:-1:end-height_bottom, :) = 0;
    I_res = I_nipple_cand .* mask_top .* mask_bottom;
end
