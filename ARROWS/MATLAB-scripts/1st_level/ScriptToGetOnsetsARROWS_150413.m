root_path = '/data/stress/Presentation_logfiles/';
folders = dir(root_path);
folders = folders(arrayfun(@(folders) ~strcmp(folders.name(1), '.'),folders));



for i = 1:length(folders)
    subject_date = folders(i).name(1:10);
    if i > 1 && strcmp(folders(i).name(1:3), folders(i-1).name(1:3)) && str2num(folders(i).name(5:10)) > str2num(folders(i-1).name(5:10))
        session = 2;
    else
        session = 1;
    end
    folder = folders(i).name;

    fid = fopen(fullfile('/data/stress/Presentation_logfiles/', folder, '/ARROWS_sce.log'));
    C = textscan(fid, '%s%s%s%s%n%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s','HeaderLines',5,'Delimiter','\t');
    fclose(fid);
    n=size(C,1);

    fid = fopen(fullfile('/data/stress/Presentation_logfiles/', folder, '/ARROWS_log.txt'));
    D = textscan(fid, '%s%s%s%s%n','HeaderLines',1,'Delimiter','\t');
    fclose(fid);

    % Put in events to be modeled
    names{1,1}='MaintainCue';
    names{1,2}='UpNegCue';
    names{1,3}='DownNegCue';
    names{1,4}='MaintainNegPic';
    names{1,5}='UpNegPic';
    names{1,6}='DownNegPic';
    names{1,7}='MaintainNeuPic';
    names{1,8}='Rate';
    names{1,9}='MoveCursorLeft';
    names{1,10}='Respond';
    names{1,11}='MoveCursorRight';
    names{1,12}='Rest';
    names{1,13}='Instruction';

    % Say what the events were called in the logfile
    names2{1,1}='AllCues';
    names2{1,2}='AllCues';
    names2{1,3}='AllCues';
    names2{1,4}='AllEvents';
    names2{1,5}='AllEvents';
    names2{1,6}='AllEvents';
    names2{1,7}='AllEvents';
    names2{1,8}='Blank';
    names2{1,9}='1';
    names2{1,10}='2';
    names2{1,11}='3';
    names2{1,12}='Rest';
    names2{1,13}='Instruction';

    % Find time of first pulse (t = 0)
    puls=strfind(C{1,3},'Pulse');
    k=1;
    while isempty(puls{k}),
        k=k+1;
    end
    trigg=C{1,5}(k);

    % Change contents of rows containing "Pic2"
    for j=1:length(C{1,4}),
        if strcmp(C{1,4}{j}, 'Pic') == 1
            C{1,4}{j} = 'AllEvents';
        end
    end  

        % Change contents of rows containing "Pic2"
    for j=1:length(C{1,4}),
        if strcmp(C{1,4}{j}, 'Cue') == 1
            C{1,4}{j} = 'AllCues';
        end
    end 
    
    % Remove rows containing "Pulse" or "115", so that additional button up 
    % events can be detected as following straight after "Rate" events
    rowstokeep = cellfun('isempty', regexpi(C{1,4}, ('Pulse|115')));
    if length(C{1,5}) < length(C{1,4}),
        C{1,5} = vertcat(C{1,5}, zeros(length(C{1,4}) - length(C{1,5})));
    end
    C{1,3} = C{1,3}(rowstokeep);
    C{1,4} = C{1,4}(rowstokeep);
    C{1,5} = C{1,5}(rowstokeep);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Only for participants with events mis-registered before rating event:
    % Remove those events one by one

    %if i == 9
     %   C{1,4}{337} = 'NA';
    %end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    % Remove rows where button up was detected after the end of the trial
    %for k = 2:length(C{1,4}),
     %   if ~isempty(strfind(C{1,4}{k}, '4')) && ~isempty(strfind(C{1,4}{k-1}, '3')),
      %      C{1,4}{k} = 'NA';
       % end
    %end

    % Find event onsets 
    for condnr = 1:size(names,2),

        % Generate output vector
        msd{condnr}=[];

        % Find the rows where events occur
        prcond{condnr}=strfind(C{1,4},names2{1,condnr});

        % Write rows to output vector
        for k=1:length(C{1,4}),
            if ~isempty(prcond{condnr}{k}),
                if condnr == 8,
                    for kk=k+1:length(C{1,4}),
                        if strcmp(C{1,4}{kk}, 'Response'),
                            msd{condnr}=[msd{condnr} kk];
                            break
                        end
                    end
                else
                    msd{condnr}=[msd{condnr} k];
                end
            end
        end
    end
    % Check later
    % Find rows where rating questions end
