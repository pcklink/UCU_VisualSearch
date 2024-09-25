% Settings file for Ruby's experiment =====================================

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

HARDWARE.LogLabel = 'Emotion'; % change this!
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
STIM.WelcomeText = ['Blablabla\n\n'...
                    '>> Press any key to start <<'];

%% Stimulus features (specific) =========================================
STIM.Positions.n = [4 3]; % [w h]
STIM.Positions.jitter = 3; % dva

STIM.Trial.Timing.FixDur = 2; % s

STIM.images.loadcategories = {'neutral','happy','angry'};
STIM.images.crop = [120, 120, 450, 600];

% read stories from other file
emotion_stories;

STIM.TrialType(1).TargetFld = 'happy'; % image folder
STIM.TrialType(1).Target = 'random'; % pick a random image or specify filename
STIM.TrialType(1).TargetSize = [3 4]; % [w h] dva keep [1 1.33] aspect ratio
STIM.TrialType(1).Distractor = 'neutral';
STIM.TrialType(1).DistractorSize = [3 4];
STIM.TrialType(1).nDistract = 9;
STIM.TrialType(1).SearchType = 'emotion'; % conjunction/feature
STIM.TrialType(1).TrialText = [];

STIM.TrialType(2).TargetFld = 'angry'; % image folder
STIM.TrialType(2).Target = 'random'; % pick a random image or specify filename
STIM.TrialType(2).TargetSize = [3 4]; % dva
STIM.TrialType(2).Distractor = 'neutral';
STIM.TrialType(2).DistractorSize = [3 4];
STIM.TrialType(2).nDistract = 9;
STIM.TrialType(2).SearchType = 'emotion'; % conjunction/feature
STIM.TrialType(2).TrialText = [];

STIM.Block(1).TrialTypes = [1 1 1 1 1 1 1 2 2 2 2 2 2 2];
STIM.Block(1).RandomTrialTypes = true;
STIM.Block(1).TrialRepeats = 10;
STIM.Block(1).TextStory = STORY.happy(1).text;
STIM.Block(1).TextStart = ['Is there a HAPPY or ANGRY face?\n\n'...
    'Happy=1 Angry=0\n\n>> Press any key to start <<'];
STIM.Block(1).RepeatTextEveryNth = 500; 

STIM.Block(2).TrialTypes = [2];
STIM.Block(2).RandomTrialTypes = true;
STIM.Block(2).TrialRepeats = 10;
STIM.Block(2).TextStory = STORY.anger(1).text;
STIM.Block(2).TextStart = ['Is there a HAPPY or ANGRY face?\n\n'...
    'Happy=1 Angry=0\n\n>> Press any key to start <<'];
STIM.Block(2).RepeatTextEveryNth = 500; 

STIM.Key1 = '1!';
STIM.Key2 = '0)';

STIM.Exp.Blocks = [1]; % you can do multiple repeats of the same Blocktype
STIM.Exp.RandomBlocks = true;

STIM.Exp.FB.Do = false;
STIM.Exp.FB.Duration = 2; % seconds
STIM.Exp.FB.Text = {'Better than 90% of participants', ...
    'Far above average performance', 'Doing fantastic!'}; 
% you can add more, one will randomly be chosen.
STIM.Exp.FB.Type = 'Positive'; % Neutral/Positive
STIM.Exp.FB.StartAfter = 10; % only start giving feedback after this many trials
STIM.Exp.FB.EveryNthTrial = 5; 

STIM.Exp.ITI = 1;

%% Saving the data ======================================================
% here you can remove the actual images from the log to save space
STIM.RemoveImagesFromLog = false;