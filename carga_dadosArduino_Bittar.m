% Programa de Pós Graduação em Engenharia Elétrica e Telecomunicações
% LACOP - Laboratório de Comunicações Óticas - UFF
% Aluno : Márcio Alexandre Dias Garrido

clear;
clc;
% Altere o nome do arquivo que deseja carregar
load('4v_30_01_1902.mat')
clc;
format long;
%% 
global x1 y1 p1 x2 y2 p2 x3 y3 p3;
%% Parametros de inicialização

K=273.15; 
soma_quadrados=0;
resposta={};
constante=79*10^-6;
pressao=1013.25;
temperatura_ambiente=28+K;
temperatura_media= mean(DADOS(:,6));
%ajustedados;
metro=10^-3;
escala=1;
L=1.9;  % 340
distancia_sensores=140*metro;
Anteparo=25*metro;
W=22*metro;


%Posicao detectores 
x1=-10*metro; y1=-5.84*metro;
x2=0*metro; y2=12.65*metro;
x3=10.12*metro; y3=-5.84*metro;

T2=DADOS(:,6); % senssor inferior
T1=DADOS(:,5); % senssor inferior


R=(distancia_sensores);

x0=[0.000 0.000 W];
pc=max(DADOS(:,4));
velocidade_media=mean(DADOS(:,7));
velocidade=max(DADOS(:,7));
clear rc;
tic
for i=1:length(DADOS)
    p_1(:,i)=DADOS(i,1)/pc;
    p_2(:,i)=DADOS(i,2)/pc;
    p_3(:,i)=DADOS(i,3)/pc;
    p1=DADOS(i,1)/pc;
    p2=DADOS(i,2)/pc;
    p3=DADOS(i,3)/pc;
    xyw(i,:)= nlinearsystem(x0,x1,y1,x2,y2,x3,y3,p1,p2,p3);
    x0 = xyw(i,:);
    x0(1,3)=2.*xyw(i,3);  
    xyw(i,3)= 2.*xyw(i,3);  
    rc(i) = sqrt(xyw(i,1)^2+xyw(i,2)^2);
    Tinf(i)=DADOS(i,6);
    Tsup(i)=DADOS(i,5); 
    percentual=round((100*i)/length(DADOS));
     if mod(i,1000)==0
        fprintf("Percentual da carga de dados em "+ percentual+" por cento\n") 
    end
end
wcalculado=mean(xyw(:,3))/metro;
toc

time=127;%tempo de coleta em segundos
T=time/length(rc);  %tempo por amostra
% Cálculo a cada intervalo de tempo %
interval=1; %% Frequencia de leitura
interval_cn=round(interval/T); %%nr de amostras

for aux=1:round(length(rc)/interval_cn)
    
    if aux<round(length(rc)/interval_cn)
      variancia=var(rc(1+(aux-1)*interval_cn:aux*interval_cn));    
      
    else
       variancia=var(rc(1+(aux-1)*interval_cn:length(rc)));
      
    end

    Cn2(aux)=variancia/(2.42*W^(-1/3)*L^3);
    
end

%% Formatação temperatura

for aux=1:round(length(rc)/interval_cn)
    
    if aux<round(length(rc)/interval_cn)
        temperatura2(aux)=mean(T2(1+(aux-1)*interval_cn:aux*interval_cn));        
    else
        temperatura2(aux)=mean(T2(1+(aux-1)*interval_cn:length(rc))); 
        
    end
    
end

for aux=1:round(length(rc)/interval_cn)
    
    if aux<round(length(rc)/interval_cn)
        temperatura1(aux)=mean(T1(1+(aux-1)*interval_cn:aux*interval_cn));        
    else
        temperatura1(aux)=mean(T1(1+(aux-1)*interval_cn:length(rc))); 
    end
    
end

%% 
rc_medio=mean(rc/metro);
rc_mm=rc/metro;
rc_medio
variancia_matlab=var(rc_mm)
wcalculado
velocidade_media=mean(velocidade)
CN2=mean(Cn2)
temperatura_media_abaixo_feixe=mean(Tinf)
temperatura_media_acima_feixe=mean(Tsup)
diferencial_temperatura=temperatura_media_abaixo_feixe-temperatura_media_acima_feixe
temperatura_media

%% data/hora do experimento

t1 = datetime(2021,12,4,14,00,00);
s= seconds(T*(1:length(Cn2)));
a=seconds(T*(1:length(Cn2)));
hora=t1+s;
hora.Format='ss';
s.Format = 'hh:mm';
s2= seconds(interval_cn*T*(1:length(Cn2)));
hora2=t1+s2;

%% %% Gráfico de temperatura
hold on
% figure('Name','Arranjo II','NumberTitle','off');
subplot(2,1,1)
T1Y = temperatura1;
T2Y = temperatura2;
plot(hora2, T2Y, '--o' ,'MarkerIndices',1:10:length(hora2),'color', 'red'); hold on
hold on
plot(hora2, T1Y, '--*' ,'MarkerIndices',1:10:length(hora2),'color', 'blue'); hold on
xlabel('Horário');
ylabel('(Cº)' );
ylim([round(min(T1Y)-1) round(max(T2Y)+1)]);
xlim([hora2(1) hora2(end)]);
xtickformat('HH:mm');
box on
ax=gca;
ax.YAxis.LineWidth = 1.4;
ax.XAxis.LineWidth = 1.4;
grid on
legend("Temperatura abaixo do feixe","Temperatura acima do feixe","Location","best");
title('Temperatura','FontSize',16)
hold off

%% CN2 Triangulação
subplot(2,1,2)
fim_escala=180*10^-13;
Cn2_grafico = Cn2;
horafitlrada=linspace(hora2(1),hora2(end),length(Cn2_grafico));
plot(horafitlrada,Cn2_grafico,"Color",[0 0.4470 0.7410],"LineWidth",2); hold on
xlim([hora2(1) hora2(end)]);
ylim([5*10^-15 fim_escala]);
title('Cn2 por Triangulação','FontSize',16)
box on
grid on
ax=gca;
ax.YAxis.LineWidth = 1.4;
ax.XAxis.LineWidth = 1.4;
grid on;
xlabel('Horário');
ylabel('Cn^2(m^{-2/3})');
fprintf("Coleta finalizada !\n") 
