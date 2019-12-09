% Sets the color sensor on port 2 to return
%NOTE: Returns blue when on green
brick.SetColorMode(2, 4);

while 1
    display(GetColorCode(brick, 2));
    pause(0.1);
end