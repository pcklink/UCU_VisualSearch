%% draw stimuli for BH
Bidx = B;
BTidx = BT;
Tidx = T;
TTidx = BLOCK(B).Trial(T).TT;

% target
xy = BLOCK(Bidx).Trial(Tidx).Pos(...
    BLOCK(Bidx).Trial(Tidx).TarPos,:);

switch STIM.TrialType(TTidx).Target
    case 'oval'
        Screen('FillOval',HARDWARE.window,...
            STIM.TrialType(TTidx).TargetColor.*HARDWARE.white,...
            CenterRectOnPoint(STIM.TrialType(TTidx).TRect,...
            xy(1),xy(2)));
    case 'rect'
        Screen('FillRect',HARDWARE.window,...
            STIM.TrialType(TTidx).TargetColor.*HARDWARE.white,...
            CenterRectOnPoint(STIM.TrialType(TTidx).TRect,...
            xy(1),xy(2)));
end
Screen('FillRect',HARDWARE.window,...
    STIM.ResponseBar.color.*HARDWARE.white,...
    CenterRectOnPoint(STIM.ResponseBar.rect{BLOCK(Bidx).Trial(Tidx).TBar},...
    xy(1),xy(2)));


% distractors
for di = 1:STIM.TrialType(TTidx).nDistract
    xy = BLOCK(Bidx).Trial(Tidx).Pos(...
        BLOCK(Bidx).Trial(Tidx).DistPos(di),:);
    switch BLOCK(Bidx).Trial(Tidx).DistType{di}    
        case 'oval'
            Screen('FillOval',HARDWARE.window,...
                BLOCK(Bidx).Trial(Tidx).DistColor{di}.*HARDWARE.white,...
                CenterRectOnPoint(STIM.TrialType(TTidx).DRect,...
                xy(1),xy(2)));
        case 'rect'
            Screen('FillRect',HARDWARE.window,...
                BLOCK(Bidx).Trial(Tidx).DistColor{di}.*HARDWARE.white,...
                CenterRectOnPoint(STIM.TrialType(TTidx).DRect,...
                xy(1),xy(2)));
    end
    Screen('FillRect',HARDWARE.window,...
        STIM.ResponseBar.color.*HARDWARE.white,...
        CenterRectOnPoint(STIM.ResponseBar.rect{BLOCK(Bidx).Trial(Tidx).DBar(di)},...
        xy(1),xy(2)));
end