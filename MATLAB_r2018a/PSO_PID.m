

function z=PSO_PID(x)
assignin('base','Kp',x(1));
assignin('base','Ki',x(2));
assignin('base','Kd',x(3));
[t_time,x_state,y_out]=sim('PID_Model',[0,1000]);  %这里1000是仿真时间，具体需要根据你模型改
z=y_out(end,1);