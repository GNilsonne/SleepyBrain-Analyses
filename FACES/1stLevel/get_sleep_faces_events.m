function ons = get_sleep_faces_events(pt,ses)
% This script reads Presentation logfiles and creates Matlab files with
% event onsets and durations for use in SPM.

cd(['e:\sleepdata\PresentationLogFiles\'])
file = [pwd '\' ls([num2str(pt)   '_' num2str(ses) '*Presentationlogfiles']) '/FACES_sce.log']

fid = fopen(file);
C = textscan(fid, '%s%s%s%s%n%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s','HeaderLines',5,'Delimiter','\t');
fclose(fid);
n=size(C,1);

% Put in events to be modeled
names{1,1}='Happy';
names{1,2}='Angry';
names{1,3}='Neutral';
names{1,4}='Rate';
names{1,5}='MoveCursorLeft';
names{1,6}='MoveCursorRight';
names{1,7}='Respond';
names{1,8}='Rest';

% Say what the events were called in the logfile
names2{1,1}='happy';
names2{1,2}='angry';
names2{1,3}='neutral';
names2{1,4}='Rating';
names2{1,5}='1';
names2{1,6}='2';
names2{1,7}='3';
names2{1,8}='Rest';

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

% Remove rows where button up was detected after the end of the trial
for k = 2:length(C{1,4}),
    if ~isempty(strfind(C{1,4}{k}, '4')) && ~isempty(strfind(C{1,4}{k-1}, '3')),
        C{1,4}{k} = 'NA';
    end
end

% Loop over conditions to be modeled
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
ratingsend=strfind(C{1,4}, '3');
whereratingsend=[];
for k=1:length(C{1,4}),
    if ~isempty(ratingsend{k}),
        whereratingsend=[whereratingsend k];
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
    if ~isempty(strfind(C{1,4}{k}, '3')) && ~isempty(strfind(C{1,4}{k-1}, '1')),
        additionalleftbuttonpressesend = [additionalleftbuttonpressesend k];
    elseif ~isempty(strfind(C{1,4}{k}, '3')) && ~isempty(strfind(C{1,4}{k-1}, '2')),
        additionalrightbuttonpressesend = [additionalrightbuttonpressesend k];
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

% Define durations of face stimuli, which were always shown for 500 ms
for condnr=1:3,
    durations{1,condnr}=repmat(0.5, (size(onsets{1,condnr})));
end

% Define durations of ratings (i.e. when the question was shown)
durations{1,4}=((C{1,5}(whereratingsend) - trigg)/10000) - ((C{1,5}(msd{4}) - trigg)/10000);

% Define durations of left and right button presses
durations{1,5}=((C{1,5}(whereleftbuttonpressesend) - trigg)/10000) - ((C{1,5}(msd{5}) - trigg)/10000);
durations{1,6}=((C{1,5}(whererightbuttonpressesend) - trigg)/10000) - ((C{1,5}(msd{6}) - trigg)/10000);

% Define durations of centre button presses to end rating (we set it to 0)
durations{1,7}=zeros(size(onsets{1,7}));

%Define duration of PAUSE event, which was always shown for 15000ms
durations{1,8}= 15.0;

n=1
for idx = 1:7
    ons(n:n+size(onsets{idx},1)-1,1)=1;
    ons(n:n+size(onsets{idx},1)-1,2)=idx;
    ons(n:n+size(onsets{idx},1)-1,3) = onsets{idx};
    ons(n:n+size(onsets{idx},1)-1,4) = durations{idx};
    n = n+size(onsets{idx},1);
end


