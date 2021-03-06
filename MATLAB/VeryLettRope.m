
p1 = [ 0 0  0.01 ];
p2 = [ 1 0  0.02 ];
p3 = [ 2 0  0.03 ];
p4 = [ 3 0  0.04 ];

m = 0.05;

k = 100;

dampening = 0;

sd1_2 = dist(p1, p2);
sd2_3 = dist(p2, p3);
sd3_4 = dist(p3, p4);

% Delta time, how fast the render loop runs
timeStep = 0.04;

% Sim time. How fast one simulation step runs
st = 0.005;

% Container for tracking remainder of simulation time
remainder = 0;

% How long to run the simulation for
simTime = 4;

% Render loop count
timeSteps = floor(simTime / timeStep);

g = [0 -9.82 0];

v1 = zeros(1, 3);
v2 = zeros(1, 3);
v3 = zeros(1, 3);
v4 = zeros(1, 3);

c1 = 0;
c2 = 1;
c3 = 1;
c4 = 1;

for i = 1:timeSteps
	% Calculate delta time and number of sim steps
	dt = timeStep+remainder;
	simSteps = floor(dt / st);
	remainder = dt - simSteps*st;
	
	% Solve the links
	for u = 1:simSteps
		% Apply gravity
		v1 = v1 + g * m * st;
		v2 = v2 + g * m * st;
		v3 = v3 + g * m * st;
		v4 = v4 + g * m * st;
		
		% Sum up all forces acting on each node
		d1_2 = dist(p1, p2);
		d2_3 = dist(p2, p3);
		d3_4 = dist(p3, p4);
		
		% Link 1
		v2 = v2 + direction(p2, p1) * (d1_2 - sd1_2) * k * st;
		v2 = v2 + direction(p2, p3) * (d2_3 - sd2_3) * k * st;
		
		% Link 2
		v3 = v3 + direction(p3, p2) * (d2_3 - sd2_3) * k * st;
		v3 = v3 + direction(p3, p4) * (d3_4 - sd3_4) * k * st;
		
		% Link 3
		v4 = v4 + direction(p4, p3) * (d3_4 - sd3_4) * k * st;
		
		% Shit dampening
		dampen = max(1 - st * dampening, 0);
		v1 = v1 * dampen;
		v2 = v2 * dampen;
		v3 = v3 * dampen;
		v4 = v4 * dampen;
		
		% Apply forces (velocities)
		p1 = p1 + v1 * c1;
		p2 = p2 + v2 * c2;
		p3 = p3 + v3 * c3;
		p4 = p4 + v4 * c4;
		
	end
	
	% Draw some shit
	clf
	hold on
	% Nodes
	plot( p1(1), p1(2), 'o' );
	plot( p2(1), p2(2), 'o' );
	plot( p3(1), p3(2), 'o' );
	plot( p4(1), p4(2), 'o' );
	% Links
	plot ( [p1(1) p2(1)], [p1(2) p2(2)] );
	plot ( [p2(1) p3(1)], [p2(2) p3(2)] );
	plot ( [p3(1) p4(1)], [p3(2) p4(2)] );
	
	axis([-5 5 -5 2]);
	
	pause(timeStep)
end