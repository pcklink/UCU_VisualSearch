% write data to a csv file for easy use in JASP
% BlockNr
% TrialNr
% Feature/Conjunction
% FB type
% Target shape
% Target color
% Bar Orient H(1)/V(0)
% Response H(1)/V(0)
% RT
% Unique subject ID

r=1;
for B = 1:length(LOG.Block)
    for T = 1: length(LOG.Block(B).Trial)
        CSVLOG(r).Block = B; %#ok<*SAGROW>
        CSVLOG(r).Trial = T;
        BT = BLOCK(B).BlockType;
        TT = BLOCK(B).Trial(T).TT;
        CSVLOG(r).SearchType = ...
            STIM.TrialType(TT).SearchType;
        CSVLOG(r).FeedbackType = ...
            STIM.Exp.FB.Type;      
        CSVLOG(r).TargetShape = ...
            STIM.TrialType(TT).Target;
        CSVLOG(r).TargetColor = ...
            STIM.TrialType(TT).TargetColor;
        CSVLOG(r).BarOrient = ...
            -(BLOCK(B).Trial(T).TBar-2);
        CSVLOG(r).Response = LOG.Block(B).Trial(T).Resp;
        if BLOCK(B).Trial(T).TBar == 1 % vert
            CSVLOG(r).CorrResp = 0;
        elseif BLOCK(B).Trial(T).TBar == 2 % hor
            CSVLOG(r).CorrResp = 1;
        else
            CSVLOG(r).CorrResp = 9; % not possible [square rep bar]
        end
        CSVLOG(r).RT = LOG.Block(B).Trial(T).RT;
        CSVLOG(r).SubID = LOG.SubID;
        r=r+1;
    end
end
LOGTABLE = struct2table(CSVLOG);

writetable(LOGTABLE, ...
    fullfile(StartFolder,DataFolder,HARDWARE.LogLabel,...
    [LOG.FileName '.csv']),'Delimiter', ','); 