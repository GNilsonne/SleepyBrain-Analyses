function normalize_qc(base, pt)
% goes into a participants anat directories and plots normalize outputs for
% quick QC purposes. Plots a few mid slices to look for errors
% pltos different tissues in different colors

for sess =1:2
    cd([base '/ds201_R1.0.0/' pt])
    try
        cd(['ses-' num2str(sess) '/func/'])
        if ~isempty(ls(['sw*.nii']))
            
            c1 = strtrim(ls('sw*.nii'));
            d=load_nii(c1);
            dat=d.img(:,:,:,10);
            
            %Selected slices to display, rotated to look nice
            X=(mat2gray(rot90(flip(squeeze(dat(40,:,:))))));
            Y=(mat2gray(rot90(flip(squeeze(dat(:,40,:))))));
            X2=(mat2gray(rot90(flip(squeeze(dat(84-20,:,:))))));
            Y2=(mat2gray(rot90(flip(squeeze(dat(:,95-40,:))))));
            
            disp(pt)
            fh=figure;
            set(fh, 'Position', [100, 150, 1000, 250]);
            
            imagesc([X X2 Y Y2] );
            colormap(gray);
            
            title(pwd);
            
            %save figuer
            set(gcf,'PaperPositionMode','auto')
            print(fh, ['/data/stress/FACES_BIDS/ds201_R1.0.0/norm_qc/normalize_QC_' pt '_ses' num2str(sess) '.jpg'],'-djpeg', '-r0')
            
        end
    end
end

% close all



