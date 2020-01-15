function y=LegFoot_traj(u)
%----����ʱ���źźͽӴ��źţ����㼫����ϵ�µ���˹켣�滮-----%
global T_st T_sw 
tim=u(1);
in_ctact=double(u(2));

persistent tim_ref
if isempty(tim_ref)
    tim_ref=0;
end

persistent ctact_ahead_now
if isempty(ctact_ahead_now)
    ctact_ahead_now=[0 0];
end
%----ÿ�ε��ú������½Ӵ��ж�-----%
ctact_ahead_now(1)=ctact_ahead_now(2);
ctact_ahead_now(2)=in_ctact;

if (ctact_ahead_now(1)==0)&&(ctact_ahead_now(2)==1)%����ʱ��
    tim_ref=tim;
    [P_des,Pd_des]=Stance_tra(0);
    [P_polar_des,Pd_polar_des]=polar_transform(P_des,Pd_des);
end
if (ctact_ahead_now(1)==1)&&(ctact_ahead_now(2)==1)%վ����
    pha_st=(tim-tim_ref)/T_st;
    [P_des,Pd_des]=Stance_tra(pha_st);
    [P_polar_des,Pd_polar_des]=polar_transform(P_des,Pd_des);
end
if (ctact_ahead_now(1)==1)&&(ctact_ahead_now(2)==0)%���ʱ��
    [P_des,Pd_des]=Swing_tra(0);
    [P_polar_des,Pd_polar_des]=polar_transform(P_des,Pd_des);
end
if (ctact_ahead_now(1)==0)&&(ctact_ahead_now(2)==0)%�ڶ���
    if tim_ref<T_sw*0.5
        pha_sw_init=(tim+T_sw/2)/T_sw;
        [P_des,Pd_des]=Swing_tra_init(pha_sw_init);
        [P_polar_des,Pd_polar_des]=polar_transform(P_des,Pd_des);
    else
        pha_sw=(tim-tim_ref-T_st)/T_sw;
        [P_des,Pd_des]=Swing_tra(pha_sw);
        [P_polar_des,Pd_polar_des]=polar_transform(P_des,Pd_des);
    end
end
% y=[P_des;Pd_des];
y=[P_polar_des;Pd_polar_des];