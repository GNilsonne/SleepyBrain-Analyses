function sleep_amyg_rois

subs = [];
load sub_list
rimg = load_nii('E:\sleepdata\ds201_R0.9.0\ROIs\right_amyg.nii')
limg = load_nii('E:\sleepdata\ds201_R0.9.0\ROIs\left_amyg.nii')

R=double(rimg.img);
L=double(limg.img);

con_names ={'HA_AN';'HA_NE'; 'AN_NE';'HA';'AN'; 'NE'; 'HA+AN'; 'HA+AN+NE'};
Rout = zeros(size(subs,1),2,8);
Lout = zeros(size(subs,1),2,8);

for pdx = 1:size(subs,1)
    try
        pdx
        if sleepsess(pdx)==1
            s=[1 2];
        else
            s=[2 1];
        end
        for ses=1:2
            cd(['E:\sleepdata\ds201_R0.9.0\GLMs\glm_t-tests\sub-' num2str(subs(pdx)) '_' num2str(s(ses))]);
            m=load_nii('mask.nii');
            r_num(pdx,ses) = sum(m.img(r == 1));
            l_num(pdx,ses) = sum(m.img(l == 1));
            for cdx = 1:size(con_names,1)
                d =load_nii(['con_000' num2str(cdx) '.nii']);
                
                rdat = d.img(R == 1);
                rdat(rdat == NaN) = 0;
                Rout(pdx,ses,cdx) = mean(nonzeros(rdat));
                
                ldat = d.img(L == 1);
                ldat(ldat == NaN) = 0;
                Lout(pdx,ses,cdx) = mean(nonzeros(ldat));
            end
        end
    end
end

cd E:\sleepdata\ds201_R0.9.0\ROIs\amyg_csv

for cdx = 1:8
    csvwrite([con_names{cdx} '_sleepy_left.csv'], squeeze(Lout(:,1,cdx)));
    csvwrite([con_names{cdx} '_sleepy_right.csv'], squeeze(Rout(:,1,cdx)));
    
    csvwrite([con_names{cdx} '_awake_left.csv'], squeeze(Lout(:,2,cdx)));
    csvwrite([con_names{cdx} '_awake_right.csv'], squeeze(Rout(:,2,cdx)));
end


