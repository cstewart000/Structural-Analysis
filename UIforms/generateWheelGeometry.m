%function generateWheelGeometry()

%% Definitions
INPUT_BOOL = 0;
NODE_FIXITY_COL = 5;
NODE_FIXITY_VAL = 111;

MEMBER_SEC_COL = 4;
MEMBER_MAT_COL = 5;

SPOKES_MAT_NUM =1;
RIM_MAT_NUM =2;

SPOKES_SEC_NUM =1;
RIM_SEC_NUM =2;


%% Inputs
if(INPUT_BOOL==0)
    
    numSpokes = 36;
    erd=600
    hubWidth = 60
    hubDia = 60
elseif(INPUT_BOOL==1)
    
    %prompt user for inputs
    numSpokes = input('enter number of spokes:      ');
    erd =       input('enter erd in mm:             ');
    hubWidth =  input('enter hub width in mm: 		');
    hubDia =    input('enter hub diameter in mm:	');
end


%hubDia = input('enter hub dia in mm: 		')


%Generate hub nodes (front)
hubNodesFront = zeros(numSpokes/2,5);

for i=1:numSpokes/2
    
    alpha = 30;
    
    hubNodesFront(i,1) = i;
    hubNodesFront(i,2) = (hubDia/2)*cos(i*2*pi/(numSpokes/2)+alpha);
    hubNodesFront(i,3) = (hubDia/2)*sin(i*2*pi/(numSpokes/2)+alpha);
    hubNodesFront(i,4) = hubWidth/2;
    hubNodesFront(i,NODE_FIXITY_COL) = NODE_FIXITY_VAL;
end
hubNodesFront;

%Generate hub nodes (rear)
hubNodesRear = zeros(numSpokes/2,4);

for i=1:numSpokes/2
    
    alpha = -30;
    
    hubNodesRear(i,1) = i;
    hubNodesRear(i,2) = (hubDia/2)*cos(i*2*pi/(numSpokes/2)+alpha);
    hubNodesRear(i,3) = (hubDia/2)*sin(i*2*pi/(numSpokes/2)+alpha);
    hubNodesRear(i,4) = -hubWidth/2;
    hubNodesRear(i,NODE_FIXITY_COL) = NODE_FIXITY_VAL;
    
end
hubNodesRear


%Generate rim nodes (rear)
rimNodes = zeros(numSpokes/2,4);

for i=1:numSpokes
    
    rimNodes(i,1) = i;
    rimNodes(i,2) = (erd/2)*cos(i*2*pi/(numSpokes));
    rimNodes(i,3) = (erd/2)*sin(i*2*pi/(numSpokes));
    rimNodes(i,4) = 0;
    
    % Wheel Rim is unrestrianed
    rimNodes(i,NODE_FIXITY_COL) = 0
    
end
rimNodes

%aggregate the nodes

wheelNodes = [hubNodesFront; hubNodesRear; rimNodes];

%Rename nodes

for i=1:2*numSpokes
    wheelNodes(i,1) = i;
    
end
wheelNodes


%Plot the wheel

%clf;
%x = wheelNodes(:,2);  y = wheelNodes(:,3);  z = wheelNodes(:,4);
%hold on;
%scatter3 (x(:), y(:), z(:), 10, z(:), 'c');
%title ({'scatter3() plot', 'marker is square, size is 10, color determined by Z'});
%vectarrow ([50,50,0], [300,300,0]);
%hold off;

%PLot the wheel

%axis ([-400, 400)
hold on;
for i=1:numSpokes
    
    %Plot one layer of the spokes
    if(i<numSpokes/2)
        x1=wheelNodes(i,2);
        y1=wheelNodes(i,3);
        
        x2=wheelNodes(numSpokes/2+i,2);
        y2=wheelNodes(numSpokes/2+i,3);
        %plot([x1,x2],[y1,y2], 'color', 'r')
    end
    
    %Plot the other layer of the spokes
    if(i>=numSpokes/2)
        x1=wheelNodes(i,2);
        y1=wheelNodes(i,3);
        
        if(i<numSpokes*2)
            x2=wheelNodes(numSpokes/2+i-1,2);
            y2=wheelNodes(numSpokes/2+i-1,3);
        end
        
        if(i==numSpokes*2)
            x2=wheelNodes(numSpokes/2,2);
            y2=wheelNodes(numSpokes/2,3);
        end
        
        
        %plot([x1,x2],[y1,y2], 'color', 'b')
    end
    
    %Plot the outter rim
    if(i>numSpokes && i <=numSpokes*2)
        x1=wheelNodes(i,2);
        y1=wheelNodes(i,3);
        x2=wheelNodes(i+1,2);
        y2=wheelNodes(i+1,3);
        %plot([x1,x2],[y1,y2], 'color', 'y')
    end
end
hold off;

%spokeDia = input('enter diameter of spokes 	')
spokeDia = 3;

members = zeros(numSpokes*2,3);
%index 1 - member_no, 2 -, from node, 3- to node

for i=1:numSpokes*2
    
    members(i,1) = i;
    
    %Spokes
    if(i<numSpokes)
        fromNode=wheelNodes(i,1);
        toNode=wheelNodes(numSpokes+i,1);
        members(i,2) = fromNode;
        members(i,3) = toNode;
        
        members(i,MEMBER_SEC_COL) = SPOKES_SEC_NUM
        members(i,MEMBER_MAT_COL) = SPOKES_MAT_NUM
    end
    
    %Rim Section
    if(i>=numSpokes && i ~=numSpokes*2)
        fromNode=wheelNodes(i,1);
        toNode=wheelNodes(i+1,1);
        members(i,2) = fromNode;
        members(i,3) = toNode;
        
        members(i,MEMBER_SEC_COL) = RIM_SEC_NUM
        members(i,MEMBER_MAT_COL) = RIM_MAT_NUM
    end
    if(i==numSpokes*2) % join last node to first
        fromNode=wheelNodes(i,1);
        toNode=wheelNodes(numSpokes+1,1);
        members(i,2) = fromNode;
        members(i,3) = toNode;
        
        members(i,MEMBER_SEC_COL) = RIM_SEC_NUM
        members(i,MEMBER_MAT_COL) = RIM_MAT_NUM
    end
end

figure()
scatter3(wheelNodes(:,2),wheelNodes(:,3),wheelNodes(:,4))
%Output the file

nodeData = wheelNodes(:,2:end)
memberData = members(:,2:end)

save('nodeData.mat', 'nodeData');
save('memberData.mat', 'memberData');



%end