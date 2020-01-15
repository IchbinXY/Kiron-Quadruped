function Q=polarTogenera(P_polar)
%----������ǰ�Ⱥ���ǰ�ȵļ�����λ�ú��ٶȣ��������Ӧ����ؽ��ٶȡ����ٶ�----%
global L1 L2

r=P_polar(1);
theta=P_polar(2);

q2=acos((L1^2+L2^2-r^2)/(2*L1*L2))-pi;
q1=asin((L2*sin(pi+q2))/r)+theta;
Q=[q1;q2];
