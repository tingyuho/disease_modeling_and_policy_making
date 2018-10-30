function [PT_male_F0, PT_male_F1, PT_male_F2, PT_male_F3, PT_male_F4, PT_female_F0, PT_female_F1, PT_female_F2, PT_female_F3, PT_female_F4, TN_male , TN_female]=treatment_rule (CT,quarterly_Budget_for_treatment, P_male, P_female)
    PT_F4=min(quarterly_Budget_for_treatment/(CT(5)*(P_male(11)+P_female(11))),1);
    PT_male_F4=PT_F4;
    PT_female_F4=PT_F4;
    
    PT_F3=max(min((quarterly_Budget_for_treatment-PT_F4*CT(5)*(P_male(11)+P_female(11)))/(CT(4)*(P_male(10)+P_female(10))),1),0);
    PT_male_F3=PT_F3;
    PT_female_F3=PT_F3;
    
    PT_F2=max(min((quarterly_Budget_for_treatment-PT_F4*CT(5)*(P_male(11)+P_female(11))-PT_F3*CT(4)*(P_male(10)+P_female(10)))/(CT(3)*(P_male(9)+P_female(9))),1),0);
    PT_male_F2=PT_F2;
    PT_female_F2=PT_F2;
    
    PT_F1=max(min((quarterly_Budget_for_treatment-PT_F4*CT(5)*(P_male(11)+P_female(11))-PT_F3*CT(4)*(P_male(10)+P_female(10))-PT_F2*CT(3)*(P_male(9)+P_female(9)))/(CT(2)*(P_male(8)+P_female(8))),1),0);
    PT_male_F1=PT_F1;
    PT_female_F1=PT_F1;
    
    PT_F0=max(min((quarterly_Budget_for_treatment-PT_F4*CT(5)*(P_male(11)+P_female(11))-PT_F3*CT(4)*(P_male(10)+P_female(10))-PT_F2*CT(3)*(P_male(9)+P_female(9))-PT_F1*CT(2)*(P_male(8)+P_female(8)))/(CT(1)*(P_male(7)+P_female(7))),1),0);
    PT_male_F0=PT_F0;
    PT_female_F0=PT_F0;

    TN_male=PT_male_F4*P_male(11)+PT_male_F3*P_male(10)+PT_male_F2*P_male(9)+PT_male_F1*P_male(8)+PT_male_F0*P_male(7);
    TN_female=PT_female_F4*P_female(11)+PT_female_F3*P_female(10)+PT_female_F2*P_female(9)+PT_female_F1*P_female(8)+PT_female_F0*P_female(7);
end