function run_colrew(settingsnr,debug)

%% PTB3 script for ======================================================
% COLOR-REWARD association experiments
% Chris Klink: p.c.klink@uu.nl

% Response: choose one of three keys 

% In short:
% - Instruction appears
% - Stimulus appears
% - Subject reports as soon as possible
% - Interspersed info possible
% - Block designs

%% ========================================================================
clc; QuitScript = false;
warning off; %#ok<*WNOFF>
if nargin < 2
    debug = false;
    if nargin < 1
        settingsnr = 1;
    end
end
DebugRect = [0 0 1024 768];
fprintf('Welcome at Ruby''s prologue experiment\n')
QuitScript = false;

%% Read in variables ----------------------------------------------------
% First get the settings
[RunPath,~,~] = fileparts(mfilename('fullpath'));
SettingsFile = ['settings_colrew_' num2str(settingsnr)];
run(fullfile(RunPath, SettingsFile));

%% Create data folder if it doesn't exist yet ---------------------------
DataFolder = 'Data_ColRew';
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
    Key3 = KbName(STIM.Key3);
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
    DrawFormattedText(HARDWARE.window,...
        'Exiting...','center','center',STIM.TextIntensity);
    vbl = Screen('Flip', HARDWARE.window);

    %% Process stimuli --------------------------------------------------
    disp('processing stimuli');
    run('procstim_colrew');
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
            TT = BLOCK(B).Trial(T).TT;
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

            %% show fixation screen --
            % draw background
            Screen('FillRect',HARDWARE.window,...
                    STIM.BackColor*HARDWARE.white);
            % draw fixation dot
            Screen('FillOval', HARDWARE.window,...
                    STIM.Fix.Color.*HARDWARE.white,STIM.Fix.Rect);
            vbl = Screen('Flip', HARDWARE.window);
            
            rr = STIM.Trial.Timing.FixDurRand(2)-...
                STIM.Trial.Timing.FixDurRand(1);
            FixDur = STIM.Trial.Timing.FixDur + ...
                (STIM.Trial.Timing.FixDurRand(1)+(rr*rand(1)));
            pause(FixDur)

            %% show stimulus --
            % draw background
            Screen('FillRect',HARDWARE.window,...
                    STIM.BackColor*HARDWARE.white);
            % draw stimulus
            run('drawstim_colrew');
            % fixation
            Screen('FillOval', HARDWARE.window,...
                    STIM.Fix.Color.*HARDWARE.white,STIM.Fix.Rect);
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
                        LOG.Block(B).Trial(T).RT = secs - t0;
                        LOG.Block(B).Trial(T).Resp = 2;
                        ResponseGiven = true;
                        RespRec = true;
                    elseif keyCode(Key3)
                        LOG.Block(B).Trial(T).RT = secs - t0;
                        LOG.Block(B).Trial(T).Resp = 3;
                        ResponseGiven = true;    
                        RespRec = true;
                    end
                end
            end

            %% Give feedback --
            if LOG.Block(B).Trial(T).RT <= STIM.Trial.Timing.MaxRT
                if LOG.Block(B).Trial(T).Resp == STIM.TrialType(TT).Correct
                    % correct
                    Screen('FillRect',HARDWARE.window,...
                        STIM.BackColor*HARDWARE.white);
                    DrawFormattedText(HARDWARE.window,...
                        ['Correct: ' num2str(STIM.TrialType(TT).Reward) ...
                        ' points'],'center','center',...
                        STIM.TextIntensity);
                    vbl = Screen('Flip', HARDWARE.window);
                    pause(STIM.Exp.FB.Duration);
                else
                    % wrong
                    Screen('FillRect',HARDWARE.window,...
                        STIM.BackColor*HARDWARE.white);
                    DrawFormattedText(HARDWARE.window,...
                        'Wrong Choice','center','center',...
                        STIM.TextIntensity);
                    vbl = Screen('Flip', HARDWARE.window);
                    pause(STIM.Exp.FB.Duration);
                end
            else
               % too slow
                Screen('FillRect',HARDWARE.window,...
                    STIM.BackColor*HARDWARE.white);
                DrawFormattedText(HARDWARE.window,...
                    'Too slow','center','center',...
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
        B=B+1;
    end

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
        run('write_csv_colrew');
    end
catch e %#ok<CTCH> %if there is an error the script will go here
    %% Clean up ---------------------------------------------------------
    fprintf(1,'There was an error! The message was:\n%s',e.message);
    Screen('CloseAll');ListenChar();ShowCursor;
    psychrethrow(psychlasterror);
end
cd(StartFolder); % back to where we started