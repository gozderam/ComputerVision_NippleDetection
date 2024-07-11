function [I_res] = exclude_small_regions(I_nipple_cand, I_gray_original, N_p)
    I_labeled = bwlabel(I_nipple_cand, 8);  
    region_measurements = regionprops(I_labeled, I_gray_original, 'all');
    all_region_areas = [region_measurements.Area];
    allowable_area_indexes = all_region_areas > N_p;
    keeper_indexes = find(allowable_area_indexes);
    I_res = ismember(I_labeled, keeper_indexes);
end


