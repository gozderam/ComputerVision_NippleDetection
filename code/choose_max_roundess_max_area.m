function [I_res, left_nipple, right_nipple] = choose_max_roundess_max_area(I_nipple_cand, I_gray_original)
    % caluclate center line
    n_cols = size(I_gray_original, 2);
    L_cnt = n_cols/2;
    
    % calculate regions properties
    I_labeled = bwlabel(I_nipple_cand, 8); 
    region_measurements = regionprops(I_labeled, I_gray_original, 'all');

    % separate left and right sides
    all_region_centroids = [region_measurements.Centroid];
    all_region_centroids_xcoord = all_region_centroids(1:2:end);
    left_indexes = all_region_centroids_xcoord < L_cnt;
    right_indexes = all_region_centroids_xcoord >= L_cnt;

    %% regions roundess
    all_region_circ = [region_measurements.Circularity];
    
    % left 
    max_circ_left = max(all_region_circ(left_indexes));
    max_circl_left_idxs = find(all_region_circ == max_circ_left & left_indexes);
    
    % right
    max_circ_right = max(all_region_circ(right_indexes));
    max_circl_right_idxs = find(all_region_circ == max_circ_right & right_indexes);
    

    %% region area

    all_regions_area = [region_measurements.Area];
    max_roundess_max_area_left = all_regions_area(max_circl_left_idxs);
    max_roundess_max_area_left_idx = find(all_regions_area == max_roundess_max_area_left & left_indexes);
    max_roundess_max_area_right = all_regions_area(max_circl_right_idxs);
    max_roundess_max_area_right_idx = find(all_regions_area == max_roundess_max_area_right & right_indexes);

    %% results
    keeper_circ_indexes = [max_roundess_max_area_left_idx, max_roundess_max_area_right_idx];
    
    I_res = ismember(I_labeled, keeper_circ_indexes);
    if size(max_roundess_max_area_left_idx) == 0
        left_nipple = [];
    else
        left_nipple = region_measurements(max_roundess_max_area_left_idx).Centroid;
    end
    if size(max_roundess_max_area_right_idx) == 0
        right_nipple = [];
    else
        right_nipple = region_measurements(max_roundess_max_area_right_idx).Centroid;
    end
end


