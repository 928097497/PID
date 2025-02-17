%% 清空环境
clear
clc
%% 参数设置
w = 0.6;      % 惯性因子
c1 = 2;       % 加速常数
c2 = 2;       % 加速常数
Dim = 3;            % 维数  如果只优化PI 这里就是2  ，PID就是3
SwarmSize = 30;    % 粒子群规模 一般20-100
ObjFun = @PSO_PID;  % 待优化函数句柄
MaxIter = 15;      % 最大迭代次数     一般10-50
% MinFit = 0.1;       % 最小适应值 
Vmax = 1;
Vmin = -1;
Ub = [1.5 0.01 100]; %需要优化的PID的范围的最大值
Lb = [0 0 0];%需要优化的PID的范围的最小值

%% 粒子群初始化
    Range = ones(SwarmSize,1)*(Ub-Lb);
    Swarm = rand(SwarmSize,Dim).*Range + ones(SwarmSize,1)*Lb;      % 初始化粒子群
    VStep = rand(SwarmSize,Dim)*(Vmax-Vmin) + Vmin;                 % 初始化速度
    fSwarm = zeros(SwarmSize,1);
for i=1:SwarmSize
    fSwarm(i,:) = feval(ObjFun,Swarm(i,:));                         % 粒子群的适应值
end

%% 个体极值和群体极值
[bestf bestindex]=min(fSwarm);
zbest=Swarm(bestindex,:);   % 全局最佳
gbest=Swarm;                % 个体最佳
fgbest=fSwarm;              % 个体最佳适应值
fzbest=bestf;               % 全局最佳适应值

%% 迭代寻优
iter = 0;
y_fitness = zeros(1,MaxIter);   % 预先产生4个空矩阵
K_p = zeros(1,MaxIter);         
K_i = zeros(1,MaxIter);
K_d = zeros(1,MaxIter);
while( (iter < MaxIter)  )
    for j=1:SwarmSize
        % 速度更新
        VStep(j,:) = w*VStep(j,:) + c1*rand*(gbest(j,:) - Swarm(j,:)) + c2*rand*(zbest - Swarm(j,:));
        if VStep(j,:)>Vmax, VStep(j,:)=Vmax; end
        if VStep(j,:)<Vmin, VStep(j,:)=Vmin; end
        % 位置更新
        Swarm(j,:)=Swarm(j,:)+VStep(j,:);
        for k=1:Dim
            if Swarm(j,k)>Ub(k), Swarm(j,k)=Ub(k); end
            if Swarm(j,k)<Lb(k), Swarm(j,k)=Lb(k); end
        end
        % 适应值
        fSwarm(j,:) = feval(ObjFun,Swarm(j,:));
        % 个体最优更新     
        if fSwarm(j) < fgbest(j)
            gbest(j,:) = Swarm(j,:);
            fgbest(j) = fSwarm(j);
        end
        % 群体最优更新
        if fSwarm(j) < fzbest
            zbest = Swarm(j,:);
            fzbest = fSwarm(j);
        end
    end 
    iter = iter+1;                      % 迭代次数更新
    y_fitness(1,iter) = fzbest;         % 为绘图做准备
    K_p(1,iter) = zbest(1);
    K_i(1,iter) = zbest(2);
    K_d(1,iter) = zbest(3);
    
    disp(['当前已经迭代：',num2str(iter),'    适应值:',num2str(fzbest)]);
end
%% 绘图输出
figure(1)      % 绘制性能指标ITAE的变化曲线
plot(y_fitness,'LineWidth',2)
title('最优个体适应值','fontsize',18);
xlabel('迭代次数','fontsize',18);ylabel('适应值','fontsize',18);
set(gca,'Fontsize',18);

figure(2)      % 绘制PID控制器参数变化曲线
subplot(3,1,1)
plot(K_p,'LineWidth',3)
legend('Kp');
set(gca,'Fontsize',10);

subplot(3,1,2)
plot(K_i,'k','LineWidth',3)
legend('Ki');
set(gca,'Fontsize',10);

subplot(3,1,3)
plot(K_d,'r','LineWidth',3)
legend('Kd');
set(gca,'Fontsize',10);

suptitle('Kp、Ki、Kd 优化曲线');
set(gca,'Fontsize',10);
xlabel('迭代次数','Fontsize',12);
