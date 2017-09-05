%% Unperturbed Earth-orbiting Satellite

clc; clear;
tudat.load();


%% SET UP

simulation = Simulation(0,constants.secondsInOne.julianDay);
simulation.spice = Spice('pck00009.tpc','de-403-masses.tpc','de421.bsp');

% Bodies
asterix = Body('asterix');
asterix.initialState.semiMajorAxis = '7500 km';
asterix.initialState.eccentricity = 0.1;
asterix.initialState.inclination = '85.3 deg';
asterix.initialState.argumentOfPeriapsis = '235.7 deg';
asterix.initialState.longitudeOfAscendingNode = '23.4 deg';
asterix.initialState.trueAnomaly = '139.87 deg';
simulation.addBodies(Earth,asterix);
simulation.bodies.Earth.ephemeris = ConstantEphemeris(zeros(6,1));

% Propagator
propagator = TranslationalPropagator();
propagator.centralBodies = Earth;
propagator.bodiesToPropagate = asterix;
propagator.accelerations.asterix.Earth = PointMassGravity();
simulation.propagator = propagator;

% Integrator
simulation.integrator.type = Integrators.rungeKutta4;
simulation.integrator.stepSize = 10;


%% RUN

simulation.run();


%% RESULTS

% Plot distance to Earth's CoM
[t,r,~] = compute.epochPositionVelocity(simulation.results.numericalSolution);
plot(convert.epochToDate(t),compute.normPerRows(r)/1e3); grid on; ylabel('Distance [km]');

% Unperturbed orbit: check that the Keplerian elements stay constant
[~,a,e,i,omega,raan,~] = compute.epochKeplerianElements(simulation.results.numericalSolution);
tolerance = 1e-7;
[all(abs(a-a(1)) < tolerance*a(1)) all(abs(e-e(1)) < tolerance) all(abs(i-i(1)) < tolerance) ...
    all(abs(omega-omega(1)) < tolerance) all(abs(raan-raan(1)) < tolerance)]

