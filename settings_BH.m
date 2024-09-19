% Settings file for Bella's experiment ====================================
% Self-efficacy manipulated through feedback
% Feature search and Conjunction search

%% Hardware variables ===================================================
% Some definitions to specify hardware specifics
HARDWARE.Location = 'UU_ExpPsych';

% This switch allows expansion to multiple locations
% -- check these parameters carefully --
switch HARDWARE.Location
    case 'UU_ExpPsych'
        % Participant distance from screen (mm)
        HARDWARE.DistFromScreen = 570;
end

HARDWARE.LogLabel = 'SelfEfficacy'; % change this!
% will be used to generate subfolders for dfferent log types

%% General parameters ===================================================
GENERAL.Font = 'Arial';
GENERAL.FontSize = 16;
GENERAL.FontStyle = 0;

%% Stimulus features (basic) ============================================
% Background color
STIM.BackColor = [0.5 0.5 0.5]; % [R G B] range: 0-1

% Fixation size (in deg vis angle)
STIM.Fix.Size = .3;

% Fixation color
STIM.Fix.Color = [0 0 0]; % [R G B] range: 0-1

% Instruction text
STIM.WelcomeText = ['Blablabla\n\n'...
                    '>> Press any key to start <<'];

%% Stimulus features (specific) =========================================
STIM.FB.positive = 'You are faster than average\n Well done!';
STIM.FB.neutral = 'Keep going';

STIM.FB.EveryNthTrial = 5; % leave [] for never

STIM.Positions.n = [8 5]; % [w h]
STIM.Positions.jitter = 1; % dva

STIM.Trial.Timing.FixDur = 1; % s

STIM.TrialType(1).Target = 'rect'; 
STIM.TrialType(1).TargetSize = [1 3]; % dva
STIM.TrialType(1).TargetColor = [1 1 1];
STIM.TrialType(1).TargetOri = 45;
STIM.TrialType(1).TargetPresent = true;
STIM.TrialType(1).Distractor = 'rect';
STIM.TrialType(1).DistractorOri = -45;
STIM.TrialType(1).DistractorSize = [1 3];
STIM.TrialType(1).DistractorColor = {[0 0 0]};
STIM.TrialType(1).nDistract = 39;
STIM.TrialType(1).SearchType = 'feature'; % conjunction/feature

STIM.TrialType(2).Target = 'rect'; 
STIM.TrialType(2).TargetSize = [1 3]; % dva
STIM.TrialType(2).TargetColor = [1 1 1];
STIM.TrialType(2).TargetOri = 45;
STIM.TrialType(2).TargetPresent = true;
STIM.TrialType(2).Distractor = 'rect';
STIM.TrialType(2).DistractorOri = [-45 45] ;
STIM.TrialType(2).DistractorSize = [1 3];
STIM.TrialType(2).DistractorColor = {[0 0 0;1 1 1],[0 0 0]};
STIM.TrialType(2).nDistract = 39;
STIM.TrialType(2).SearchType = 'conjunction'; % conjunction/feature

STIM.Block(1).TrialTypes = [1 2];
STIM.Block(1).RandomTrialTypes = true;
STIM.Block(1).TrialRepeats = 10;
STIM.Block(1).TextStart = ['White left present [Y/N]?\n\n'...
                    '>> Press any key to start <<'];

STIM.Key1 = 'y';
STIM.Key2 = 'n';

STIM.Exp.Blocks = 1; % you can do multiple repeats of the same Blocktype
STIM.Exp.RandomBlocks = true;

%% Saving the data ======================================================
% here you can remove the actual images from the log to save space
STIM.RemoveImagesFromLog = false;