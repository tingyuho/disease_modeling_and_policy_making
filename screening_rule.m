function [PS_male, PS_female, SN_male , SN_female]=screening_rule (CS,quarterly_Budget_for_screening, P_male, P_female)

    PS=min(quarterly_Budget_for_screening/(CS(1)*(P_male(1)+P_female(1))+CS(2)*(P_male(2)+P_female(2))+CS(3)*(P_male(3)+P_female(3))+CS(4)*(P_male(4)+P_female(4))+CS(5)*(P_male(5)+P_female(5))+CS(6)*(P_male(6)+P_female(6))),1);
    PS_male=PS;
    PS_female=PS;
    SN_male=PS_male*sum(P_male(1:6));
    SN_female=PS_female*sum(P_female(1:6));
end