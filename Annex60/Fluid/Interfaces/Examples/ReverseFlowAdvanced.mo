within Annex60.Fluid.Interfaces.Examples;
model ReverseFlowAdvanced
  "Advanced example where simplifications should be made when allowFlowReversal = false"
  extends Modelica.Icons.Example;
  package Medium = Annex60.Media.Water;
  parameter Boolean allowFlowReversal=false
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Evaluate=true);
  Modelica.Blocks.Sources.Ramp ramp1(
    height=-1,
    duration=1,
    offset=1) "First mass flow rate ramp"
    annotation (Placement(transformation(extent={{-80,18},{-60,38}})));
  Annex60.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1,
    ports(m_flow(max={0}))) "Source 1"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

  Annex60.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1,
    ports(m_flow(max={0}))) "Source 2"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Annex60.Fluid.MixingVolumes.MixingVolume vol(
    nPorts=2,
    allowFlowReversal=allowFlowReversal,
    prescribedHeatFlowRate=true,
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    V=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Steady state mixing volume"
         annotation (Placement(transformation(extent={{50,0},{70,20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{0,42},{20,62}})));
  Modelica.Blocks.Sources.RealExpression reaExp(y=port_a.h_outflow^2/1000000)
    "A non-linear function"
    annotation (Placement(transformation(extent={{-80,42},{-20,62}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    duration=1,
    offset=1,
    height=1) "First mass flow rate ramp"
    annotation (Placement(transformation(extent={{-80,-22},{-60,-2}})));
  Annex60.Fluid.Sources.Boundary_pT sin(          redeclare package Medium =
        Medium, nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{102,-10},{82,10}})));
protected
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium) "Port for mixing"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
public
  Annex60.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=1)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation
  connect(preHeaFlo.port, vol.heatPort)
    annotation (Line(points={{20,52},{50,52},{50,10}}, color={191,0,0}));
  connect(reaExp.y, preHeaFlo.Q_flow)
    annotation (Line(points={{-17,52},{-17,52},{0,52}}, color={0,0,127}));
  connect(ramp2.y, sou2.m_flow_in)
    annotation (Line(points={{-59,-12},{-50,-12},{-40,-12}}, color={0,0,127}));
  connect(ramp1.y, sou1.m_flow_in)
    annotation (Line(points={{-59,28},{-48,28},{-40,28}}, color={0,0,127}));
  connect(sou2.ports[1], port_a)
    annotation (Line(points={{-20,-20},{0,-20},{0,0}}, color={0,127,255}));
  connect(sou1.ports[1], port_a)
    annotation (Line(points={{-20,20},{0,20},{0,0}}, color={0,127,255}));
  connect(vol.ports[1], senTem.port_b)
    annotation (Line(points={{58,0},{40,0}}, color={0,127,255}));
  connect(senTem.port_a, port_a)
    annotation (Line(points={{20,0},{0,0}}, color={0,127,255}));
  connect(vol.ports[2],sin. ports[1])
    annotation (Line(points={{62,0},{62,0},{82,0}}, color={0,127,255}));
  annotation (                                                         Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})), Documentation(revisions="<html>
<ul>
<li>
June 30, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end ReverseFlowAdvanced;
