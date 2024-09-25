% Process stimuli script for BH ----
%% Fixation
STIM.Fix.Rect = [0 0 ...
    STIM.Fix.Size*HARDWARE.Deg2Pix ... 
    STIM.Fix.Size*HARDWARE.Deg2Pix];
STIM.Fix.Rect = CenterRectOnPoint(STIM.Fix.Rect,...
    HARDWARE.CenterRect(1)/2,HARDWARE.CenterRect(2)/2);

%% Grid of positions ---
jitter = [-round(STIM.Positions.jitter*HARDWARE.Deg2Pix/2) ...
    round(STIM.Positions.jitter*HARDWARE.Deg2Pix/2)];
GridPositions = STIM.Positions.xy*HARDWARE.Deg2Pix;
GridPositions(:,1) = GridPositions(:,1) + ...
    ((HARDWARE.windowRect(3)-HARDWARE.windowRect(1))/2);
GridPositions(:,2) = GridPositions(:,2) + ...
    ((HARDWARE.windowRect(4)-HARDWARE.windowRect(2))/2);

%% Preprocess some trialtypes ---
for TT = 1:length(STIM.TrialType)
    STIM.TrialType(TT).TRect = [0 0 ...
        STIM.TrialType(TT).TargetSize.*HARDWARE.Deg2Pix];
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
            Trials = [Trials Shuffle(BLOCK(BB).TrialTypes)];
        else
            Trials = [Trials BLOCK(BB).TrialTypes];
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
    end
end