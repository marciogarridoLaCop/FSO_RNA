function solution = nlinearsystem(x0,x1,y1,x2,y2,x3,y3,p1,p2,p3)
format long
variantes=[x1,y1,x2,y2,x3,y3,p1,p2,p3];

f = @(x) resolve_sistema(x,variantes);

options = optimset('Display','off');
resp= fsolve(f,x0, options);

solution=[resp];
    function F = resolve_sistema(x,~)
               
        F=[ (((x1-x(1))^2) + ((y1-x(2))^2) - ((x(3)^2)*(-log(p1))))
            (((x2-x(1))^2) + ((y2-x(2))^2) - ((x(3)^2)*(-log(p2))))
            (((x3-x(1))^2) + ((y3-x(2))^2) - ((x(3)^2)*(-log(p3))))
          ];
    end
return 
end