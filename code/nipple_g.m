function [I_res] = nipple_g(I, plot_results)
    I_gray = rgb2gray(I);
    if plot_results
        subplot(2, 4, 1), imshow(I_gray);
        title('Original Image')
    end
    
    %% human body segmentation
    threshold = 50/255.0;
    I_body_mask = human_body_segmentation(I_gray, threshold);
    if plot_results
        subplot(2, 4, 2), imshow(I_body_mask)
        title('Human body mask')
    end
    
    %% Addaptive thresholding 
    C = 0.03; 
    filter_size = 15;
    I_nipple_cand = detect_nipple_cand_adaptive_thresh(I_gray, C, filter_size);
    if plot_results
        subplot(2, 4, 3), imshow(I_nipple_cand)
        title('Addapt. thresholded')
    end
    
    %% Nipple detction
    
    % exclude out of HBB
    I_nipple_cand = exclude_out_of_HBB(I_nipple_cand, I_body_mask);
    if plot_results
        subplot(2, 4, 4), imshow(I_nipple_cand)
        title('no-HBA excluded')
    end
    
    % exclude tb regions
    n_rows = size(I_gray, 1);
    Ht = 0.35 * n_rows;
    Hb = 0.3 * n_rows;
    I_nipple_cand = exclude_tb_regions(I_nipple_cand, Ht, Hb);
    if plot_results
        subplot(2, 4, 5), imshow(I_nipple_cand)
        title('top/bott. excluded')
    end
    
    % remove small regions
    N_p = 23;
    I_nipple_cand = exclude_small_regions(I_nipple_cand, I_gray, N_p);
    if plot_results
        subplot(2, 4, 6), imshow(I_nipple_cand)
        title('small regs. excluded')
    end
    
    % take max roundess and area
    [I_nipple_cand, left_nipple, right_nipple] = choose_max_roundess_max_area(I_nipple_cand, I_gray);
    if plot_results
        subplot(2, 4, 7), imshow(I_nipple_cand);
        title(' max round&area')
        hold on
        if size(left_nipple) > 0
            scatter(left_nipple(:, 1), left_nipple(:, 2), 'filled');
        end
        if size(right_nipple) > 0
            scatter(right_nipple(:, 1), right_nipple(:, 2), 'filled');
        end
        subplot(2, 4, 8), imshow(I)
        title('image + detection')
        hold on
        if size(left_nipple) > 0
            scatter(left_nipple(:, 1), left_nipple(:, 2), 'filled');
        end
        if size(right_nipple) > 0
            scatter(right_nipple(:, 1), right_nipple(:, 2), 'filled');
        end
    end

    I_res = I;
    if size(left_nipple) > 0
        I_res(round(left_nipple(:, 2))-3:round(left_nipple(:, 2))+3, round(left_nipple(:, 1))-3:round(left_nipple(:, 1))+3, :) = cat(3, 255*ones(7,7), zeros(7,7), 255*ones(7,7));
    end
    if size(right_nipple) > 0
        I_res(round(right_nipple(:, 2))-3:round(right_nipple(:, 2))+3, round(right_nipple(:, 1))-3:round(right_nipple(:, 1))+3, :) = cat(3, 255*ones(7,7), 255*ones(7,7), zeros(7,7));
    end
end