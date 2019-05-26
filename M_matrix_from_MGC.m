% function M_matrix = M_matrix_from_MGC(all_images)
%   Detailed explanation goes here
all_images = uint8(zeros(75,133,3,36));
imagefiles = dir('processed image/*.png');
for ii=1:36
    current_file_name = ['processed image/', imagefiles(ii).name];
    current_image = imread(current_file_name);
%     current_image = rgb2gray(current_image);
    all_images( :, :, :, ii) = current_image;
end
%%
threshold = 930000000;
% the number of rows
r = size(all_images,1);
% the number of columuns
c = size(all_images,2);
% the number of channels
d = size(all_images,3);
% the number of images
n = size(all_images,4);

M_matrix = ones(n,n,4);

for i = 1:n
    for j = 1:n
        
        % The disimilarity between the picture and itself is 0.
        if i==j
        M_matrix(i,j,:) = NaN;
        end
        
        % the top right part of the M_matrix
        if i<j
            % the D-1 shows the scores of L,L
        M_matrix(i,j,1) = MGCfunction(reshape(all_images(:,1,:,i),r,d),reshape(all_images(:,1,:,j),r,d));
            % the D-2 shows the scores of L,R
        M_matrix(i,j,2) = MGCfunction(reshape(all_images(:,1,:,i),r,d),reshape(all_images(:,c,:,j),r,d));
            % the D-1 shows the scores of R,L
        M_matrix(i,j,3) = MGCfunction(reshape(all_images(:,c,:,i),r,d),reshape(all_images(:,1,:,j),r,d));
            % the D-1 shows the scores of R,R
        M_matrix(i,j,4) = MGCfunction(reshape(all_images(:,c,:,i),r,d),reshape(all_images(:,c,:,j),r,d));
        end
        
        % the bottom left part of the M_matrix
        if i>j
            % the D-1 shows the scores of T,T
        M_matrix(i,j,1) = MGCfunction(reshape(all_images(1,:,:,i),c,d),reshape(all_images(1,:,:,j),c,d));
            % the D-2 shows the scores of T,B
        M_matrix(i,j,2) = MGCfunction(reshape(all_images(1,:,:,i),c,d),reshape(all_images(r,:,:,j),c,d));
            % the D-3 shows the scores of B,T
        M_matrix(i,j,3) = MGCfunction(reshape(all_images(r,:,:,i),c,d),reshape(all_images(1,:,:,j),c,d));
            % the D-4 shows the scores of B,B
        M_matrix(i,j,4) = MGCfunction(reshape(all_images(r,:,:,i),c,d),reshape(all_images(r,:,:,j),c,d));
        end
    end
end
%%

%%
M_matrix(M_matrix>threshold) = NaN;
M_matrix(M_matrix<0) = NaN;
%%
a = reshape(M_matrix,36*36*4,1);
a_sort = sort(a);
% %%
% a = M_matrix(:,:,1);
% end