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
STIM.images.Database = 'RAFD';
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
STIM.TrialType(1).CorrectResp = 1; % NB! not checked but written in csv

STIM.TrialType(2).TargetFld = 'angry'; % image folder
STIM.TrialType(2).Target = 'random'; % pick a random image or specify filename
STIM.TrialType(2).TargetSize = [3 4]; % dva
STIM.TrialType(2).Distractor = 'neutral';
STIM.TrialType(2).DistractorSize = [3 4];
STIM.TrialType(2).nDistract = 9;
STIM.TrialType(2).SearchType = 'emotion'; % conjunction/feature
STIM.TrialType(2).TrialText = [];
STIM.TrialType(2).CorrectResp = 0; % NB! not checked but written in csv

STIM.Block(1).TrialTypes = [1 1 1 1 1 1 1 2 2 2 2 2 2 2];
STIM.Block(1).RandomTrialTypes = true;
STIM.Block(1).TrialRepeats = 10;
STIM.Block(1).TextStory = STORY.happy(1).text;
STIM.Block(1).TextStart = ['Is there a HAPPY or ANGRY face?\n\n'...
    'Happy=1 Angry=0\n\n>> Press any key to start <<'];
STIM.Block(1).RepeatTextEveryNth = 500; 
STIM.Block(1).Questionnaire = []; % leave empty [] for non

STIM.Block(2).TrialTypes = [2];
STIM.Block(2).RandomTrialTypes = true;
STIM.Block(2).TrialRepeats = 10;
STIM.Block(2).TextStory = STORY.anger(1).text;
STIM.Block(2).TextStart = ['Is there a HAPPY or ANGRY face?\n\n'...
    'Happy=1 Angry=0\n\n>> Press any key to start <<'];
STIM.Block(2).RepeatTextEveryNth = 500; 
STIM.Block(2).Questionnaire = []; % leave empty [] for non

STIM.Key1 = '1!';
STIM.Key2 = '0)';

STIM.Exp.Blocks = [1]; % you can do multiple repeats of the same Blocktype
STIM.Exp.RandomBlocks = true;
STIM.Exp.Questionnaire = []; % leave empty [] for non

STIM.Exp.FB.Do = false;
STIM.Exp.FB.Duration = 4; % seconds; use [] for 'until key-press'
STIM.Exp.FP.PersonalText = {'Hi!', 'Something personal'};
STIM.Exp.FB.Text = {'Better than 90% of participants', ...
    'Far above average performance', 'Doing fantastic!'}; 
% you can add more, one will randomly be chosen.
STIM.Exp.FB.Type = 'Positive'; % Neutral/Positive
STIM.Exp.FB.When = 'Block'; % 'Block' or 'Trials'
% these will only apply if When = 'Trials'
STIM.Exp.FB.StartAfter = 10; % only start giving feedback after this many trials
STIM.Exp.FB.EveryNthTrial = 5; 

STIM.Exp.ITI = 1;

%% Questionaire ========================================================
% all questions on 5pt likert scale sliders
STIM.Questionnaire(1).Question(1).QuestText = ['How badly do you want an answer?\n\n'...
    'Not at all  -----  Very much so'];
STIM.Questionnaire(1).Question(2).QuestText = ['What about now?\n\n'...
    'Not at all  -----  Very much so'];

STIM.Questionnaire(2).Question(1).QuestText = ['How badly do you want an answer?\n\n'...
    'Not at all  -----  Very much so'];
STIM.Questionnaire(2).Question(2).QuestText = ['What about now?\n\n'...
    'Not at all  -----  Very much so'];
