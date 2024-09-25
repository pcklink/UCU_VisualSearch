%% draw stimuli for BH
Bidx = B;
BTidx = BT;
Tidx = T;
TTidx = BLOCK(B).Trial(T).TT;

STIM.TrialType(TTidx).TRect = [0 0 ...
    STIM.TrialType(TTidx).TargetSize.*HARDWARE.Deg2Pix];
STIM.TrialType(TTidx).DRect = [0 0 ...
    STIM.TrialType(TTidx).DistractorSize.*HARDWARE.Deg2Pix];

% find cat-index
ci = find(strcmp(STIM.images.loadcategories,...
    STIM.TrialType(TTidx).TargetFld)==1,1,'first');
% get a file / texture
switch STIM.TrialType(TTidx).Target
    case 'random'
        j = randi(STIM.images.maxfile(ci).nr);
        STIM.TrialType(TTidx).targtex = ...
            STIM.images.files(ci,j).texture;
        targid = STIM.images.files(ci,j).fid;
    otherwise
        for j=1:STIM.images.maxfile(ci).nr
            if strcmp(STIM.images.files(ci,j).fn,...
                    STIM.TrialType(TTidx).Target)
                STIM.TrialType(TTidx).targtex = ...
                    STIM.images.files(ci,j).texture;
                targid = STIM.images.files(ci,j).fid;
            end
        end
end
ci = find(strcmp(STIM.images.loadcategories,...
    STIM.TrialType(TTidx).Distractor)==1,1,'first');
distidx = randperm(STIM.images.maxfile(ci).nr);

removedist =[];
for i=1:size(STIM.images.files,2)
    if strcmp(STIM.images.files(ci,i).fid, targid)
        removedist = i;
    end
end
distidx(removedist)=[]; % remove target identity from distractors
STIM.TrialType(TTidx).disttex = [STIM.images.files(ci,...
    distidx(1:STIM.TrialType(TTidx).nDistract)).texture];

% target
xy = BLOCK(Bidx).Trial(Tidx).Pos(...
    BLOCK(Bidx).Trial(Tidx).TarPos,:);

Screen('DrawTexture',HARDWARE.window,...
    STIM.TrialType(TTidx).targtex, [],...
    CenterRectOnPoint(STIM.TrialType(TTidx).TRect,...
    xy(1),xy(2)));
Screen('FrameRect',HARDWARE.window,[0 0 0],...
    CenterRectOnPoint(STIM.TrialType(TTidx).TRect,xy(1),xy(2)),2)

% distractors
for di = 1:STIM.TrialType(TTidx).nDistract
    xy = BLOCK(Bidx).Trial(Tidx).DistPos(di,:);

    Screen('DrawTexture',HARDWARE.window,...
        STIM.TrialType(TTidx).disttex(di), [],...
        CenterRectOnPoint(STIM.TrialType(TTidx).DRect,...
        xy(1),xy(2)));
    Screen('FrameRect',HARDWARE.window,[0 0 0],...
        CenterRectOnPoint(STIM.TrialType(TTidx).DRect,xy(1),xy(2)),2)
end