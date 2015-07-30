materialData = {2.0000e+09, 1};

memberData = [1     2     1     1;
    2     3     1     1];

sectionData = {12 600};


nodeData =   [0      0    1    111;
    240    180    1      0;
    480    180    1    111];


save('materialData.mat','materialData');
save('memberData.mat','memberData');
save('sectionData.mat','sectionData');
save('nodeData.mat','nodeData');
