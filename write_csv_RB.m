% write data to a csv file for easy use in JASP
% Column 1  BlockNr
% Column 2  TrialNr
% Column 3  Feature/Conjunction
% Column 4  Target shape
% Column 5  Target color
% Column 6  Bar Orient H(1)/V(0)
% Column 7  Response H(1)/V(0)
% Column 8  RT
% Column 9  Unique subject ID

r=1;
for B = 1:length(LOG.Block)
    for T = 1: length(LOG.Block(B).Trial)
        CSVLOG(r).Block = B; %#ok<*SAGROW>
        CSVLOG(r).Trial = T;
        BT = BLOCK(B).BlockType;
        TT = BLOCK(B).Trial(T).TT;
        CSVLOG(r).SearchType = ...
            STIM.TrialType(TT).SearchType; 
        CSVLOG(r).TargetShape = ...
            STIM.TrialType(TT).Target;
        CSVLOG(r).TargetColor = ...
            STIM.TrialType(TT).TargetColor;
        CSVLOG(r).BarOrient = ...
            -(BLOCK(B).Trial(T).TBar-2);
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