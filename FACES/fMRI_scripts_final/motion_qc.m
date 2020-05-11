function motion_qc(base, pt)
% function motion_qc(basedir, pt)
% 
% goes into a participants func directories and plots motion parameters.
% Translations on the left, rotations right. Basic paramters top,
% difference bottom. 

for sess =1:2
    cd([base '/ds201_R1.0.0/' pt])
    try
        %get params
        cd(['ses-' num2str(sess) '/func/'])
         mparams = textread(strtrim(ls('rp*.txt')));
        
        fh = figure;
        set(fh, 'Position', [100, 150, 1000, 400]);
        title(pwd);
       
        
        % sub pots of basic params and difference for scan-to-scan motion
        subplot(2,2,1); plot(mparams(:,1:3)); xlim([1 length(mparams)]); ylim([-2 2]);
        subplot(2,2,2); plot(mparams(:,4:6)); xlim([1 length(mparams)]); ylim([-2 2]);
        
        subplot(2,2,3); plot(diff(mparams(:,1:3))); xlim([1 length(mparams)]); ylim([-2 2]);
        subplot(2,2,4); plot(diff(mparams(:,4:6))); xlim([1 length(mparams)]); ylim([-2 2]);
        
        if(max(max(abs(diff(mparams(:,1:3)))))) > 2
            disp([ pt '_ses' num2str(sess)])
        end
        
        %save figure
        set(gcf,'PaperPositionMode','auto')
        print(fh, [base 'ds201_R1.0.0/motion_qc/motion_QC_' pt '_ses' num2str(sess) '.jpg'],'-djpeg', '-r0')
        
    end
end


close all



