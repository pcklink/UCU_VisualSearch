% Process stimuli script for BH ----
BlockOrder = STIM.Exp.Blocks;
if STIM.Exp.RandomBlocks
    BlockOrder = Shuffle(BlockOrder);
end

for BB = 1:STIM.nBlocks 
    B = BlockOrder(BB);
    BLOCK(BB).BlockType = B;
    


    for T = 1:STIM.TrialsPerBlock
        




    end
end