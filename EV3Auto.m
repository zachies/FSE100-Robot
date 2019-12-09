% Declares global variables that can be accessed from any class
% without passing it as a parameter.
global key
global TheoreticalAngle

% Initializes the keyboard for manual control\.
InitKeyboard();

% Sets the color mode on port 2
brick.SetColorMode(2, 4);

% Calibrates the gyro.
brick.GyroCalibrate(3);

% Counts how many times the robot has turned.
turnCounter = 0;

% Tracks what the theoretical angle of the robot should be.
% This accounts for any drift the robot  experience.
TheoreticalAngle = 0;

while(1)
    fprintf('Theoretical Angle: %d\nActual Angle: %d\n', TheoreticalAngle, brick.GyroAngle(3));
    switch(key)
        case 'c'
            brick.GyroCalibrate(3);
            disp('Calibrated!');
        case 'z'
            TheoreticalAngle = 0;
        case 'q'
            break;
    end
    pause(0.5);
end

% COLOR CODES
% 0 - No color?
% 1 - Black
% 2 - Blue    - Pickup
% 3 - Green   - Drop off
% 4 - Yellow  - Starting position
% 5 - Red     - Stop sign
% 6 - White   - Bump in table
% 7 - Brown   - Normal board

while 1
    % Get the color code on port 2.
    color = GetColorCode(brick, 2);

    %% Manual control mode.
    if color == 3 || color == 2
        while 1
            % Prints some telemetry about the current state of the sensors.
            %distance = brick.UltrasonicDist(4);
            %angle = brick.GyroAngle(3);
            %sprintf('Distance: %e | Angle: %e | Color: %e', distance, angle, color);
            
            pause(0.05);
            % Run different commands based on which key was pressed.
            switch key
                % Drive forward.
                case 'uparrow'
                    brick.MoveMotor('AD', -40);
                % Drive backwards.
                case 'downarrow'
                    brick.MoveMotor('AD', 40);
                % Turn in-place to the left.
                case 'leftarrow'
                    brick.MoveMotor('A', 50);
                    brick.MoveMotor('D', -50);
                % Turn in-place to the right.
                case 'rightarrow'
                    brick.MoveMotor('A', -50);
                    brick.MoveMotor('D', 50);
                % Raise the arm.
                case 'w'
                    brick.MoveMotor('C', 13);
                % Lower the arm.
                case 's'
                    brick.MoveMotor('C', -13);
                % Snap 90 degrees to the left.
                % Mostly used for debugging our turning code.
                case 't'
                    TheoreticalAngle = TheoreticalAngle - 90;
                    while(Turning_Angle(brick, TheoreticalAngle, 0) == 0)
                        disp('Trying to turn!');
                    end
                    brick.beep();
                % Recalibrates the gyro.
                case 'c'
                    brick.GyroCalibrate(3);
                    TheoreticalAngle = 0;
                    
                % Drives straight using a linear ramp rate.
                case 'g'
                    Drive_Straight(brick, 0);
                % Stops all motors when nothing is pressed.
                case 0
                    brick.StopMotor('AD', 'Coast');
                    brick.StopMotor('C', 'Brake');
                % Return to automatic driving mode by breaking the loop.
                case 'q'
                    break;
            end
        end
    %% Automatic navigation mode.
    elseif color == 7 || color == 4 || color == 6 || color == 5
        Drive_Straight(brick, 0);
    end
end
CloseKeyboard();