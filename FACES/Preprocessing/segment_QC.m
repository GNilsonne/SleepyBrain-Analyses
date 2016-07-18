function segment_QC(base, pt)
% goes into a participants anat directories and plots segment outputs for
% quick QC purposes. Plots a few mid slices to look for errors
% pltos different tissues in different colors

disp(pt)
fh=figure;
set(fh, 'Position', [50, 0, 1200, 700]);

for sess =1:2
    cd([base '\ds201_R0.9.0\' pt])
    try
        cd(['ses-' num2str(sess) '\anat\'])
        if ~isempty(ls(['c1*.nii']))
            
            c1 = ls('c1*.nii');
            c2 = ls('c2*.nii');
            c3 = ls('c3*.nii');
            
            tresh=0.7;
            c1dat=load_nii(c1);
            c1dat.img(c1dat.img > tresh) = c1dat.img(c1dat.img > tresh)+10;
            c2dat=load_nii(c2);
            c2dat.img(c2dat.img > tresh) = c2dat.img(c2dat.img > tresh)+25;
            c3dat=load_nii(c3);
            c3dat.img(c3dat.img > tresh) = c3dat.img(c3dat.img > tresh)+30;
            
            midslice = floor(size(c1dat.img,3)/2);
            
            % segmentations collapsed
            pdat = (c1dat.img + c2dat.img + c3dat.img);
            pdat(pdat < tresh) = 0;
            
            fdat=[];
            for sdx = -25:25:150
                fdat = [fdat pdat(:,:,midslice+sdx)'];
            end
%             fdat(fdat==0) = NaN; 
            subplot(2,1,sess)
            imagesc(fdat);
            colormap(fh,hot)
            title(pwd);
%             set(fh, 'Position', [50, 320-((sess-1)*300), 1200, 350]);
           
            
        end
    end
end

 set(gcf,'PaperPositionMode','auto')
 print(fh, [base '\ds201_R0.9.0\' pt '\segment_QC.jpg'],'-djpeg', '-r0')


