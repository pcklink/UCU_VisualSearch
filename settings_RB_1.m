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

HARDWARE.LogLabel = 'Reward'; % change this!
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
STIM.Positions.n = [6 4]; % [w h]
STIM.Positions.jitter = 2; % dva
STIM.ResponseBar.size = [0.2 0.5]; % NB! first value should be < second
STIM.ResponseBar.color = [0.5 0.5 0.5];

STIM.Trial.Timing.FixDur = 2; % s

STIM.TrialType(1).Target = 'oval'; %
STIM.TrialType(1).TargetSize = [2 2]; % [w h] dva
STIM.TrialType(1).TargetColor = [1 0 0];
STIM.TrialType(1).Distractor = {'rect'};
STIM.TrialType(1).DistractorSize = [2 2];
STIM.TrialType(1).DistractorColor = {[0 0 1]};
STIM.TrialType(1).nDistract = 23;
STIM.TrialType(1).SearchType = 'feature'; % conjunction/feature
STIM.TrialType(1).TrialText = ['Search red oval, report bar orientation\n\n'...
    'Horizontal=1 Vertical=0\n\n'...
    '>> Press any key to start <<']; % leave empty for none


STIM.TrialType(2).Target = 'rect'; 
STIM.TrialType(2).TargetSize = [2 2]; % dva
STIM.TrialType(2).TargetColor = [0 1 0];
STIM.TrialType(2).Distractor = {'rect','oval'};
STIM.TrialType(2).DistractorSize = [2 2];
STIM.TrialType(2).DistractorColor = {[1 0 0; 0 0 1] ,[1 0 0;0 1 0;0 0 1]};
% Distractor{1} can have have Color{1}, 
% Distractor{1} can have have Color{2}, etc
STIM.TrialType(2).nDistract = 23;
STIM.TrialType(2).SearchType = 'conjunction'; % conjunction/feature
STIM.TrialType(2).TrialText = ['Search green rectangle, report bar orientation\n\n'...
    'Horizontal=1 Vertical=0\n\n'...
    '>> Press any key to start <<']; % leave empty for none

STIM.Block(1).TrialTypes = [1 1];
STIM.Block(1).RandomTrialTypes = true;
STIM.Block(1).TrialRepeats = 10;
STIM.Block(1).TextStart = '>> Press any key to start <<'; 
STIM.Block(1).RepeatTextEveryNth = 5; 
STIM.Block(1).Questionnaire = []; % leave empty [] for non

STIM.Block(2).TrialTypes = [2 2];
STIM.Block(2).RandomTrialTypes = true;
STIM.Block(2).TrialRepeats = 10;
STIM.Block(2).TextStart = '>> Press any key to start <<';
STIM.Block(2).RepeatTextEveryNth = 5; 
STIM.Block(2).Questionnaire = []; % leave empty [] for non

% make sure instructions match this and Key1 = hori / Key2 = vert
STIM.Key1 = '1!'; % hori
STIM.Key2 = '0)'; % vert

STIM.Exp.Blocks = [2]; % you can do multiple repeats of the same Blocktype
STIM.Exp.RandomBlocks = true;
STIM.Exp.Questionnaire = []; % leave empty [] for non

STIM.Exp.FB.Do = false;
STIM.Exp.FB.Duration = 2; % seconds
STIM.Exp.FB.Text = {'Better than 90% of participants', ...
    'Far above average performance', 'Doing fantastic!'}; 
% you can add more, one will randomly be chosen.
STIM.Exp.FB.Type = 'Positive'; % Neutral/Positive
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
