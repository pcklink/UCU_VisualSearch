% Settings file for Ruby's reward experiment ==============================

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

HARDWARE.LogLabel = 'RewardAssociation'; % change this!
% will be used to generate subfolders for dfferent log types

%% General parameters ===================================================
GENERAL.Font = 'Arial';
GENERAL.FontSize = 20;
GENERAL.FontStyle = 0;

%% Stimulus features (basic) ============================================
% Background color
STIM.BackColor = [0.5 0.5 0.5]; % [R G B] range: 0-1

% Fixation size (in deg vis angle)
STIM.Fix.Size = .3;

% Fixation color
STIM.Fix.Color = [0 0 0]; % [R G B] range: 0-1

% Instruction text
STIM.WelcomeText = ['Report color as fast as possible\n\n'...
    'Red=1  Blue=6  Green=0\n\n'...
    '>> Press any key to start <<'];

%% Stimulus features (specific) =========================================
STIM.Positions.xy = 3*[-1 1; -1 -1; 1 -1; 1 1]; % [w h]
STIM.Positions.jitter = 1.5; % dva

STIM.Trial.Timing.FixDur = 1; % s
STIM.Trial.Timing.FixDurRand = [-0.5 1]; % s window around
STIM.Trial.Timing.MaxRT = 0.500; %s
STIM.Trial.Colors = {[1 0 0],[0 1 0],[0 0 1]};
STIM.Trial.ColName = {'Red','Green','Blue'};

STIM.TrialType(1).Target = 'oval'; %
STIM.TrialType(1).TargetSize = [2 2]; % [w h] dva
STIM.TrialType(1).TargetColor = STIM.Trial.Colors{1};
STIM.TrialType(1).Correct = 1;
STIM.TrialType(1).Reward = 500;

STIM.TrialType(2).Target = 'rect'; 
STIM.TrialType(2).TargetSize = [2 2]; % dva
STIM.TrialType(2).TargetColor = STIM.Trial.Colors{2};
STIM.TrialType(2).Correct = 2;
STIM.TrialType(2).Reward = 50;

STIM.TrialType(3).Target = 'rect'; 
STIM.TrialType(3).TargetSize = [2 2]; % dva
STIM.TrialType(3).TargetColor = STIM.Trial.Colors{3};
STIM.TrialType(3).Correct = 3;
STIM.TrialType(3).Reward = 5;

STIM.Block(1).TrialTypes = [1 1 1 2 2 2 3 3 3];
STIM.Block(1).RandomTrialTypes = true;
STIM.Block(1).TrialRepeats = 10;
STIM.Block(1).TextStart = [STIM.Trial.ColName{1} ' = 1  '...
    STIM.Trial.ColName{2} ' = 6  ' STIM.Trial.ColName{3} ' = 0\n\n'...
    '>> Press any key to start <<']; 
STIM.Block(1).RepeatTextEveryNth = 5; 

STIM.Block(2).TrialTypes = [1 2 3];
STIM.Block(2).RandomTrialTypes = true;
STIM.Block(2).TrialRepeats = 10;
STIM.Block(2).TextStart = STIM.Block(1).TextStart;
STIM.Block(2).RepeatTextEveryNth = 5; 

STIM.Key1 = '1!';
STIM.Key2 = '6^';
STIM.Key3 = '0)';

STIM.Exp.Blocks = [1 2]; % you can do multiple repeats of the same Blocktype
STIM.Exp.RandomBlocks = true;
STIM.Exp.FB.Duration = 2;

STIM.Exp.ITI = 1;