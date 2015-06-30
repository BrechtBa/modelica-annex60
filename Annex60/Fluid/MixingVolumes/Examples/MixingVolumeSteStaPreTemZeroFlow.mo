within Annex60.Fluid.MixingVolumes.Examples;
model MixingVolumeSteStaPreTemZeroFlow
  "Steady state mixing volume with prescribed temperature boundary condition at zero flow"
  extends Modelica.Icons.Example;
  package Medium = Annex60.Media.Air;
  IDEAS.Fluid.MixingVolumes.MixingVolume         vol(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=4,
    V=10,
    nPorts=2,
    allowFlowReversal=false,
    redeclare package Medium = Medium,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Steady state mixing volume"
         annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={2,-30})));
  Annex60.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    use_T_in=true,
    m_flow=1,
    nPorts=1,
    use_m_flow_in=true) "Source" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,10})));
  Modelica.Blocks.Sources.Ramp ramp_T_in(
    height=10,
    duration=1,
    offset=283.15) "Ramp for inlet temperature"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Annex60.Fluid.Sources.Boundary_pT sin(nPorts=1, redeclare package Medium =
        Medium) "Sink"
    annotation (Placement(transformation(extent={{80,-30},{60,-10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem
    "Prescribed temperature"
    annotation (Placement(transformation(extent={{-50,-20},{-30,0}})));
  Modelica.Blocks.Sources.Ramp ramp_T_out(
    height=5,
    duration=1,
    offset=283.15) "Ramp for outlet temperature"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.Ramp ramp_m_flow(
    duration=1,
    height=-1,
    offset=1) "Ramp for mass flow rate"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
equation
  connect(ramp_T_in.y, sou.T_in) annotation (Line(points={{-59,30},{-40,30},{-16,
          30},{4,30},{4,22}}, color={0,0,127}));
  connect(sou.ports[1], vol.ports[1])
    annotation (Line(points={{0,0},{0,0},{0,-20}}, color={0,127,255}));
  connect(sin.ports[1], vol.ports[2])
    annotation (Line(points={{60,-20},{26,-20},{4,-20}},
                                                       color={0,127,255}));
  connect(preTem.port, vol.heatPort)
    annotation (Line(points={{-30,-10},{-8,-10},{-8,-30}}, color={191,0,0}));
  connect(ramp_T_out.y, preTem.T)
    annotation (Line(points={{-59,-10},{-52,-10}}, color={0,0,127}));
  connect(ramp_m_flow.y, sou.m_flow_in) annotation (Line(points={{-59,70},{-44,70},
          {-20,70},{8,70},{8,20}}, color={0,0,127}));
  annotation (                 Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})),
    experiment(StopTime=2, __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput,
    Documentation(revisions="<html>
<ul>
<li>
June 30, 2015 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This example tests the mixing volume model at zero flow 
when a fixed temperature boundary condition is connected to
the mixing volume. No division by zero should occur.
</p>
</html>"));
end MixingVolumeSteStaPreTemZeroFlow;
