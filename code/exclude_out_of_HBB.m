function [I_res] = exclude_out_of_HBB(I_nipple_cand, HBB_mask)
    I_res = HBB_mask .* I_nipple_cand;
end


