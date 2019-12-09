function [value] = Turning_Angle(brick, delta, wallHit)
    currentAngle = brick.GyroAngle(3);
    setpoint = delta;
    error = setpoint - currentAngle;
    
    % If the wall was hit, back up a lil bit to clear the wall.
    if(wallHit == 1)
        brick.MoveMotor('AD',25);
        pause(1);
    end
    
    value = 0;
    while(abs(error) > 1)
        error = setpoint - brick.GyroAngle(3);
        fprintf('The error is: %d\n', error);
        brick.MoveMotor('A', -error + 10);
        brick.MoveMotor('D',  error + 10);
        value = 1;
    end
    brick.StopMotor('AD', 'Brake');
    pause(0.1);
end