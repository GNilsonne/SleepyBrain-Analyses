root_path = '/data/stress/ARROWS/ARROWS_Young2/45Slices';
folders = dir(root_path);
folders = folders(arrayfun(@(folders) ~strcmp(folders.name(1), '.'),folders));

for i = 1:length(folders)
    subject_session = folders(i).name;
    s = subject_session(1:3);
    subject = str2num(s);
    ses = subject_session(5);
    session = str2num(ses);
    LammMask = mean(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/1st_level_151208/con_0004.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/lOFCR_mask.nii')));
    a = size(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young2/45Slices/', subject_session, '/1st_level_151208/con_0004.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/lOFCR_mask.nii')));
   if i == 1   
        data = [subject, session, LammMask, a(2)];
   else
       data = [data; subject, session, LammMask, a(2)];
   end
end

root_path = '/data/stress/ARROWS/ARROWS_Young2/46Slices';
folders = dir(root_path);
folders = folders(arrayfun(@(folders) ~strcmp(folders.name(1), '.'),folders));

for i = 1:length(folders)
    subject_session = folders(i).name;
    s = subject_session(1:3);
    subject = str2num(s);
    ses = subject_session(5);
    session = str2num(ses);
    LammMask = mean(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/1st_level_151208/con_0004.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/lOFCR_mask.nii')));
    a = size(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Young2/46Slices/', subject_session, '/1st_level_151208/con_0004.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/lOFCR_mask.nii')));
   if i == 1
       data2 = [subject, session, LammMask, a(2)];
   else
       data2 = [data2; subject, session, LammMask, a(2)];
   end
end

root_path = '/data/stress/ARROWS/ARROWS_Old';
folders = dir(root_path);
folders = folders(arrayfun(@(folders) ~strcmp(folders.name(1), '.'),folders));

for i = 1:length(folders)
    subject_session = folders(i).name;
    s = subject_session(1:3);
    subject = str2num(s);
    ses = subject_session(5);
    session = str2num(ses);
    LammMask = mean(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/1st_level_151208/con_0004.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/lOFCR_mask.nii')));
    a = size(spm_summarise(strcat('/data/stress/ARROWS/ARROWS_Old/', subject_session, '/1st_level_151208/con_0004.nii'), struct('def', 'mask', 'spec', '/data/stress/ARROWS/RegionsOfInterest/lOFCR_mask.nii')));
   if i == 1
       data3 = [subject, session, LammMask, a(2)];
   else
       data3 = [data3; subject, session, LammMask, a(2)];
   end
end

data = [data; data2; data3];

cd /data/stress/ARROWS/Extractedfiles/
csvwrite('Data_lOFCR_downmaintain_160121', data)