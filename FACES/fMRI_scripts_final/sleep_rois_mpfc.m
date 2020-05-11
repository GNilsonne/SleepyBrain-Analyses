function sleep_rois_mpfc

subs = [];
load sub_list
mp = load_nii('E:\sleepdata\ds201_R0.9.0\ROIs\MPFC_roi.nii')

M=double(mp.img);


con_names ={'HA_AN';'HA_NE'; 'AN_NE';'HA';'AN'; 'NE'; 'HA+AN'; 'HA+AN+NE'};
Mout = zeros(size(subs,1),2,8);


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
            m_num(pdx,ses) = sum(m.img(M == 1));
            for cdx = 1:size(con_names,1)
                d =load_nii(['con_000' num2str(cdx) '.nii']);
                
                mdat = d.img(M == 1);
                mdat(isnan(mdat)) = 0;
                Mout(pdx,ses,cdx) = mean(nonzeros(mdat));
                
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


