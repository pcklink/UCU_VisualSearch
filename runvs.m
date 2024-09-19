function runvs(student,debug)

%% PTB3 script for ======================================================
% VISUAL SEARCH experiments
% Chris Klink: p.c.klink@uu.nl

% Response: choose one of two keys (learn cue-response)

% In short:
% - Instruction appears
% - Search array appears
% - Subject reports as soon as possible
% - Interspersed info possible
% - Block designs
% - Three variants ('BH'/'NS'/'RB')
%==========================================================================
clc; QuitScript = false;
warning off; %#ok<*WNOFF>
if nargin < 2
    debug = false;
    if nargin < 1
        fprintf('Please define an experiment type\n');
        QuitScript = true;
    end
end
DebugRect = [0 0 1024 768];

%% ----------------------------------------------------------------------
switch student
    case 'BH'
        fprintf('Welcome at Bella''s experiment\n')
    case 'NS'
        fprintf('Welcome at Nicole''s experiment\n')
    case 'RB'
        fprintf('Welcome at Ruby''s experiment\n')
    otherwise
        fprintf('Unknown student code. Typo?\n');
        QuitScript = true;
end

%% Read in variables ----------------------------------------------------
% First get the settings
[RunPath,~,~] = fileparts(mfilename('fullpath'));
SettingsFile = ['settings_' student];
run(fullfile(RunPath, SettingsFile));

%% Create data folder if it doesn't exist yet and go there --------------
DataFolder = ['Data_' student];
StartFolder = pwd;
[~,~] = mkdir(fullfile(StartFolder,DataFolder));

