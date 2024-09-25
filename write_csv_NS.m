% write data to a csv file for easy use in JASP
% Column 1  BlockNr
% Column 2  TrialNr
% Column 3  Stimulus angry(0)/happy(1)
% Column 4  Report angry(0)/happy(1)
% Column 5  RT
% Column 6  Unique subject ID

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
        CSVLOG(r).RT = LOG.Block(B).Trial(T).RT;
        CSVLOG(r).SubID = LOG.SubID;
        r=r+1;
    end
end
LOGTABLE = struct2table(CSVLOG);

writetable(LOGTABLE, ...
    fullfile(StartFolder,DataFolder,HARDWARE.LogLabel,...
    [LOG.FileName '.csv']),'Delimiter', ','); 