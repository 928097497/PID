%% ��ջ���
clear
clc
%% ��������
w = 0.6;      % ��������
c1 = 2;       % ���ٳ���
c2 = 2;       % ���ٳ���
Dim = 3;            % ά��  ���ֻ�Ż�PI �������2  ��PID����3
SwarmSize = 30;    % ����Ⱥ��ģ һ��20-100
ObjFun = @PSO_PID;  % ���Ż��������
MaxIter = 15;      % ����������     һ��10-50
% MinFit = 0.1;       % ��С��Ӧֵ 
Vmax = 1;
Vmin = -1;
Ub = [1.5 0.01 100]; %��Ҫ�Ż���PID�ķ�Χ�����ֵ
Lb = [0 0 0];%��Ҫ�Ż���PID�ķ�Χ����Сֵ

%% ����Ⱥ��ʼ��
    Range = ones(SwarmSize,1)*(Ub-Lb);
    Swarm = rand(SwarmSize,Dim).*Range + ones(SwarmSize,1)*Lb;      % ��ʼ������Ⱥ
    VStep = rand(SwarmSize,Dim)*(Vmax-Vmin) + Vmin;                 % ��ʼ���ٶ�
    fSwarm = zeros(SwarmSize,1);
for i=1:SwarmSize
    fSwarm(i,:) = feval(ObjFun,Swarm(i,:));                         % ����Ⱥ����Ӧֵ
end

%% ���弫ֵ��Ⱥ�弫ֵ
[bestf bestindex]=min(fSwarm);
zbest=Swarm(bestindex,:);   % ȫ�����
gbest=Swarm;                % �������
fgbest=fSwarm;              % ���������Ӧֵ
fzbest=bestf;               % ȫ�������Ӧֵ

%% ����Ѱ��
iter = 0;
y_fitness = zeros(1,MaxIter);   % Ԥ�Ȳ���4���վ���
K_p = zeros(1,MaxIter);         
K_i = zeros(1,MaxIter);
K_d = zeros(1,MaxIter);
while( (iter < MaxIter)  )
    for j=1:SwarmSize
        % �ٶȸ���
        VStep(j,:) = w*VStep(j,:) + c1*rand*(gbest(j,:) - Swarm(j,:)) + c2*rand*(zbest - Swarm(j,:));
        if VStep(j,:)>Vmax, VStep(j,:)=Vmax; end
        if VStep(j,:)<Vmin, VStep(j,:)=Vmin; end
        % λ�ø���
        Swarm(j,:)=Swarm(j,:)+VStep(j,:);
        for k=1:Dim
            if Swarm(j,k)>Ub(k), Swarm(j,k)=Ub(k); end
            if Swarm(j,k)<Lb(k), Swarm(j,k)=Lb(k); end
        end
        % ��Ӧֵ
        fSwarm(j,:) = feval(ObjFun,Swarm(j,:));
        % �������Ÿ���     
        if fSwarm(j) < fgbest(j)
            gbest(j,:) = Swarm(j,:);
            fgbest(j) = fSwarm(j);
        end
        % Ⱥ�����Ÿ���
        if fSwarm(j) < fzbest
            zbest = Swarm(j,:);
            fzbest = fSwarm(j);
        end
    end 
    iter = iter+1;                      % ������������
    y_fitness(1,iter) = fzbest;         % Ϊ��ͼ��׼��
    K_p(1,iter) = zbest(1);
    K_i(1,iter) = zbest(2);
    K_d(1,iter) = zbest(3);
    
    disp(['��ǰ�Ѿ�������',num2str(iter),'    ��Ӧֵ:',num2str(fzbest)]);
end
%% ��ͼ���
figure(1)      % ��������ָ��ITAE�ı仯����
plot(y_fitness,'LineWidth',2)
title('���Ÿ�����Ӧֵ','fontsize',18);
xlabel('��������','fontsize',18);ylabel('��Ӧֵ','fontsize',18);
set(gca,'Fontsize',18);

figure(2)      % ����PID�����������仯����
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

suptitle('Kp��Ki��Kd �Ż�����');
set(gca,'Fontsize',10);
xlabel('��������','Fontsize',12);
