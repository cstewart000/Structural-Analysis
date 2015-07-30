
% TODO
    



%% Clear Pre-existig data
clear
clc
close all;

% Using the shortG format
format shortG;

% Add relevant searchpaths
addpath('UIforms');

% Check that Each of hte structure definition Tables exist
if(exist('nodeData.mat'))
        nodeExists_bool =1;
        load('nodeData.mat');
else
    message('you need to define the nodes');
    nodeUI();
end

if(exist('memberData.mat'))
        membersExists_bool =1;
        load('memberData.mat');
else
    message('you need to define the members');
    memberUI();
end

if(exist('sectionData.mat'))
        sectionsExists_bool =1;
        load('sectionData.mat');
else
    message('you need to define the sections');
    sectionUI();
end

if(exist('materialData.mat'))
        sectionsExists_bool =1;
        load('materialData.mat');
else
    message('you need to define the materials');
    materialUI();
end



Structure = StructureClass
%BikeWheel.loadTables();

Structure.loadTables(nodeData,memberData,sectionData,materialData);
Structure.loadArrayLists();
Structure.addGeometryToMembers();
Structure.calcLocalStiffness();
Structure.calcMemTransform();
Structure.calcGlobalStiffnes();
Structure.createStiffnessMatrix();

% TODO fix restraint code to pull from node arraylist
Structure.NodeList_array{1}.restraintCode = 'FF-F';
Structure.NodeList_array{3}.restraintCode = 'FF-F';


Structure.convertNodeRestraintCodeToDOFVector()
Structure.getRestraintDOFVector()

Structure.calculateReducedStiffnessMatrix();
Structure.calculateFlexibilityMatrix();
Structure.calculateReducedFlexibilityMatrix()

Structure.MemberLoads_array{1} = struct('member',2, 'loadType', 'UDL', 'axis', 'local' , 'magnitude', -3/12);


Structure.memberUDLs()
Structure.createBodyLoadVector();
Structure.createGlobalLoadVector();
Structure.reduceGlobalLoadVector();

Structure.calculateDisplacements();
Structure.calculateMemberForces();
Structure.calculateGlobalForces();


Structure.appliedLoadPlots()
Structure.memberMomentPlot()
Structure.memberShearPlot()
Structure.memberAxialPlot()
Structure.draw()

currentfig = gcf;
savefig('currentfig.fig');

