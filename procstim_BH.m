%% Process stimuli script for BH ----
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

STIM.ResponseBar.rect{1} = [0 0 STIM.ResponseBar.size*HARDWARE.Deg2Pix];
STIM.ResponseBar.rect{2} = [0 0 fliplr(STIM.ResponseBar.size)*HARDWARE.Deg2Pix];

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

%% Preprocess some trialtypes ---
for TT = 1:length(STIM.TrialType)
    STIM.TrialType(TT).TRect = [0 0 ...
        STIM.TrialType(TT).TargetSize.*HARDWARE.Deg2Pix];
    STIM.TrialType(TT).DRect = [0 0 ...
        STIM.TrialType(TT).DistractorSize.*HARDWARE.Deg2Pix];
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
        
        if dpos < STIM.TrialType(TI).nDistract
            error('More distractors than available locations.');
        else
            BLOCK(BB).Trial(T).DistPos = dpos(1:STIM.TrialType(TI).nDistract);
            for nd = 1:length(BLOCK(BB).Trial(T).DistPos)
                Dtype = randi(length(STIM.TrialType(TI).Distractor));
                BLOCK(BB).Trial(T).DistType{nd} = ...
                    STIM.TrialType(TI).Distractor{Dtype};
                BLOCK(BB).Trial(T).DistType{nd};
                Dcols = STIM.TrialType(TI).DistractorColor{Dtype};
                Dcol = randi(size(Dcols,1));
                BLOCK(BB).Trial(T).DistColor{nd} = ...
                    STIM.TrialType(TI).DistractorColor{Dtype}(Dcol,:);
            end
        end
        
        % define stimulus features
        % response bars
        BLOCK(BB).Trial(T).TBar = randi(2);
        BLOCK(BB).Trial(T).DBar = randi(2,[1 STIM.TrialType(TI).nDistract]);
    end
end