function [P_polar,Pd_polar,J_polar]=Forward_Kine(q,qd,PitchAngle)
%----���˶�ѧ�������ؽڽǶȡ��ٶȣ����㼫������λ�ú��ٶ�----%
global L_leg

P_polar=[2*L_leg*cos(q(2,1)/2);q(1,1)+PitchAngle+q(2,1)/2];
J_polar=[0,-L_leg*sin(q(2,1)/2);1,0.5];
Pd_polar=J_polar*qd;
