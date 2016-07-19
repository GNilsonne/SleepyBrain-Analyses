root_path = '/data/stress/HANDS_AGE/45Slices';
folders = dir(root_path);
folders = folders(arrayfun(@(folders) ~strcmp(folders.name(1), '.'),folders));

for i = 1:length(folders)
    subject_session = folders(i).name;
    s = subject_session(1:3);
    subject = str2num(s);
    ses = subject_session(5);
    session = str2num(ses);
    LammMask = mean(spm_summarise(strcat('/data/stress/HANDS_AGE/45Slices/', subject_session, '/1st_level_150320/con_0003.nii'), struct('def', 'mask', 'spec', '/data/stress/HANDS_AGE/ROIsFromLamm/pic_p_np_00001.nii')));

   if i == 1
       data = [subject, session, LammMask];
   else
       data = [data; subject, session, LammMask];
   end
end

root_path = '/data/stress/HANDS_AGE/46Slices';
folders = dir(root_path);
folders = folders(arrayfun(@(folders) ~strcmp(folders.name(1), '.'),folders));

for i = 1:length(folders)
    subject_session = folders(i).name;
    s = subject_session(1:3);
    subject = str2num(s);
    ses = subject_session(5);
    session = str2num(ses);
    LammMask = mean(spm_summarise(strcat('/data/stress/HANDS_AGE/46Slices/', subject_session, '/1st_level_150320/con_0003.nii'), struct('def', 'sphere', 'spec', 10, 'xyz', [-2 23 40]')));

   if i == 1
       data2 = [subject, session, LammMask];
   else
       data2 = [data2; subject, session, LammMask];
   end
end

data = [data; data2];

cd /data/stress/HANDS_AGE/ExtractedData_150622/
csvwrite('Data_MaskFromLamm_pvsnp_150622', data)