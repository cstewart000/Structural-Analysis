%% STRUCUTRE CLASS
%{

    Updated:
    1-7-2015 - adjusted load tables to accept sections


%}



classdef StructureClass < handle
    
    properties
        StiffnessMatrix = []
        ReducedStiffnessMatrix
        ReducedFlexibilityMatrix
        FlexibilityMatrix
        NodeTable
        NodeList_array
        MemberTable
        MemberList_array
        MaterialTable
        MaterialList_array
        InputForces
        GlobalLoadVector
        structure_plot
        restrainedDOFs
        ReactionForces
        GlobalForces
        MemberForces
        NumberOfMembers
        NumberOfNodes
        NumberOfDOFs
        MemberLoads_array
        reducedGlobalLoadVector
        DisplacementVector
        SectionList_array
        SectionTable
    end
    methods
        % Constructor Method
        function obj = StructureClass(NodeTable,MemberTable,SectionTable,MaterialTable)
            if  nargin > 0
                obj.MemberTable = MemberTable;
                obj.MaterialTable = MaterialTable;
                obj.NodeTable = NodeTable;
                obj.SectionTable = SectionTable;
                
            end
        end
        
        
        %% Load Tables
        function obj = loadTables(obj, varargin)
            
            nargin
            
            if(nargin==5)
                
                fieldnames = {'NodeTable','MemberTable','SectionTable','MaterialTable'};
              
                for i=1:nargin-1
                    if(iscell(varargin{i}))
                        obj.(fieldnames{i}) = cell2mat(varargin{i});
                    else
                        obj.(fieldnames{i}) = varargin{i};
                    end
                                          
                              
                end
                
            elseif(nargin==0)
                pathName = pwd;
                obj.MemberTable = load('MemberTable.mat');
                obj.MaterialTable= load('MaterialTable.mat');
                obj.NodeTable =load('NodeTable.mat');
            else
                error('incorrect arguments passed to StructureClass.loadTables()');
            end
            
        end
        
        %% Convert Tables to Array Lists
        function obj = loadArrayLists(obj)
            
            obj.NumberOfNodes = length(obj.NodeTable(:,1))
            obj.NumberOfDOFs = obj.NumberOfNodes*3
            
            % Nodes
            for i=1:obj.NumberOfNodes
                obj.NodeList_array{i} = struct('name' , i, 'x',obj.NodeTable(i,1),'y',obj.NodeTable(i,2))
            end
            
            % Material
            for i=1:length(obj.MaterialTable(:,1))
                obj.MaterialList_array{i}.name = i;
                obj.MaterialList_array{i}.E = obj.MaterialTable(i,1)
                obj.MaterialList_array{i}.v = obj.MaterialTable(i,2)
            end
            
            % Section
            for i=1:length(obj.SectionTable(:,1))
                obj.SectionList_array{i}.name = i;
                obj.SectionList_array{i}.A = obj.SectionTable(i,1)
                obj.SectionList_array{i}.Izz = obj.SectionTable(i,2)
            end
            
            % Members
            for i=1:length(obj.MemberTable(:,1))
                nodeAname = obj.MemberTable(i,1);
                nodeBname = obj.MemberTable(i,2);
                sectionName = obj.MemberTable(i,3);
                materialName = obj.MemberTable(i,4);
                
                nodeAIndex=[];
                nodeBIndex=[];
                
                
                % find from node list the matching name
                for j=1:length(obj.NodeList_array)
                    if(nodeAname == obj.NodeList_array{j}.name)
                        nodeAIndex = j;
                        obj.MemberList_array{i}.nodeA =obj.NodeList_array{nodeAIndex} ;
                        
                    elseif(nodeBname == obj.NodeList_array{j}.name)
                        nodeBIndex = j;
                        obj.MemberList_array{i}.nodeB =obj.NodeList_array{nodeBIndex} ;
                    end
                end
                
                % find matching material and store into member
                for k=1:length(obj.MaterialList_array)
                    if(materialName == obj.MaterialList_array{k}.name)
                        materialIndex = k;
                        obj.MemberList_array{i}.material = obj.MaterialList_array{k} ;
                    end
                    
                end
                
                                % find matching Section and store into member
                for l=1:length(obj.SectionList_array)
                    if(sectionName == obj.SectionList_array{l}.name)
                        sectionIndex = l;
                        obj.MemberList_array{i}.section = obj.SectionList_array{l} ;
                    end
                    
                end
                
            end
        end
        
        
        %% Add geometric properties to members
        function obj = addGeometryToMembers(obj)
            for m=1:length(obj.MemberList_array)
                
                deltaX = (obj.MemberList_array{m}.nodeB.x-obj.MemberList_array{m}.nodeA.x);
                deltaY = (obj.MemberList_array{m}.nodeB.y-obj.MemberList_array{m}.nodeA.y);
                
                len = sqrt(deltaX^2+deltaY^2)
                obj.MemberList_array{m}.length = len
                
                ang = atan(deltaY/deltaX);
                obj.MemberList_array{m}.angle = ang
                
                
            end
        end
        
        
        function obj = calcLocalStiffness(obj)
            
            for i=1:length(obj.MemberList_array)
                
                L = obj.MemberList_array{i}.length;
                E_Pa = (obj.MemberList_array{i}.material.E)
                A_m2 = (obj.MemberList_array{i}.section.A)
                I_m4 = (obj.MemberList_array{i}.section.Izz)
                
                obj.MemberList_array{i}.k_member =    [A_m2*E_Pa/L  0           0           -A_m2*E_Pa/L      0               0;
                    0       12*E_Pa*I_m4/L^3  6*E_Pa*I_m4/L^2   0           -12*E_Pa*I_m4/L^3     6*E_Pa*I_m4/L^2;
                    0       6*E_Pa*I_m4/L^2   4*E_Pa*I_m4/L     0           -6*E_Pa*I_m4/L^2      2*E_Pa*I_m4/L;
                    -A_m2*E_Pa/L  0           0           A_m2*E_Pa/L       0               0;
                    0       -12*E_Pa*I_m4/L^3 -6*E_Pa*I_m4/L^2  0           12*E_Pa*I_m4/L^3      -6*E_Pa*I_m4/L^2;
                    0       6*E_Pa*I_m4/L^2  2*E_Pa*I_m4/L     0           -6*E_Pa*I_m4/L^2      4*E_Pa*I_m4/L]
                
                
            end
        end
        
        function obj = calcMemTransform(obj)
            
            for i=1:length(obj.MemberList_array)
                angle  = obj.MemberList_array{i}.angle
                
                alphaX =cos(angle)
                alphaY =sin(angle)
                
                obj.MemberList_array{i}.beta_member =    [alphaX alphaY 0 0 0 0;
                    -alphaY alphaX 0 0 0 0;
                    0 0 1 0 0 0;
                    0 0 0 alphaX alphaY 0;
                    0 0 0 -alphaY alphaX 0;
                    0 0 0 0 0 1]
            end
        end
        
        function obj = calcGlobalStiffnes(obj)
            
            for i=1:length(obj.MemberList_array)
                k_mem = obj.MemberList_array{i}.k_member;
                b_mem = obj.MemberList_array{i}.beta_member;
                
                K_mem = b_mem'*k_mem*b_mem;
                
                obj.MemberList_array{i}.K_member = K_mem;
            end
        end
        %% Create Stiffness Matrix
        function obj = createStiffnessMatrix(obj)
            
            nodes = obj.NumberOfNodes;
            
            % Initial Stiffness Matrix
            obj.StiffnessMatrix= zeros(obj.NumberOfDOFs)
            
            A_RANGE = [1:3]
            B_RANGE = [4:6]
            
            for n=1:length(obj.MemberList_array)
                nodeA = obj.MemberList_array{n}.nodeA.name;
                nAs = ((nodeA-1)*3)+1;
                nAf = ((nodeA-1)*3)+3;
                
                nodeB = obj.MemberList_array{n}.nodeB.name;
                nBs = ((nodeB-1)*3)+1;
                nBf = ((nodeB-1)*3)+3;
                
                
                %K_AA
                obj.StiffnessMatrix(nAs:nAf,nAs:nAf) = ...
                    obj.StiffnessMatrix(nAs:nAf,nAs:nAf) + ...
                    obj.MemberList_array{n}.K_member(A_RANGE,A_RANGE);
                
                %K_AB
                obj.StiffnessMatrix(nAs:nAf,nBs:nBf) = ...
                    obj.StiffnessMatrix(nAs:nAf,nBs:nBf) + ...
                    obj.MemberList_array{n}.K_member(A_RANGE,B_RANGE);
                
                %K_BA
                obj.StiffnessMatrix(nBs:nBf,nAs:nAf) = ...
                    obj.StiffnessMatrix(nBs:nBf,nBs:nBf) + ...
                    obj.MemberList_array{n}.K_member(B_RANGE,A_RANGE);
                
                %K_BB
                obj.StiffnessMatrix(nBs:nBf,nBs:nBf) = ...
                    obj.StiffnessMatrix(nBs:nBf,nBs:nBf) + ...
                    obj.MemberList_array{n}.K_member(B_RANGE,B_RANGE);
            end
        end
        %% Set Node Restraints
        function obj = convertNodeRestraintCodeToDOFVector(obj)
            
            for o=1:length(obj.NodeList_array)
                if(isfield(obj.NodeList_array{o}, 'restraintCode'))
                    nodeRestraintCode = obj.NodeList_array{o}.restraintCode
                    
                    
                    
                    
                    % remove hyphen
                    nodeRestraintCode(3) = [];
                    
                    for p=1:length(nodeRestraintCode)
                        if(nodeRestraintCode(p)=='F')
                            nodeRestraintBool(p)=1;
                        elseif(nodeRestraintCode(p)=='R')
                            nodeRestraintBool(p)=0;
                            
                        else
                            error(strcat('restraint code invalid for node', num2str(o)));
                            
                        end
                        
                    end
                    obj.NodeList_array{o}.restrainedDOFs = nodeRestraintBool
                else
                    disp(strcat('restraint Code not defined for node' , num2str(o)));
                end
                
                
            end
            
            
        end
        %% Set Node Restraints
        function obj = getRestraintDOFVector(obj)
            obj.restrainedDOFs = logical(zeros(1, obj.NumberOfDOFs))
            
            for q=1:length(obj.NodeList_array)
                if(isfield(obj.NodeList_array{q}, 'restrainedDOFs'))
                    
                    index = (q-1)*3+1
                    obj.restrainedDOFs(index:index+2)= obj.NodeList_array{q}.restrainedDOFs
                end
            end
            
        end
        %% Create Reduced Stiffness Matrix
        function obj = calculateReducedStiffnessMatrix(obj)
            if(~isempty(obj.restrainedDOFs))
                obj.ReducedStiffnessMatrix = obj.StiffnessMatrix(~obj.restrainedDOFs,~obj.restrainedDOFs);
                
            else
                disp('Must Define the DOFSs');
            end
            
        end
        %% Calculate Flexibility Matrix
        function obj = calculateFlexibilityMatrix(obj)
            obj.FlexibilityMatrix = inv(obj.StiffnessMatrix);
        end
        %% Calculate Reduced Flexibility Matrix
        function obj = calculateReducedFlexibilityMatrix(obj)
            obj.ReducedFlexibilityMatrix = inv(obj.ReducedStiffnessMatrix)
        end
        %% Define Loads
        function obj = memberUDLs(obj)
            for r=1:length(obj.MemberLoads_array)
                
                if(strcmp(obj.MemberLoads_array{r}.loadType, 'UDL'));
                    
                end
                
                if(strcmp(obj.MemberLoads_array{r}.axis, 'local'));
                    
                end
                
                memberNumber = obj.MemberLoads_array{r}.member;
                
                memberLength = obj.MemberList_array{memberNumber}.length;
                
                
                memberFEM = (obj.MemberLoads_array{r}.magnitude * memberLength^2) /12
                obj.MemberList_array{memberNumber}.FEMnodeA = memberFEM
                obj.MemberList_array{memberNumber}.FEMnodeB = -memberFEM
                
                memberShear = (obj.MemberLoads_array{r}.magnitude * memberLength) /2
                
                obj.MemberList_array{memberNumber}.ShearNodeA = memberShear
                obj.MemberList_array{memberNumber}.ShearNodeB = memberShear
                
                
                obj.MemberList_array{memberNumber}.load = obj.MemberLoads_array{r}
                
            end
            
        end
        
        %% Create Body Load Vector for Members
        function obj = createBodyLoadVector(obj)
            for i = 1:length(obj.MemberList_array)
                
                NodeA = obj.MemberList_array{i}.nodeA.name
                NodeB = obj.MemberList_array{i}.nodeB.name
                memberLoadVector = zeros(1,6);
                
                %NodeAshear = obj.MemberList_array{i}.NodeAShear
                
                % Moment
                if(isfield(obj.MemberList_array{i},'FEMnodeA'))
                    
                    memberLoadVector(3) = obj.MemberList_array{i}.FEMnodeA
                    memberLoadVector(6) = obj.MemberList_array{i}.FEMnodeB
                end
                if(isfield(obj.MemberList_array{i},'ShearNodeA'))
                    % Shears
                    memberLoadVector(2) = obj.MemberList_array{i}.ShearNodeA
                    memberLoadVector(5) = obj.MemberList_array{i}.ShearNodeB
                    
                end
                obj.MemberList_array{i}.bodyLoadVector = memberLoadVector
            end
        end
        
        function obj = createGlobalLoadVector(obj)
            
            GlobalLoadVector = zeros(1,obj.NumberOfDOFs);
            
            for i = 1:length(obj.MemberList_array)
                NodeA = obj.MemberList_array{i}.nodeA.name
                NodeB = obj.MemberList_array{i}.nodeB.name
                memLoadVector = obj.MemberList_array{i}.bodyLoadVector
                
                NodeArange = (NodeA-1)*3+1:NodeA*3
                NodeBrange = (NodeB-1)*3+1:NodeB*3
                
                GlobalLoadVector([NodeArange,NodeBrange]) = memLoadVector
                
            end
            
            obj.GlobalLoadVector = GlobalLoadVector;
            
            
            
        end
        
        %% Reduce Global Load Vector
        function obj = reduceGlobalLoadVector(obj)
            
            obj.reducedGlobalLoadVector = obj.GlobalLoadVector(~obj.restrainedDOFs)
        end
        
        %% Calculate Free Displacements
        function obj = calculateDisplacements(obj)
            
            obj.DisplacementVector = zeros(1,obj.NumberOfDOFs);
            obj.DisplacementVector(~obj.restrainedDOFs) = obj.ReducedFlexibilityMatrix*obj.reducedGlobalLoadVector'
        end
        %%  Calculate Global Forces
        function obj = calculateGlobalForces(obj)
            obj.GlobalForces = obj.DisplacementVector*obj.StiffnessMatrix
        end
        
        %% Calculate Member Body Forces.
        function obj = calculateMemberForces(obj)
            
            for i =1:length(obj.MemberList_array)
                
                NodeA = obj.MemberList_array{i}.nodeA.name
                NodeB = obj.MemberList_array{i}.nodeB.name
                
                NodeArange = (NodeA-1)*3+1:NodeA*3
                NodeBrange = (NodeB-1)*3+1:NodeB*3
                obj.MemberList_array{i}.q = transpose(obj.MemberList_array{i}.k_member'*obj.MemberList_array{i}.beta_member*obj.DisplacementVector([NodeArange, NodeBrange])')
            end
            
        end
        
        
        %% Create Applied Load plot
        function obj = appliedLoadPlots(obj)
            APPLIED_LOAD_SCALE =50;
            
            for i=1:length(obj.MemberList_array)
                
                if(isfield(obj.MemberList_array{i}, 'load'))
                    p0 = [obj.MemberList_array{i}.nodeA.x, obj.MemberList_array{i}.nodeA.y]
                    p2 = p0+ [0,-obj.MemberList_array{i}.load.magnitude*APPLIED_LOAD_SCALE]*obj.MemberList_array{i}.beta_member(1:2,1:2)
                    p4 = [obj.MemberList_array{i}.nodeB.x, obj.MemberList_array{i}.nodeB.y]
                    p3 = p4 + [0,-obj.MemberList_array{i}.load.magnitude*APPLIED_LOAD_SCALE]*obj.MemberList_array{i}.beta_member(1:2,1:2)
                    
                    
                    obj.MemberList_array{i}.appliedLoadPlot = [p0;p2;p3;p4]
                end
            end
        end
        
        %% Create Member Moment plot
        function obj = memberMomentPlot(obj)
            MEMBER_MOMENT_SCALE =.2;
            
            for i=1:length(obj.MemberList_array)
                
                if(isfield(obj.MemberList_array{i}, 'q'))
                    p0 = [obj.MemberList_array{i}.nodeA.x, obj.MemberList_array{i}.nodeA.y]
                    p2 = p0+ [0,-obj.MemberList_array{i}.q(3)*MEMBER_MOMENT_SCALE]*obj.MemberList_array{i}.beta_member(1:2,1:2)
                    p4 = [obj.MemberList_array{i}.nodeB.x, obj.MemberList_array{i}.nodeB.y]
                    p3 = p4 + [0,--obj.MemberList_array{i}.q(6)*MEMBER_MOMENT_SCALE]*obj.MemberList_array{i}.beta_member(1:2,1:2)
                    
                    
                    obj.MemberList_array{i}.momentPlot = [p0;p2;p3;p4]
                end
            end
        end
        
        
        %% Create Member Shear plot
        function obj = memberShearPlot(obj)
            MEMBER_SHEAR_SCALE =.2;
            
            for i=1:length(obj.MemberList_array)
                if(isfield(obj.MemberList_array{i}, 'q'))
                    p0 = [obj.MemberList_array{i}.nodeA.x, obj.MemberList_array{i}.nodeA.y]
                    p2 = p0+ [0,-obj.MemberList_array{i}.q(2)*MEMBER_SHEAR_SCALE]*obj.MemberList_array{i}.beta_member(1:2,1:2)
                    p4 = [obj.MemberList_array{i}.nodeB.x, obj.MemberList_array{i}.nodeB.y]
                    p3 = p4 + [0,--obj.MemberList_array{i}.q(3)*MEMBER_SHEAR_SCALE]*obj.MemberList_array{i}.beta_member(1:2,1:2)
                    
                    
                    obj.MemberList_array{i}.shearPlot = [p0;p2;p3;p4]
                    
                end
            end
        end
        
        %% Create Member Axial plot
        function obj = memberAxialPlot(obj)
            MEMBER_AXIAL_SCALE =.2;
            
            for i=1:length(obj.MemberList_array)
                if(isfield(obj.MemberList_array{i}, 'q'))
                    p0 = [obj.MemberList_array{i}.nodeA.x, obj.MemberList_array{i}.nodeA.y]
                    p2 = p0+ [0,-obj.MemberList_array{i}.q(1)*MEMBER_AXIAL_SCALE]*obj.MemberList_array{i}.beta_member(1:2,1:2)
                    p4 = [obj.MemberList_array{i}.nodeB.x, obj.MemberList_array{i}.nodeB.y]
                    p3 = p4 + [0,--obj.MemberList_array{i}.q(4)*MEMBER_AXIAL_SCALE]*obj.MemberList_array{i}.beta_member(1:2,1:2)
                    
                    
                    obj.MemberList_array{i}.axialPlot = [p0;p2;p3;p4]
                    
                end
            end
        end
        
        
        %% Function Draw the structure
        function obj = draw(obj)
            % Initialise the figure
            obj.structure_plot = figure()
            hold on;
            title('Structure')
            xlabel('meters')
            ylabel('meters')
            
            % Draw nodes
            for i=1:length(obj.NodeList_array)
                scatter(obj.NodeList_array{i}.x, obj.NodeList_array{i}.y);
                text(obj.NodeList_array{i}.x, obj.NodeList_array{i}.y, ...
                    strcat('node: ',num2str(obj.NodeList_array{i}.name)));
                
            end
            % TODO diagram depending on restraint code
            for i=1:length(obj.NodeList_array)
                
                X_OFFSET =.5
                Y_OFFSET = .5
                SCALE = 75
                
                if(isfield(obj.NodeList_array{i}, 'restrainedDOFs'))
                    % x restraint plot '>'
                    if(obj.NodeList_array{i}.restrainedDOFs(1))
                        scatterX = scatter(obj.NodeList_array{i}.x-X_OFFSET*SCALE, obj.NodeList_array{i}.y);
                        scatterX.Marker = '>';
                        scatterX.SizeData = 200;
                    end
                    
                    % y restraint plot '^'
                    if(obj.NodeList_array{i}.restrainedDOFs(2))
                        scatterY = scatter(obj.NodeList_array{i}.x, obj.NodeList_array{i}.y-Y_OFFSET*SCALE);
                        scatterY.Marker = '^';
                        scatterY.SizeData = 200;
                    end
                    
                    % z rotation restraint plot 'square'
                    if(obj.NodeList_array{i}.restrainedDOFs(3))
                        scatterZ = scatter(obj.NodeList_array{i}.x, obj.NodeList_array{i}.y);
                        scatterZ.Marker = 's';
                        scatterZ.SizeData = 200;
                    end
                    
                    
                end
            end
            
            
            % Draw Members
            for i=1:length(obj.MemberList_array)
                line([obj.MemberList_array{i}.nodeA.x, ...
                    obj.MemberList_array{i}.nodeB.x], ...
                    [obj.MemberList_array{i}.nodeA.y, ...
                    obj.MemberList_array{i}.nodeB.y]);
                
                
                text([(obj.MemberList_array{i}.nodeB.x - ...
                    obj.MemberList_array{i}.nodeA.x)/2 + ...
                    obj.MemberList_array{i}.nodeA.x], ...
                    [(obj.MemberList_array{i}.nodeB.y - ...
                    obj.MemberList_array{i}.nodeA.y)/2 + ...
                    obj.MemberList_array{i}.nodeA.y], 'member name here' );
                
            end
            % TODO change colour for member type
            
            % Draw Applied Forces
            
            for i=1:length(obj.MemberList_array)
                if(isfield(obj.MemberList_array{i}, 'appliedLoadPlot'))
                    
                    loadCoords = obj.MemberList_array{i}.appliedLoadPlot
                    plot(loadCoords(:,1),loadCoords(:,2))
                end
            end
            
            %{
for i=1:length(obj.MemberLoads_array)
                member = obj.MemberLoads_array{i}.member;
                type = obj.MemberLoads_array{i}.loadType;
                axis = obj.MemberLoads_array{i}.axis;
                mag = obj.MemberLoads_array{i}.magnitude;
                
                nodeA = obj.MemberList_array{member}.nodeA
                nodeB = obj.MemberList_array{member}.nodeB
                
                if(strcmp(type,'UDL') && strcmp(axis,'local'))
                    for j=1:10
                        p0 = [nodeA.x+j*20, nodeA.y]
                        p1 = [nodeA.x+j*20, nodeA.y+mag*100]
                        
                        vectarrow(p0,p1)
                        
                    end
                end
                
                
            end
            %}
            
            % Draw Reactions
            
            for i=1: length(obj.NodeList_array)
                p0x =[]
                p1x =[]
                p0y =[]
                p1y =[]
                
                
                % X reaction
                p0x = [obj.NodeList_array{i}.x,obj.NodeList_array{i}.y]
                p1x = p0x + [obj.GlobalForces((i-1)*3+1),0]
                
                px = [p0x;p1x]
                line(px(:,1),px(:,2))
                
                
                % Y reaction
                p0y = [obj.NodeList_array{i}.x,obj.NodeList_array{i}.y]
                p1y = p0y + [0 obj.GlobalForces((i-1)*3+2)]
                
                py = [p0y;p1y]
                line(py(:,1),py(:,2))
                
            end
            
            % Draw Deflections
            
            
            % Draw Shear Forces
            for i=1: length(obj.MemberList_array)
                coords = obj.MemberList_array{i}.shearPlot
                line(coords(:,1),coords(:,2))
                
            end
            % Draw BMDs
            for i=1: length(obj.MemberList_array)
                coords = obj.MemberList_array{i}.momentPlot
                line(coords(:,1),coords(:,2))
                
            end
            % Draw Axial Foces
            for i=1: length(obj.MemberList_array)
                coords = obj.MemberList_array{i}.axialPlot
                line(coords(:,1),coords(:,2))
                
            end
            
            
            % Adjust Axis to centre structure
            ax = gca;
            %ax.XLim
            
            axis_min = min([ax.XLim ax.YLim])
            axis_max = max([ax.XLim ax.YLim])
            range = axis_max-axis_min
            padding = range/5
            axisLimits = [axis_min-padding, axis_max+padding]
            %axis([axisLimits axisLimits])
            
            hold off;
            
            %save('structurePlot.mat', 'structure_plot')
        end % End draw method
        
        
        %% Select an element
        function [x y button] = mouseClick(obj)
            [xmouse,ymouse,button] = ginput(1);
            
            closestMemberDist = []
            closestMember = []
            
            closestNodeDist = []
            closestNode = []
            % Find Nearest Element
            for i=1:length(obj.MemberList_array)
                xc = ((obj.MemberList_array{i}.nodeA.x-obj.MemberList_array{i}.nodeB.x)/2+obj.MemberList_array{i}.nodeA.x)
                yc = ((obj.MemberList_array{i}.nodeA.y-obj.MemberList_array{i}.nodeB.y)/2+obj.MemberList_array{i}.nodeA.y)
                
                dist = sqrt((xmouse-xc)^2+(ymouse-yc)^2)
                
                if(isempty(closestMemberDist) || dist<closestMemberDist)
                    closestMemberDist=dist
                    closestMember = i
                end
            end
            
            %
            for j=1:length(obj.NodeList_array)
                xc = obj.NodeList_array{j}.x
                yc = obj.NodeList_array{j}.y
                
                dist = sqrt((xmouse-xc)^2+(ymouse-yc)^2)
                
                if(isempty(closestNodeDist) || dist<closestNodeDist)
                    closestNodeDist=dist
                    closestNode = j
                end
            end
            
            if(closestMemberDist<closestNodeDist)
                fn_structdisp(obj.MemberList_array{closestMember})
            elseif(closestMemberDist>closestNodeDist)
                fn_structdisp(obj.NodeList_array{closestNode})
            else
                error('')
            end
            
            
            
        end
        
    end
end





