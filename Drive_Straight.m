function [] = Drive_Straight(brick, delta)
global TheoreticalAngle
i = 0;

previous_dist = brick.UltrasonicDist(4);
current_dist = brick.UltrasonicDist(4);

% Start a stopwatch.
t = 0;
tic

while 1
    t = toc;
    sprintf('Time: %f', t);
    color = GetColorCode(brick, 2);
    
    if(color == 5)
        brick.StopMotor('AD', 'Brake');
        pause(3);
        brick.MoveMotor('AD', -30);
        pause(2);     
    end
   
       
    distance = brick.UltrasonicDist(4);
    current_dist = brick.UltrasonicDist(4);
    delta_dist = current_dist - previous_dist;
    
    % Delta going negative -> turn left
    % Delta going positive -> turn right
    
%    if(distance < 60 || delta_dist < 5)
%        leftSpeed = max(-50  + (delta_dist/8), -i  + ( delta_dist/8));
%        rightSpeed = max(-50 - ( delta_dist/8), -i  - (delta_dist/8));
%        disp('Correcting \n');
%    else
       leftSpeed = max(-50,-i);
        rightSpeed= max(-50,-i);
%    end
     
   % fprintf("%d leftSpeed:", leftSpeed);
    %fprintf("\n");
    %fprintf("%d rightSpeed", rightSpeed);
    %fprintf("\n");
    
    % A is left motor, D is right motor
    brick.MoveMotor('A', leftSpeed);
    brick.MoveMotor('D', rightSpeed);
    % brick.MoveMotor('AD', max(-50, -i))
    if(t > 4)
        color = GetColorCode(brick, 2);
        distance = brick.UltrasonicDist(4);
        fprintf('Color: %e\n', color);
        fprintf('Distance: %e\n', distance);
        
        
        if(distance > 40 && distance < 250)
            pause(2);
            TheoreticalAngle = TheoreticalAngle + 90;
            while(Turning_Angle(brick, TheoreticalAngle, 0) == 0)
                disp('Trying to turn!');
            end
            brick.beep();
            break
        elseif brick.TouchPressed(1) == 1
            TheoreticalAngle = TheoreticalAngle - 90;
            while(Turning_Angle(brick, TheoreticalAngle, 0) == 0)
                disp('Trying to turn!');
            end
            brick.beep();
            break;
        elseif color == 3 || color == 2 || color == 5
            break;
        end
    end
    
    i = i + 2.5;
    previous_dist = current_dist;
    pause(0.05);
end

%currentAngle = brick.GyroAngle(3);
%setpoint = delta + currentAngle;
%error = setpoint - currentAngle;

%kP = 2;
%sprintf('The error is: %d', error);

%brick.MoveMotor('A', kP  * error - 50)
%brick.MoveMotor('D', -kP * error - 50)
end