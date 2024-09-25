%% draw stimuli for BH
Bidx = B;
BTidx = BT;
Tidx = T;
TTidx = BLOCK(B).Trial(T).TT;

% target
for p=1:size(BLOCK(Bidx).Trial(T).Pos,1)
    xy = BLOCK(Bidx).Trial(Tidx).Pos(p,:);

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
end