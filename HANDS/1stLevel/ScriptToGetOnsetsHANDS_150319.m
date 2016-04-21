root_path = '/data/stress/Presentation_logfiles';
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

    fid = fopen(fullfile('/data/stress/Presentation_logfiles/', folder, '/HANDS_sce.log'));
    C = textscan(fid, '%s%s%s%s%n%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s','HeaderLines',5,'Delimiter','\t');
    fclose(fid);
    n=size(C,1);

    fid = fopen(fullfile('/data/stress/Presentation_logfiles/', folder, '/HANDS_log.txt'));
    D = textscan(fid, '%s%s%s%s%n','HeaderLines',1,'Delimiter','\t');
    fclose(fid);


    % Put in events to be modeled
    names{1,1}='Pain';
    names{1,2}='Nopain';
    names{1,3}='Rate';
    names{1,4}='MoveCursorLeft';
    names{1,5}='MoveCursorRight';
    names{1,6}='Respond';
    names{1,7}='Rest';

    % Say what the events were called in the logfile
    names2{1,1}='AllEvents';
    names2{1,2}='AllEvents';
    names2{1,3}='Rate';
    names2{1,4}='1';
    names2{1,5}='2';
    names2{1,6}='3';
    names2{1,7}='Rest';

    % Find time of first pulse (t = 0)
    puls=strfind(C{1,3},'Pulse');
    k=1;
    while isempty(puls{k}),
        k=k+1;
    end
    trigg=C{1,5}(k);

    % Change contents of rows containing "Pic2"
    for j=1:length(C{1,4}),
        if strcmp(C{1,4}{j}, 'Pic2') == 1
            C{1,4}{j} = 'AllEvents';
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

    if i == 9
        C{1,4}{337} = 'NA';
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    % Remove rows where button up was detected after the end of the trial
    for k = 2:length(C{1,4}),
        if ~isempty(strfind(C{1,4}{k}, '4')) && ~isempty(strfind(C{1,4}{k-1}, '3')),
            C{1,4}{k} = 'NA';
        end
    end

    % Find event onsets 
    for condnr = 1:size(names,2),

        % Generate output vector
        msd{condnr}=[];

        % Find the rows where events occur
        prcond{condnr}=strfind(C{1,4},names2{1,condnr});

        % Write rows to output vector
        for k=1:length(C{1,4}),
            if ~isempty(prcond{condnr}{k}),
                msd{condnr}=[msd{condnr} k];
            end
        end
    end

    % Find rows where rating questions end
    whereratingsend=[];
    for k=1:length(C{1,4}),
        if strcmp(C{1,4}{k}, '3'), 
            whereratingsend=[whereratingsend k];
        elseif strcmp(C{1,3}{k}, 'Quit'),
            for kk = k-1:-1:1
                if strcmp(C{1,4}{kk}, '3')
                    break;
                elseif strcmp(C{1,4}{kk}, 'Rate')
                    whereratingsend=[whereratingsend k];
                end
            end
        end
    end


    % Find rows where button presses end
    leftbuttonpressesend=strfind(C{1,4}, '4');
    rightbuttonpressesend=strfind(C{1,4}, '5');
    whereleftbuttonpressesend=[];
    whererightbuttonpressesend=[];
    for k=1:length(C{1,4}),
        if ~isempty(leftbuttonpressesend{k}),
            whereleftbuttonpressesend=[whereleftbuttonpressesend k];
        end
        if ~isempty(rightbuttonpressesend{k}),
            whererightbuttonpressesend=[whererightbuttonpressesend k];
        end
    end

    % Add rows where button presses end because the response is given (before
    % button is released)
    additionalleftbuttonpressesend = [];
    additionalrightbuttonpressesend =[];
    for k = 2:length(C{1,4}),
        if strcmp(C{1,4}{k}, '3'),
            % now we have reached a 3, k = 3, which means a "I rate"
            % 3 also means "I rate any buttons I have pressed right now"
            % look for any buttons still being pressed, that is, look for any 1
            % that have no 4, and look for 2 that have no 5
            % go from kk = k-1 to 1
            % if kk is 4, then 1 has been unpressed, so 3 is not an end of 1
            % if kk is 5, then 2 has been unpressed, so 3 is not an end of 2
            % if kk is 1, and we haven't found a 4, then this 3 (k) is an end of this 1 (kk)
            % if kk is 2, and we haven't found a 5, then this 3 (k) is an end of this 2 (kk)
            % if kk is 3, then we have reached a previous "I have rated", so stop
            found_4 = false;
            found_5 = false;
            for kk = k-1:-1:1,
                if (strcmp(C{1,4}{kk}, '3')),
                    break; % reached a previous 3 (rate), stop iterating backwards
                elseif (strcmp(C{1,4}{kk}, '4')),
                    found_4 = true; % reached an end left, ignore further start left
                elseif (strcmp(C{1,4}{kk}, '5')),
                    found_5 = true; % reached an end right, ignore further start rights
                elseif (strcmp(C{1,4}{kk}, '1') && ~found_4),
                    additionalleftbuttonpressesend = [additionalleftbuttonpressesend k];
                elseif (strcmp(C{1,4}{kk}, '2') && ~found_5),
                    additionalrightbuttonpressesend = [additionalrightbuttonpressesend k];
                end
            end
        end
    end
    whereleftbuttonpressesend = sort([whereleftbuttonpressesend additionalleftbuttonpressesend]);
    whererightbuttonpressesend = sort([whererightbuttonpressesend additionalrightbuttonpressesend]);

    % Add rows where button up was detected without a preceding button
    % press, i.e. when participants were already pressing the button at the
    % start of rating
    extraneousleftbuttonpressesbegin = [];
    extraneousrightbuttonpressesbegin =[];
    for k = 2:length(C{1,4}),
        if ~isempty(strfind(C{1,4}{k}, '4')) && ~isempty(strfind(C{1,4}{k-1}, 'Rate')),
            extraneousleftbuttonpressesbegin = [extraneousleftbuttonpressesbegin k];
        elseif ~isempty(strfind(C{1,4}{k}, '5')) && ~isempty(strfind(C{1,4}{k-1}, 'Rate')),
            extraneousrightbuttonpressesbegin = [extraneousrightbuttonpressesbegin k];
        end
    end
    msd{1,4} = sort([msd{1,4} extraneousleftbuttonpressesbegin]);
    msd{1,5} = sort([msd{1,5} extraneousrightbuttonpressesbegin]);

    % Find event onset times in seconds    
    for condnr=1:size(names,2),
        onsets{1,condnr}=(C{1,5}(msd{condnr}) - trigg)/10000;
    end

    % Remove aditional events that exixt in the .log file, but not in the
    % .sce file (when scan time un out before experiment was finished)

    if (size(onsets{1,1}) < 40)
        Size = size(onsets{1,1})
        D{1,1} = D{1,1}(1:Size)
    end

    % Define which events were "Pain" and which were "Nopain"
    onsets{1,1} = onsets{1,1}(strcmp(D{1,1}, 'Pain') == 1);
    onsets{1,2} = onsets{1,2}(strcmp(D{1,1}, 'No_Pain') == 1);

    % Define durations of stimuli, which were always shown for 3500 ms
    for condnr=1:2,
        durations{1,condnr}=repmat(3.5, (size(onsets{1,condnr})));
    end


    % Define durations of ratings (i.e. when the question was shown)
    durations{1,3}=((C{1,5}(whereratingsend) - trigg)/10000) - ((C{1,5}(msd{3}) - trigg)/10000);

    % Define durations of left and right button presses
    durations{1,4}=((C{1,5}(whereleftbuttonpressesend) - trigg)/10000) - ((C{1,5}(msd{4}) - trigg)/10000);
    durations{1,5}=((C{1,5}(whererightbuttonpressesend) - trigg)/10000) - ((C{1,5}(msd{5}) - trigg)/10000);

    % Define durations of centre button presses to end rating (we set it to 0)
    durations{1,6}=zeros(size(onsets{1,6}));

    %Define duration of PAUSE event, which was always shown for 15000ms
    durations{1,7}= 15.0;

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
    save(fullfile('/data/stress/HANDS_AGE/Onsetfiles_150319/', strcat(folder(1:3), '_', num2str(session), folder(4:10))),'names','onsets','durations');
end