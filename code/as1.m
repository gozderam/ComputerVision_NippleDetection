test_data_path = 'assignment1/test/';

% step by step example
I = imread(strcat(test_data_path, 'IR_3635.png'));
nipple_g(I, true);

% test for test set
files = dir(fullfile(test_data_path, '*.png'));
for K = 1 : length(files)
  I = imread(strcat(test_data_path, files(K).name));
  I_res = nipple_g(I, false);
  subplot(2, 3, K), imshow(I_res)
end