%% Run the experiment ---------------------------------------------------
try
    %% Escape upon quitscript -------------------------------------------
    if QuitScript
        error('Experiment was exited before it ended\n');
    end

    %% Initialize -------------------------------------------------------
    if Debug
        LOG.Subject = 'TEST';
        LOG.Gender = 'x';
        LOG.Age = 0;
        LOG.Handedness = 'R';
        LOG.DateTimeStr = datestr(datetime('now'), 'yyyyMMdd_HHmm'); %#ok<*DATST>
    else
        % Get registration info
        LOG.Subject = [];
        % Get subject info
        while isempty(LOG.Subject)
            INFO = inputdlg({'Subject Initials', ...
                'Gender (m/f/x)', 'Age', 'Left(L)/Right(R) handed'},...
                'Subject',1,{'XX','x','0','R'},'on');
            LOG.Subject = INFO{1};
            LOG.Gender = INFO{2};
            LOG.Age = str2double(INFO{3});
            LOG.Handedness = INFO{4};
            % Get timestring id
            LOG.DateTimeStr = datestr(datetime('now'), 'yyyymmdd_HHMM');
        end
    end

    % Reduce PTB3 verbosity
    oldLevel = Screen('Preference', 'Verbosity', 0); %#ok<*NASGU>
    Screen('Preference', 'VisualDebuglevel', 0);
    Screen('Preference','SkipSyncTests',1);

    %Do some basic initializing
    AssertOpenGL;
    KbName('UnifyKeyNames');
    HideCursor;

    %Define response keys
    Key1 = KbName(STIM.Key1); %#ok<*NODEF>
    Key2 = KbName(STIM.Key2);
    KeyFix = KbName('space');

    if ~IsLinux
        KeyBreak = KbName('Escape');
    else
        KeyBreak = KbName('ESCAPE');
    end
    ListenChar(2);

    % Open a double-buffered window on screen
    if debug
        % for CK desktop linux; take one screen only
        WindowRect = DebugRect; %debug
    else
        WindowRect = []; %fullscreen
    end

    ScrNrs = Screen('screens');
    HARDWARE.ScrNr = max(ScrNrs);

    % Get some basic color intensities
    HARDWARE.white = WhiteIndex(HARDWARE.ScrNr);
    HARDWARE.black = BlackIndex(HARDWARE.ScrNr);
    HARDWARE.grey = (HARDWARE.white+HARDWARE.black)/2;

    [HARDWARE.window, HARDWARE.windowRect] = ...
        Screen('OpenWindow',HARDWARE.ScrNr,...
        STIM.BackColor*HARDWARE.white,WindowRect,[],2);

    % Define blend function for anti-aliassing
    [sourceFactorOld, destinationFactorOld, colorMaskOld] = ...
        Screen('BlendFunction', HARDWARE.window, ...
        GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    % Initialize text options
    Screen('Textfont',HARDWARE.window,GENERAL.Font);
    Screen('TextSize',HARDWARE.window,GENERAL.FontSize);
    Screen('TextStyle',HARDWARE.window,GENERAL.FontStyle);

    % Maximum useable priorityLevel on this system:
    priorityLevel = MaxPriority(HARDWARE.window);
    Priority(priorityLevel);

    % Get the refreshrate
    HARDWARE.FrameDur = Screen('GetFlipInterval',HARDWARE.window);

    % Get the screen size in pixels
    [HARDWARE.PixWidth, HARDWARE.PixHeight] = ...
        Screen('WindowSize',HARDWARE.ScrNr);
    % Get the screen size in mm
    [HARDWARE.MmWidth, HARDWARE.MmHeight] = ...
        Screen('DisplaySize',HARDWARE.ScrNr);

    % Define conversion factors
    HARDWARE.Mm2Pix = HARDWARE.PixWidth/HARDWARE.MmWidth;
    HARDWARE.Deg2Pix = (tand(1)*HARDWARE.DistFromScreen)*...
        HARDWARE.PixWidth/HARDWARE.MmWidth;

    % Determine color of on screen text and feedback
    % depends on background color --> Black or white
    if max(STIM.BackColor) > .5
        STIM.TextIntensity = HARDWARE.black;
    else
        STIM.TextIntensity = HARDWARE.white;
    end

    vbl = Screen('Flip', HARDWARE.window);
    Screen('FillRect',HARDWARE.window,...
        STIM.BackColor*HARDWARE.white);
    DrawFormattedText(HARDWARE.window,...
        'Exiting...','center','center',STIM.TextIntensity);
    vbl = Screen('Flip', HARDWARE.window);

    %% Process stimuli --------------------------------------------------
    run(['procstim_' student]);

    %% Instructions -----------------------------------------------------
    % General instruction screen
    % draw background
    Screen('FillRect',HARDWARE.window,STIM.BackColor*HARDWARE.white);

    % draw text
    DrawFormattedText(HARDWARE.window,STIM.WelcomeText,'center',....
        'center',STIM.TextIntensity);
    fprintf('\n>>Press key to start<<\n');
    vbl = Screen('Flip', HARDWARE.window);
    LOG.ExpOnset = vbl;

    %% Cycle over blocks ------------------------------------------------
    for B = 1:STIM.nBlocks
        % show block instructions --
        % draw background

        % draw text

        for T = 1:STIM.TrialsPerBlock
            % show instruction --
            % draw background
            Screen('FillRect',HARDWARE.window,...
                    STIM.BackColor*HARDWARE.white);
            % draw text
            DrawFormattedText(HARDWARE.window,...
                'Blablabla\n\n>> press key <<','center','center',STIM.TextIntensity);
            vbl = Screen('Flip', HARDWARE.window);
            

            % show fixation screen --
            % draw background
            Screen('FillRect',HARDWARE.window,...
                    STIM.BackColor*HARDWARE.white);
            % draw fixation dot
            Screen('FillOval', HARDWARE.window,...
                    STIM.Fix.Color.*HARDWARE.white,FixRect);
            vbl = Screen('Flip', HARDWARE.window);
            pause(STIM.Trial.Timing.FixDur)

            % show stimulus --
            % draw background
            Screen('FillRect',HARDWARE.window,...
                    STIM.BackColor*HARDWARE.white);
            % draw stimulus
            run(['drawstim_' student]);

            % no fixation

            % Get response and log things

        end
    end


    %% Restore screen
    Screen('CloseAll');ListenChar();ShowCursor;

    if ~QuitScript
        fprintf('All done! Thank you for participating\n');
    else
        fprintf('Quit the script by pressing escape\n');
    end


    %% Save the data ----------------------------------------------------
    % remove the images from the log to save space
    if STIM.RemoveImagesFromLog
        for i = 1: size(STIM.img,1)
            for j = 1:size(STIM.img,2)
                STIM.img(i,j).img = [];
            end
        end
    end
    [~,~] = mkdir(fullfile(StartFolder,DataFolder,HARDWARE.LogLabel));
    save(fullfile(StartFolder,DataFolder,HARDWARE.LogLabel,LOG.FileName),...
        'HARDWARE','GENERAL','STIM','LOG');
    
    % also save a csv file for quick stats
    save_csv(student,LOG);


catch e %#ok<CTCH> %if there is an error the script will go here
    %% Clean up ---------------------------------------------------------
    fprintf(1,'There was an error! The message was:\n%s',e.message);
    if HARDWARE.DoGammaCorrection
        Screen('LoadNormalizedGammaTable',HARDWARE.ScrNr,OLD_Gamtable);
    end
    Screen('CloseAll');ListenChar();ShowCursor;
    psychrethrow(psychlasterror);
end
cd(StartFolder); % back to where we started