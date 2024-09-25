% Process stimuli script for BH ----
%% Fixation
STIM.Fix.Rect = [0 0 ...
    STIM.Fix.Size*HARDWARE.Deg2Pix ... 
    STIM.Fix.Size*HARDWARE.Deg2Pix];
STIM.Fix.Rect = CenterRectOnPoint(STIM.Fix.Rect,...
    HARDWARE.CenterRect(1)/2,HARDWARE.CenterRect(2)/2);

%% Grid of positions ---
ORIGIN = HARDWARE.windowRect(1:2);
SCRSZ = [HARDWARE.windowRect(3)-HARDWARE.windowRect(1) ...
    HARDWARE.windowRect(4)-HARDWARE.windowRect(2)];
hSTEP = round(SCRSZ(1)/STIM.Positions.n(1));
vSTEP = round(SCRSZ(2)/STIM.Positions.n(2));
STARTPOINT = [round(ORIGIN(1)+(hSTEP/2)) ...
    round(ORIGIN(1)+(vSTEP/2))];
jitter = [-round(STIM.Positions.jitter*HARDWARE.Deg2Pix/2) ...
    round(STIM.Positions.jitter*HARDWARE.Deg2Pix/2)];

GridPositions = STARTPOINT;
for i = 1:STIM.Positions.n(1)-1
    GridPositions = [GridPositions;...
        STARTPOINT + [i*hSTEP 0]]; %#ok<*AGROW>
end
GridPositions0 = GridPositions;
for i = 1:STIM.Positions.n(2)-1
    GridPositions1 = GridPositions0;
    GridPositions1(:,2) = GridPositions0(:,2) + (i*vSTEP);
    GridPositions = [GridPositions; GridPositions1];
end
%disp('position grid made')

%% Preprocess images ---
for i = 1:length(STIM.images.loadcategories)
    catfld = STIM.images.loadcategories{i};
    f = dir(fullfile('images','RAFD',catfld,'*.jpg'));
    for j=1:length(f)
        STIM.images.files(i,j).cat = catfld;
        STIM.images.files(i,j).fld = f(j).folder;
        STIM.images.files(i,j).fn = f(j).name;
        img = imread(fullfile(f(j).folder,f(j).name));
        img = rgb2gray(img);
        cimg = imcrop(img, STIM.images.crop);
        STIM.images.files(i,j).texture = ...
            Screen('MakeTexture',HARDWARE.window,cimg);
        STIM.images.maxfile(i).nr = j;
    end
end

%% Preprocess some trialtypes ---
for TT = 1:length(STIM.TrialType)
    STIM.TrialType(TT).TRect = [0 0 ...
        STIM.TrialType(TT).TargetSize.*HARDWARE.Deg2Pix];
    STIM.TrialType(TT).DRect = [0 0 ...
        STIM.TrialType(TT).DistractorSize.*HARDWARE.Deg2Pix];

    % find cat-index
    ci = find(strcmp(STIM.images.loadcategories,...
        STIM.TrialType(TT).TargetFld)==1,1,'first');
    % get a file / texture
    switch STIM.TrialType(TT).Target
        case 'random'
            j = randi(STIM.images.maxfile(ci).nr);
            STIM.TrialType(TT).texture = ...
                STIM.images.files(ci,j).targtex;
        otherwise
            for j=1:STIM.images.maxfile(ci).nr
                if strcmp(STIM.images.files(ci,j).fn,...
                        STIM.TrialType(TT).Target)
                    STIM.TrialType(TT).targtex = ...
                        STIM.images.files(ci,j).targtex;
                end
            end
    end
    distidx = randperm(STIM.images.maxfile(ci).nr);
    STIM.TrialType(TT).disttex = [STIM.images.files(ci,...
        distidx(1:STIM.TrialType(TT).nDistract)).targtex];
end

%% Blocks and trials ---
BlockOrder = STIM.Exp.Blocks;
if STIM.Exp.RandomBlocks
    BlockOrder = Shuffle(BlockOrder);
end
STIM.nBlocks = length(BlockOrder);

for BB = 1:length(BlockOrder) 
    B = BlockOrder(BB);
    BLOCK(BB).BlockType = B; %#ok<*SAGROW>
    BLOCK(BB).TrialTypes = STIM.Block(B).TrialTypes;
    
    Trials = [];
    for T = 1:STIM.Block(B).TrialRepeats
        if STIM.Block(B).RandomTrialTypes
            Trials = [Trials BLOCK(BB).TrialTypes];
        else
            Trials = [Trials Shuffle(BLOCK(BB).TrialTypes)];
        end
    end
    BLOCK(BB).Trials = Trials;

    for T = 1:length(BLOCK(BB).Trials)
        TI = BLOCK(BB).Trials(T);
        BLOCK(BB).Trial(T).TT = TI;
        
        % jitter grid positions
        BLOCK(BB).Trial(T).Pos = GridPositions;
        for p = 1:size(BLOCK(BB).Trial(T).Pos,1)
            rshift = jitter(1)+randi(2*jitter(2));
            BLOCK(BB).Trial(T).Pos(p,1) = ...
                BLOCK(BB).Trial(T).Pos(p,1) + rshift;
            rshift = jitter(1)+randi(2*jitter(2));
            BLOCK(BB).Trial(T).Pos(p,2) = ...
                BLOCK(BB).Trial(T).Pos(p,2) + rshift;
        end
        
        % which position is target
        BLOCK(BB).Trial(T).TarPos = randi(...
            size(BLOCK(BB).Trial(T).Pos,1));

        % which positions are the distractors
        dpos =  1:size(BLOCK(BB).Trial(T).Pos,1);
        dpos(BLOCK(BB).Trial(T).TarPos) = [];
        dpos = Shuffle(dpos);

    end
end