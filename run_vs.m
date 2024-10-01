function run_vs(student,settingsnr,debug)

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

%% ========================================================================
clc; QuitScript = false;
warning off; %#ok<*WNOFF>
if nargin < 3
    debug = false;
    if nargin < 2
        settingsnr = 1;
        if nargin < 1
            fprintf('Please define an experiment type\n');
            QuitScript = true;
        end
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
SettingsFile = ['settings_' student '_' num2str(settingsnr)];
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
    if debug
        LOG.Subject = 'TEST';
        LOG.Gender = 'x';
        LOG.Age = 0;
        LOG.Handedness = 'R';
        LOG.DateTimeStr = datestr(datetime('now'), 'yyyyMMdd_HHmm'); %#ok<*DATST>
        LOG.SubID = 0;
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
        LOG.SubID = randi(10000); % random number between 1-10000
    end
    LOG.FileName = [LOG.Subject '_' LOG.DateTimeStr];

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
    HARDWARE.CenterRect = [HARDWARE.windowRect(3)-HARDWARE.windowRect(1) ...
        HARDWARE.windowRect(4)-HARDWARE.windowRect(2)];
    % Define blend function for anti-aliassing
    [sourceFactorOld, destinationFactorOld, colorMaskOld] = ...
        Screen('BlendFunction', HARDWARE.window, ...
        GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    % Initialize text options
    Screen('Textfont',HARDWARE.window,GENERAL.Font); %#ok<*USENS>
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
    vbl = Screen('Flip', HARDWARE.window);

    %% Process stimuli --------------------------------------------------
    %disp('processing stimuli');
    run(['procstim_' student]);
    %disp('done')

    %% Instructions -----------------------------------------------------
    % General instruction screen
    % draw background
    Screen('FillRect',HARDWARE.window,STIM.BackColor*HARDWARE.white);

    % draw text
    DrawFormattedText(HARDWARE.window,STIM.WelcomeText,'center',....
        'center',STIM.TextIntensity);
    fprintf('>>Press key to start<<\n');
    vbl = Screen('Flip', HARDWARE.window);
    LOG.ExpOnset = vbl;
    KbWait; while KbCheck; end

    %% Cycle over blocks ------------------------------------------------
    B=1; RespRec = false;
    while ~QuitScript && B <= STIM.nBlocks
        BT = BLOCK(B).BlockType;
        
        %% if variant NS, show emotion story --
        if strcmp(student,'NS')
            % draw background
            Screen('FillRect',HARDWARE.window,...
                STIM.BackColor*HARDWARE.white);
            % draw text
            DrawFormattedText(HARDWARE.window,...
                'Please read the following story','center','center',...
                STIM.TextIntensity);
            vbl = Screen('Flip', HARDWARE.window);
            pause(1);
            
            % draw background
            Screen('FillRect',HARDWARE.window,...
                STIM.BackColor*HARDWARE.white);
            % draw text
            Screen('TextSize',HARDWARE.window,STORY.FontSize);
            DrawFormattedText(HARDWARE.window,...
                STIM.Block(BT).TextStory,'center','center',...
                STIM.TextIntensity);
            vbl = Screen('Flip', HARDWARE.window);
            Screen('TextSize',HARDWARE.window,GENERAL.FontSize);
            % wait for key press
            pause(1);
            KbWait; while KbCheck; end
        end

        %% show block instructions --
        % draw background
        Screen('FillRect',HARDWARE.window,...
            STIM.BackColor*HARDWARE.white);
        % draw text
        DrawFormattedText(HARDWARE.window,...
            STIM.Block(BT).TextStart,'center','center',...
            STIM.TextIntensity);
        vbl = Screen('Flip', HARDWARE.window);
        % wait for key press
        pause(1); 
        KbWait; while KbCheck; end

        %% Cycle over trials -------
        T=1;
        while ~QuitScript && T <= length(BLOCK(B).Trials)
            %% repeat instruction every nth trial--
            if T>1 && mod(T-1,STIM.Block(BT).RepeatTextEveryNth)==0
                % draw background
                Screen('FillRect',HARDWARE.window,...
                    STIM.BackColor*HARDWARE.white);
                DrawFormattedText(HARDWARE.window,...
                    STIM.Block(BT).TextStart,'center','center',...
                    STIM.TextIntensity);
                vbl = Screen('Flip', HARDWARE.window);
                % wait for key press
                pause(1);
                KbWait; while KbCheck; end
            end

            %% trial-based instructions --
            if ~isempty(STIM.TrialType(BLOCK(B).Trial(T).TT).TrialText)
                % draw background
                Screen('FillRect',HARDWARE.window,...
                    STIM.BackColor*HARDWARE.white);
                DrawFormattedText(HARDWARE.window,...
                    STIM.TrialType(BLOCK(B).Trial(T).TT).TrialText,'center','center',...
                    STIM.TextIntensity);
                vbl = Screen('Flip', HARDWARE.window);
                % wait for key press
                pause(1);
                KbWait; while KbCheck; end
            end

            %% show fixation screen --
            % draw background
            Screen('FillRect',HARDWARE.window,...
                    STIM.BackColor*HARDWARE.white);
            % draw fixation dot
            Screen('FillOval', HARDWARE.window,...
                    STIM.Fix.Color.*HARDWARE.white,STIM.Fix.Rect);
            vbl = Screen('Flip', HARDWARE.window);
            pause(STIM.Trial.Timing.FixDur)

            %% show stimulus --
            % draw background
            Screen('FillRect',HARDWARE.window,...
                    STIM.BackColor*HARDWARE.white);
            % draw stimulus
            run(['drawstim_' student]);
            vbl = Screen('Flip', HARDWARE.window);
            t0 = GetSecs; 
            ResponseGiven = false;

            % Get response and log things --
            % Check for key-presses
            while ~ResponseGiven
                [keyIsDown,secs,keyCode]=KbCheck; %#ok<*ASGLU>
                if keyIsDown
                    if keyCode(KeyBreak) %break when esc
                        %fprintf('Escape pressed\n')
                        QuitScript=1;
                        break;
                    elseif keyCode(Key1)
                        LOG.Block(B).Trial(T).RT = secs - t0;
                        LOG.Block(B).Trial(T).Resp = 1;
                        ResponseGiven = true;
                        RespRec = true;
                    elseif keyCode(Key2)
                        %fprintf('Key 0 pressed\n')
                        LOG.Block(B).Trial(T).RT = secs - t0;
                        LOG.Block(B).Trial(T).Resp = 0;
                        ResponseGiven = true;
                        RespRec = true;
                    end
                end
            end

            %% Give feedback --
            if ~QuitScript && STIM.Exp.FB.Do && ...
                    ((B>1 && T>0 && mod(T,STIM.Exp.FB.EveryNthTrial)==0) || ...
                    (B==1 && T>=STIM.Exp.FB.StartAfter && mod(T,STIM.Exp.FB.EveryNthTrial)==0))
                % draw background
                Screen('FillRect',HARDWARE.window,...
                    STIM.BackColor*HARDWARE.white);
                fbi = randi(length(STIM.Exp.FB.Text));
                DrawFormattedText(HARDWARE.window,...
                    ['Hi ' LOG.Subject '!\n\n'...
                    STIM.Exp.FB.Text{fbi}],'center','center',...
                    STIM.TextIntensity);
                vbl = Screen('Flip', HARDWARE.window);
                pause(STIM.Exp.FB.Duration);
            end

            %% ITI
            Screen('FillRect',HARDWARE.window,STIM.BackColor*HARDWARE.white);
            vbl = Screen('Flip', HARDWARE.window);
            pause(STIM.Exp.ITI);
            T=T+1;
        end
        
        % Do a questionnaire if needed
        if ~isempty(STIM.Block(BT).Questionnaire) && STIM.Block(BT).Questionnaire ~= 0 
            qidx = STIM.Block(BT).Questionnaire;
            LOG.Block(B).QuestAnswers = questionnaire(...
                STIM.Questionnaire(qidx), ...
                HARDWARE,STIM);
            LOG.Block(B).Questionnaire = STIM.Questionnaire(qidx);
            Screen('TextSize',HARDWARE.window,GENERAL.FontSize);
        end
        B=B+1;
    end

    % Do a questionnaire if needed
    if ~isempty(STIM.Exp.Questionnaire) && STIM.Exp.Questionnaire ~= 0
        qidx = STIM.Exp.Questionnaire;
        LOG.QuestAnswers = questionnaire(...
            STIM.Questionnaire(qidx),...
            HARDWARE,STIM);
        LOG.Questionnaire = STIM.Questionnaire(qidx);
        Screen('TextSize',HARDWARE.window,GENERAL.FontSize);
    end

    %% show thank you text --
    % draw background
    Screen('FillRect',HARDWARE.window,...
        STIM.BackColor*HARDWARE.white);
    % draw text
    DrawFormattedText(HARDWARE.window,...
        'All done. Thank you!','center','center',...
        STIM.TextIntensity);
    vbl = Screen('Flip', HARDWARE.window);
    pause(2);

    %% Restore screen
    Screen('CloseAll');ListenChar();ShowCursor;

    if ~QuitScript
        fprintf('All done! Thank you for participating\n');
    else
        fprintf('Quit the script by pressing escape\n');
    end

    %% Save the data ----------------------------------------------------
    if RespRec
        [~,~] = mkdir(fullfile(StartFolder,DataFolder,HARDWARE.LogLabel));
        save(fullfile(StartFolder,DataFolder,HARDWARE.LogLabel,LOG.FileName),...
            'HARDWARE','GENERAL','STIM','BLOCK','LOG');

        % also save a csv file for quick stats
        run(['write_csv_' student]);
    end
catch e %#ok<CTCH> %if there is an error the script will go here
    %% Clean up ---------------------------------------------------------
    fprintf(1,'There was an error! The message was:\n%s',e.message);
    Screen('CloseAll');ListenChar();ShowCursor;
    psychrethrow(psychlasterror);
end
cd(StartFolder); % back to where we started