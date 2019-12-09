function [value] = GetColorCode(brick, port)
    color = brick.ColorRGB(port);
    red = color(1);
    green = color(2);
    blue = color(3);
    
    rg = red/green;
    rb = red/blue;
    gb = green/blue;
    
    if(rg > 4)
        value = 5;
    elseif(rb < 0.2)
        value = 2;
    elseif(rb > 3)
        value = 4;
    elseif(red > 200 && green > 200 && blue > 200)
        value = 6;
    else
        value = 7;
    end
end