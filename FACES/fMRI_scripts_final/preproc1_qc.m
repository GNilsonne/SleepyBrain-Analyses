function preproc1_qc(base, pt)
% goes into a participants directories and plots ua

disp(pt)
fh=figure;
set(fh, 'Position', [50, 0, 1200, 700]);

for sess =1:2
    cd([base '/ds201_R1.0.0/' pt])
    try
        cd(['ses-' num2str(sess) '/func/'])
        if ~isempty(ls(['c1*.nii']))
            
            ua = strtrim(ls('ua*.nii'));
            meanua = strtrim(ls('mean*.nii'));
            vdm = strtrim(ls('vdm*.nii'));
            
            tresh=0.7;
            c1dat=load_nii(ua);
            c1dat.img(c1dat.img > tresh) = c1dat.img(c1dat.img > tresh)+10;
            c2dat=load_nii(meanua);
            c2dat.img(c2dat.img > tresh) = c2dat.img(c2dat.img > tresh)+25;
            c3dat=load_nii(vdm);
            c3dat.img(c3dat.img > tresh) = c3dat.img(c3dat.img > tresh)+30;
            
            midslice = floor(size(c1dat.img,3)/2);
            
            % segmentations collapsed
            %pdat = (c3dat.img + c2dat.img);
            %pdat(pdat < tresh) = 0;
            
            fdat=[];
            for sdx = -25:25:150
                fdat = [fdat pdat(:,:,midslice+sdx)'];
            end
%             fdat(fdat==0) = NaN; 
            subplot(2,1,sess)
            imagesc(ua);
            colormap(fh,hot)
            title(pwd);
%             set(fh, 'Position', [50, 320-((sess-1)*300), 1200, 350]);
           
            
        end
    end
end

 set(gcf,'PaperPositionMode','auto')
 print(fh, [base '/ds201_R1.0.0/' pt '/segment_QC.jpg'],'-djpeg', '-r0')