%     whereratingsend=[];
%     for k=1:length(C{1,4}),
%         if strcmp(C{1,4}{k}, '2'), 
%             whereratingsend=[whereratingsend k];
%         elseif strcmp(C{1,3}{k}, 'Quit'),
%             for kk = k-1:-1:1
%                 if strcmp(C{1,4}{kk}, '2')
%                     break;
%                 elseif strcmp(C{1,4}{kk}, 'Rate')
%                     whereratingsend=[whereratingsend k];
%                 end
%             end
%         end
%     end

    % Find rows where rating questions end
    ratingsend=strfind(C{1,4}, '2');
    whereratingsend=[];
    for k=1:length(C{1,4}),
        if ~isempty(ratingsend{k}),
            whereratingsend=[whereratingsend k];
        end
    end


   
    % Find event onset times in seconds    
    for condnr=1:size(names,2),
        onsets{1,condnr}=(C{1,5}(msd{condnr}) - trigg)/10000;
    end

    while (size(onsets{1,1}) < 60)
        onsets{1,1}(size(onsets{1,1})+1) = NaN;
    end
    while (size(onsets{1,2}) < 60)
        onsets{1,2}(size(onsets{1,2})+1) = NaN;
    end


    % Define which cues were which instruction type 
    onsets{1,1} = onsets{1,1}(strcmp(D{1,1}, '1') | strcmp(D{1,1}, '4'));
    onsets{1,2} = onsets{1,2}(strcmp(D{1,1}, '2') == 1);
    onsets{1,3} = onsets{1,3}(strcmp(D{1,1}, '3') == 1);
    
    % Define which pictures were which type 
    onsets{1,4} = onsets{1,4}(strcmp(D{1,1}, '1') == 1);
    onsets{1,5} = onsets{1,5}(strcmp(D{1,1}, '2') == 1);
    onsets{1,6} = onsets{1,6}(strcmp(D{1,1}, '3') == 1);
    onsets{1,7} = onsets{1,7}(strcmp(D{1,1}, '4') == 1);
    
    % Define durations of cues, which were always shown for 2000 ms
    for condnr=1:3,
        durations{1,condnr}=repmat(2.0, (size(onsets{1,condnr})));
    end
    
       % Define durations of stimuli, which were always shown for 5000 ms
    for condnr=4:7,
        durations{1,condnr}=repmat(5.0, (size(onsets{1,condnr})));
    end


    % Define durations of ratings (i.e. when the question was shown)
    durations{1,8}=((C{1,5}(whereratingsend) - trigg)/10000) - ((C{1,5}(msd{8}) - trigg)/10000);

    % Define durations of button presses to end rating (we set it to 0)
    durations{1,9}=zeros(size(onsets{1,9}));
    durations{1,10}=zeros(size(onsets{1,10}));
    durations{1,11}=zeros(size(onsets{1,11}));
    
    %Define duration of PAUSE event, which was always shown for 15000ms
    durations{1,12}= 15.0;
    
    %Define duration of instruction event, which was always shown for 10000ms
    durations{1,13}= 10.0;

    for k = 1:size(onsets, 2)
        if size(onsets{1,k}) == 0
            onsets{1,k} = [0];
        end
    end

    for k = 1:size(durations, 2)
        if size(durations{1,k}) == 0
            durations{1,k} = [0];
        end
    end

    % Write file
    save(fullfile('/data/stress/ARROWS/Onsetfiles_All/', strcat(folder(1:3), '_', num2str(session), folder(4:10))),'names','onsets','durations');
end