function [answers, QuitScript] = questionnaire(Q,HARDWARE,STIM)

linedva = [15 0.2];
linerect = [0 0 linedva(1) linedva(2)].*HARDWARE.Deg2Pix;

dotdva = 0.8;
seldva = 1.2;
dotrect = [0 0 dotdva dotdva].*HARDWARE.Deg2Pix;
selrect = [0 0 seldva seldva].*HARDWARE.Deg2Pix;

basecol = [0 0 0];
selcol = [1 1 1];

MoveQuestionUp = 3; %dva
TextSize = 20;
Screen('TextSize',HARDWARE.window,TextSize);

keyIsDown = false; QuitScript = false;

% draw background
Screen('FillRect',HARDWARE.window,STIM.BackColor*HARDWARE.white);
% draw text
DrawFormattedText(HARDWARE.window,...
    ['Please answer the following questions on a 1-5 scale\n\n'...
    '(left/right arrow to select, spacebar to confirm)\n\n'...
    '>> press any key to start <<' ],'center','center',...
    STIM.TextIntensity);
Screen('Flip', HARDWARE.window);
KbWait; while KbCheck; end

qidx = 1;
while qidx <= length(Q.Question) && ~QuitScript
   
    resp = []; 
    keyWasDown = false;
    selpos=3;

    while keyIsDown && ~QuitScript
        %wait until keys are released
        [keyIsDown,secs,keyCode]=KbCheck;
    end  
    
    while isempty(resp) && ~QuitScript
        % draw background
        Screen('FillRect',HARDWARE.window,STIM.BackColor*HARDWARE.white);
        % draw text
        DrawFormattedText(HARDWARE.window,...
            Q.Question(qidx).QuestText,'center',...
            HARDWARE.CenterRect(2)/2-(MoveQuestionUp*HARDWARE.Deg2Pix),...
            STIM.TextIntensity);
        % draw line
        Screen('FillRect',HARDWARE.window,basecol*HARDWARE.white,...
            CenterRectOnPoint(linerect,...
            HARDWARE.CenterRect(1)/2,HARDWARE.CenterRect(2)/2));
        % draw resp markers
        for l=1:5
            xy = [HARDWARE.CenterRect(1)/2-linerect(3)/2+(linerect(3)/4)*(l-1) ...
                HARDWARE.CenterRect(2)/2];
            Screen('FillOval',HARDWARE.window,basecol*HARDWARE.white,...
                CenterRectOnPoint(dotrect,xy(1),xy(2)));
        end
        xy = [HARDWARE.CenterRect(1)/2-linerect(3)/2+(linerect(3)/4)*(selpos-1) ...
            HARDWARE.CenterRect(2)/2];
        Screen('FillOval',HARDWARE.window,selcol*HARDWARE.white,...
            CenterRectOnPoint(selrect,xy(1),xy(2)));
        
        % flip
        Screen('Flip', HARDWARE.window);
        
        % check keys
        [keyIsDown,secs,keyCode]=KbCheck; %#ok<*ASGLU>
        if keyIsDown && ~keyWasDown
            if keyCode(KbName('space'))
                resp = selpos;
                keyWasDown = true;
            elseif keyCode(KbName('LeftArrow'))
                selpos = selpos-1;
                if selpos<1; selpos=1; end
                keyWasDown = true;
            elseif keyCode(KbName('RightArrow'))
                selpos = selpos+1;
                if selpos>5; selpos=5; end
                keyWasDown = true;
            elseif keyCode(KeyBreak) %break when esc
                QuitScript=1;
                break;
            else % unknown key
                keyWasDown = true;
            end
        elseif ~keyIsDown && keyWasDown
            keyWasDown = false;
        end
    end
    answers(qidx).rate = selpos; %#ok<*AGROW>
    pause(0.5);
    qidx = qidx+1;
end
