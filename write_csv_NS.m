% write data to a csv file for easy use in JASP
%  BlockNr
%  TrialNr
%  Stimulus angry(0)/happy(1)
%  Report angry(0)/happy(1)
%  Correct response (according to settings)
%  RT
%  Unique subject ID

r=1;
for B = 1:length(LOG.Block)
    for T = 1: length(LOG.Block(B).Trial)
        CSVLOG(r).Block = B; %#ok<*SAGROW>
        CSVLOG(r).Trial = T;
        BT = BLOCK(B).BlockType;
        TT = BLOCK(B).Trial(T).TT;
        CSVLOG(r).SearchType = ...
            STIM.TrialType(TT).TargetFld;
        CSVLOG(r).Response = LOG.Block(B).Trial(T).Resp;
        CSVLOG(r).CorrResp = ...
            STIM.TrialType(TT).CorrectResp;
        CSVLOG(r).RT = LOG.Block(B).Trial(T).RT;
        CSVLOG(r).SubID = LOG.SubID;
        r=r+1;
    end
end
LOGTABLE = struct2table(CSVLOG);

writetable(LOGTABLE, ...
    fullfile(StartFolder,DataFolder,HARDWARE.LogLabel,...
    [LOG.FileName '.csv']),'Delimiter', ','); 