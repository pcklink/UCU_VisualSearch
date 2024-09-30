% write data to a csv file for easy use in JASP
% BlockNr
% TrialNr
% Target shape
% Target color
% Target color index
% Response 
% RT
% Unique subject ID

r=1;
for B = 1:length(LOG.Block)
    for T = 1: length(LOG.Block(B).Trial)
        CSVLOG(r).Block = B; %#ok<*SAGROW>
        CSVLOG(r).Trial = T;
        BT = BLOCK(B).BlockType;
        TT = BLOCK(B).Trial(T).TT;
        CSVLOG(r).TargetShape = ...
            STIM.TrialType(TT).Target;
        CSVLOG(r).TargetColor = ...
            STIM.TrialType(TT).TargetColor;
        CSVLOG(r).CorrectResp = ...
            STIM.TrialType(TT).Correct;
        CSVLOG(r).Response = LOG.Block(B).Trial(T).Resp;
        CSVLOG(r).RT = LOG.Block(B).Trial(T).RT;
        CSVLOG(r).SubID = LOG.SubID;
        r=r+1;
    end
end
LOGTABLE = struct2table(CSVLOG);

writetable(LOGTABLE, ...
    fullfile(StartFolder,DataFolder,HARDWARE.LogLabel,...
    [LOG.FileName '.csv']),'Delimiter', ','); 