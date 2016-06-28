within Annex60.Fluid.Storage;
model Stratified "Model of a stratified tank for thermal energy storage"
  extends Annex60.Fluid.Interfaces.PartialTwoPortInterface;

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialSimpleMedium;
  import Modelica.Fluid.Types;
  import Modelica.Fluid.Types.Dynamics;
  parameter Modelica.SIunits.Volume VTan "Tank volume";
  parameter Modelica.SIunits.Length hTan "Height of tank (without insulation)";
  parameter Modelica.SIunits.Length dIns "Thickness of insulation";
  parameter Modelica.SIunits.ThermalConductivity kIns = 0.04
    "Specific heat conductivity of insulation";

  parameter Modelica.SIunits.Length h_port_a(min=0, max=hTan)
    "Height of inlet/outlet port_a compared to bottom tank";
  parameter Modelica.SIunits.Length h_port_b(min=0, max=hTan)
    "Height of inlet/outlet port_a compared to bottom tank";
  parameter Modelica.SIunits.Length d "Diameter of inlets";

  parameter Integer nSeg(min=2) = 50
    "Number of volume segments   why do you use Seg here and Lay everywhere else";

  ////////////////////////////////////////////////////////////////////
  // Assumptions
  parameter Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Formulation of energy balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Types.Dynamics massDynamics=energyDynamics
    "Formulation of mass balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  // Initialization
  parameter Medium.AbsolutePressure p_start = Medium.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.Temperature T_start=Medium.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.MassFraction X_start[Medium.nX] = Medium.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=Medium.nXi > 0));
  parameter Medium.ExtraProperty C_start[Medium.nC](
       quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));

  // Dynamics
  parameter Modelica.SIunits.Time tau=1 "Time constant for mixing";

  ////////////////////////////////////////////////////////////////////
  // Connectors

  Modelica.Blocks.Interfaces.RealOutput Ql_flow
    "Heat loss of tank (positive if heat flows from tank to ambient)"
    annotation (Placement(transformation(extent={{100,62},{120,82}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nSeg] heaPorVol
    "Heat port of fluid volumes"
    annotation (Placement(transformation(extent={{-6,-6},{6,6}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorSid
    "Heat port tank side (outside insulation)"
    annotation (Placement(transformation(extent={{62,30},{74,42}}),
        iconTransformation(extent={{40,-6},{52,6}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorTop
    "Heat port tank top (outside insulation)"
    annotation (Placement(transformation(extent={{38,84},{50,96}}),
        iconTransformation(extent={{8,72},{20,84}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorBot
    "Heat port tank bottom (outside insulation). Leave unconnected for adiabatic condition"
    annotation (Placement(transformation(extent={{40,12},{52,24}}),
        iconTransformation(extent={{8,-84},{20,-72}})));

  // Models
  Annex60.Fluid.MixingVolumes.MixingVolume[nSeg] vol(
    redeclare each package Medium = Medium,
    each energyDynamics=energyDynamics,
    each massDynamics=massDynamics,
    each p_start=p_start,
    each T_start=T_start,
    each X_start=X_start,
    each C_start=C_start,
    V=geometry.VLay,
    nPorts=5,
    each m_flow_nominal=m_flow_nominal,
    each final mSenFac=1,
    each final m_flow_small=m_flow_small,
    each final allowFlowReversal=allowFlowReversal) "Tank segment"
    annotation (Placement(transformation(extent={{6,-16},{26,4}})));

  BaseClasses.QuickConvectionDiscretization str(
    redeclare package Medium = Medium,
    nSeg=nSeg,
    m_flow_small=m_flow_small)
    annotation (Placement(transformation(extent={{-20,-52},{0,-32}})));
protected
  constant Integer nPorts = 2 "Number of ports of volume";

  parameter Medium.ThermodynamicState sta_default = Medium.setState_pTX(
    T=Medium.T_default,
    p=Medium.p_default,
    X=Medium.X_default[1:Medium.nXi]) "Medium state at default properties";
  parameter Modelica.SIunits.Length hSeg = hTan / nSeg
    "Height of a tank segment";                           // this is correct but does not correspond to equal volumes above
  parameter Modelica.SIunits.Area ATan = VTan/hTan
    "Tank cross-sectional area (without insulation)";
  parameter Modelica.SIunits.Length rTan = sqrt(ATan/Modelica.Constants.pi)
    "Tank diameter (without insulation)"; // confusion notation rTan for diameter
  parameter Modelica.SIunits.ThermalConductance conFluSeg = ATan*Medium.thermalConductivity(sta_default)/hSeg
    "Thermal conductance between fluid volumes";
  parameter Modelica.SIunits.ThermalConductance conTopSeg = ATan*kIns/dIns
    "Thermal conductance from center of top (or bottom) volume through tank insulation at top (or bottom)";

  Annex60.Fluid.Sensors.EnthalpyFlowRate H_a_flow(
    redeclare package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final tau=0,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_small=m_flow_small) "Enthalpy flow rate at port a"
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
  Annex60.Fluid.Sensors.EnthalpyFlowRate[nSeg - 1] H_vol_flow(
    redeclare package Medium = Medium,
    each final m_flow_nominal=m_flow_nominal,
    each final tau=0,
    each final allowFlowReversal=allowFlowReversal,
    each final m_flow_small=m_flow_small)
    "Enthalpy flow rate between the volumes"
    annotation (Placement(transformation(extent={{2,-92},{22,-72}})));
  Annex60.Fluid.Sensors.MassFlowRate[nSeg - 1] m_vol_flow(
    redeclare package Medium = Medium) "Mass flow rate between the volumes"
    annotation (Placement(transformation(extent={{-28,-92},{-8,-72}})));

  Annex60.Fluid.Sensors.EnthalpyFlowRate H_b_flow(
    redeclare package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final tau=0,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_small=m_flow_small) "Enthalpy flow rate at port b"
    annotation (Placement(transformation(extent={{70,-90},{90,-70}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor[nSeg - 1] conFlu(
    each G=conFluSeg) "Thermal conductance in fluid between the segments"
    annotation (Placement(transformation(extent={{-56,4},{-42,18}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor[nSeg] conWal(
     each G=2*Modelica.Constants.pi*kIns*hSeg/Modelica.Math.log((rTan+dIns)/rTan))
    "Thermal conductance through tank wall"
    annotation (Placement(transformation(extent={{10,50},{20,62}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conTop(
     G=conTopSeg) "Thermal conductance through tank top"
    annotation (Placement(transformation(extent={{10,70},{20,82}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conBot(
     G=conTopSeg) "Thermal conductance through tank bottom"
    annotation (Placement(transformation(extent={{10,30},{20,42}})));

  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloTop
    "Heat flow at top of tank (outside insulation)"
    annotation (Placement(transformation(extent={{30,70},{42,82}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloBot
    "Heat flow at bottom of tank (outside insulation)"
    annotation (Placement(transformation(extent={{30,30},{42,42}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloSid[nSeg]
    "Heat flow at wall of tank (outside insulation)"
    annotation (Placement(transformation(extent={{30,50},{42,62}})));

  Modelica.Blocks.Routing.Multiplex3 mul(
    n1=1,
    n2=nSeg,
    n3=1) "Multiplex to collect heat flow rates"
    annotation (Placement(transformation(extent={{62,62},{70,72}})));
  Modelica.Blocks.Math.Sum sum1(nin=nSeg + 2)
  annotation (Placement(transformation(extent={{78,60},{90,74}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theCol(m=nSeg)
    "Connector to assign multiple heat ports to one heat port"
    annotation (Placement(transformation(extent={{46,36},{58,48}})));
public
  BaseClasses.GeometryKlopper geometry(
    VTan=VTan,
    hTan=hTan,
    nLay=nSeg);

  BaseClasses.JetInflow jetInflow(
    redeclare package Medium = Medium,
    nSeg=nSeg,
    m_flow_nominal=m_flow_nominal,
    Vlay=vol.V,
    D=geometry.dTan,
    hTan=hTan,
    hIn=h_port_a,
    d=d,
    hLay={(i - 0.5)*hTan/nSeg for i in 1:nSeg})
    annotation (Placement(transformation(extent={{-66,-90},{-46,-70}})));
  BaseClasses.JetInflow outflow(
    redeclare package Medium = Medium,
    nSeg=nSeg,
    m_flow_nominal=m_flow_nominal,
    Vlay=vol.V,
    hIn=h_port_b,
    D=geometry.dTan,
    hTan=hTan,
    d=d,
    hLay={(i - 0.5)*hTan/nSeg for i in 1:nSeg})
    annotation (Placement(transformation(extent={{66,-90},{46,-70}})));

equation
  connect(H_b_flow.port_b, port_b) annotation (Line(points={{90,-80},{92,-80},{92,
          0},{100,0}},                     color={0,127,255}));
  for i in 1:(nSeg-1) loop

    connect(vol[i].ports[3], m_vol_flow[i].port_a) annotation (Line(points={{16,-16},
            {16,-22},{-38,-22},{-38,-82},{-28,-82}},      color={0,127,255}));

    connect(m_vol_flow[i].port_b, H_vol_flow[i].port_a) annotation (Line(points={{-8,-82},
            {34,-82},{34,-22},{20,-22},{20,-82},{2,-82}},color={0,127,255}));
    connect(H_vol_flow[i].port_b, vol[i + 1].ports[if i==nSeg -1 then 3 else 4]) annotation (Line(points={{22,-82},
            {34,-82},{34,-22},{20,-22},{20,-16},{16,-16}},
                                                         color={0,127,255}));
  end for;
   connect(port_a, H_a_flow.port_a) annotation (Line(points={{-100,0},{-92,0},{-92,
          -80},{-90,-80}},                       color={0,127,255}));
  for i in 1:nSeg-1 loop
  // heat conduction between fluid nodes
     connect(vol[i].heatPort, conFlu[i].port_a)    annotation (Line(points={{6,-6},{
            6,-6},{-60,-6},{-60,10},{-56,10},{-56,11}},    color={191,0,0}));
    connect(vol[i+1].heatPort, conFlu[i].port_b)    annotation (Line(points={{6,-6},{
            -40,-6},{-40,11},{-42,11}},  color={191,0,0}));
  end for;

  connect(vol[1].heatPort, conTop.port_a)    annotation (Line(points={{6,-6},{6,
          76},{10,76}},                      color={191,0,0}));
  connect(vol.heatPort, conWal.port_a)    annotation (Line(points={{6,-6},{6,56},
          {10,56}},                      color={191,0,0}));
  connect(conBot.port_a, vol[nSeg].heatPort)    annotation (Line(points={{10,36},
          {10,36},{6,36},{6,-6}},
                               color={191,0,0}));
  connect(vol.heatPort, heaPorVol)    annotation (Line(points={{6,-6},{6,-6},{
          -2.22045e-16,-6},{-2.22045e-16,-2.22045e-16}},
        color={191,0,0}));
  connect(conWal.port_b, heaFloSid.port_a)
    annotation (Line(points={{20,56},{30,56}}, color={191,0,0}));

  connect(conTop.port_b, heaFloTop.port_a)
    annotation (Line(points={{20,76},{30,76}}, color={191,0,0}));
  connect(conBot.port_b, heaFloBot.port_a)
    annotation (Line(points={{20,36},{30,36}}, color={191,0,0}));
  connect(heaFloTop.port_b, heaPorTop) annotation (Line(points={{42,76},{42,90},
          {44,90}},         color={191,0,0}));
  connect(heaFloBot.port_b, heaPorBot) annotation (Line(points={{42,36},{44,36},
          {44,18},{46,18}},   color={191,0,0}));
  connect(heaFloTop.Q_flow, mul.u1[1]) annotation (Line(points={{36,70},{50,70},
          {50,70.5},{61.2,70.5}}, color={0,0,127}));
  connect(heaFloSid.Q_flow, mul.u2) annotation (Line(points={{36,50},{50,50},{50,
          67},{61.2,67}},    color={0,0,127}));
  connect(heaFloBot.Q_flow, mul.u3[1]) annotation (Line(points={{36,30},{36,28},
          {58,28},{58,63.5},{61.2,63.5}}, color={0,0,127}));
  connect(mul.y, sum1.u) annotation (Line(points={{70.4,67},{76.8,67}}, color={
          0,0,127}));
  connect(sum1.y, Ql_flow) annotation (Line(points={{90.6,67},{98,67},{98,72},{110,
          72}},     color={0,0,127}));
  connect(heaFloSid.port_b, theCol.port_a) annotation (Line(
      points={{42,56},{52,56},{52,48}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theCol.port_b, heaPorSid) annotation (Line(
      points={{52,36},{68,36}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(jetInflow.port_a, H_a_flow.port_b)
    annotation (Line(points={{-66,-80},{-70,-80}}, color={0,127,255}));
  connect(outflow.port_a, H_b_flow.port_a)
    annotation (Line(points={{66,-80},{70,-80}},          color={0,127,255}));
  connect(jetInflow.ports_b[1:nSeg], vol[1:nSeg].ports[1])    annotation (Line(points={{-46,-80},
          {-46,-16},{12.8,-16}},             color={0,127,255}));
  connect(outflow.ports_b[1:nSeg], vol[1:nSeg].ports[2])    annotation (Line(points={{46,-80},
          {46,-16},{14.4,-16}},              color={0,127,255}));

  // str connections
  connect(str.m_flow, m_vol_flow.m_flow) annotation (Line(points={{-22,-33.8},{-34,
          -33.8},{-34,-71},{-18,-71}}, color={0,0,127}));
  connect(str.H_flow, H_vol_flow.H_flow) annotation (Line(points={{-22,-50},{-28,
          -50},{-28,-66},{12,-66},{12,-71}}, color={0,0,127}));
  connect(str.heatPort, heaPorVol) annotation (Line(points={{0,-42},{8,-42},{8,-28},
          {0,-28},{0,0}}, color={191,0,0}));
  for i in 1:nSeg loop
    connect(vol[i].ports[5], str.fluidPort[i]);
  end for;

       annotation (
defaultComponentName="tan",
Documentation(info="<html>
<p>
This is a model of a stratified storage tank.
</p>
<p>
See the
<a href=\"modelica://Buildings.Fluid.Storage.UsersGuide\">
Buildings.Fluid.Storage.UsersGuide</a>
for more information.
</p>
<p>
For a model with enhanced stratification, use
<a href=\"modelica://Buildings.Fluid.Storage.StratifiedEnhanced\">
Buildings.Fluid.Storage.StratifiedEnhanced</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 28, 2015, by Brecht Baeten:<br/>
Added  <code>ThirdOrderStratifier</code> and updated icon.
</li>
<li>
March 28, 2015, by Filip Jorissen:<br/>
Propagated <code>allowFlowReversal</code> and <code>m_flow_small</code>
and set <code>mSenFac=1</code>.
</li>
<li>
January 26, 2015, by Michael Wetter:<br/>
Renamed
<code>hA_flow</code> to <code>H_a_flow</code>,
<code>hB_flow</code> to <code>H_b_flow</code> and
<code>hVol_flow</code> to <code>H_vol_flow</code>
as they output enthalpy flow rate, and not specific enthalpy.
Made various models <code>protected</code>.
</li>
<li>
January 25, 2015, by Michael Wetter:<br/>
Added <code>final</code> to <code>tau = 0</code> in <code>EnthalpyFlowRate</code>.
These sensors do not need dynamics as the enthalpy flow rate
is used to compute a heat flow which is then added to the volume of the tank.
Thus, if there were high frequency oscillations of small mass flow rates,
then they have a small effect on <code>H_flow</code>, and they are
not used in any control loop. Rather, the oscillations are further damped
by the differential equation of the fluid volume.
</li>
<li>
January 25, 2015, by Filip Jorissen:<br/>
Set <code>tau = 0</code> in <code>EnthalpyFlowRate</code>
sensors for increased simulation speed.
</li>
<li>
August 29, 2014, by Michael Wetter:<br/>
Replaced the use of <code>Medium.lambda_const</code> with
<code>Medium.thermalConductivity(sta_default)</code> as
<code>lambda_const</code> is not declared for all media.
This avoids a translation error if certain media are used.
</li>
<li>
June 18, 2014, by Michael Wetter:<br/>
Changed the default value for the energy balance initialization to avoid
a dependency on the global <code>system</code> declaration.
</li>
<li>
July 29, 2011, by Michael Wetter:<br/>
Removed <code>use_T_start</code> and <code>h_start</code>.
</li>
<li>
February 18, 2011, by Michael Wetter:<br/>
Changed default start values for temperature and pressure.
</li>
<li>
October 25, 2009 by Michael Wetter:<br/>
Changed computation of heat transfer through top (and bottom) of tank. Now,
the thermal resistance of the fluid is not taken into account, i.e., the
top (and bottom) element is assumed to be mixed.
<li>
October 23, 2009 by Michael Wetter:<br/>
Fixed bug in computing heat conduction of top and bottom segment.
In the previous version,
for computing the heat conduction between the top (or bottom) segment and
the outside,
the whole thickness of the water volume was used
instead of only half the thickness.
</li>
<li>
February 19, 2009 by Michael Wetter:<br/>
Changed declaration that constrains the medium. The earlier
declaration caused the medium model to be not shown in the parameter
window.
</li>
<li>
October 31, 2008 by Michael Wetter:<br/>
Added heat conduction.
</li>
<li>
October 23, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
     graphics={
        Rectangle(
          extent={{-26,-68},{26,-76}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,74},{30,64}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,68},{40,20}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,-14},{40,-70}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-76,2},{-90,-2}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-76,52},{-80,-2}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{82,0},{78,-54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{92,2},{78,-2}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,20},{40,-14}},
          lineColor={255,0,0},
          pattern=LinePattern.None,
          fillColor={102,44,145},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{100,106},{134,74}},
          lineColor={0,0,127},
          textString="QLoss"),
        Rectangle(
          extent={{-10,10},{10,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={255,255,255}),
        Rectangle(
          extent={{50,66},{40,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,66},{-50,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{20,80},{70,80},{70,72},{102,72},{100,72}},
          color={127,0,0},
          pattern=LinePattern.Dot),
        Line(
          points={{52,0},{56,0},{56,72},{70,72}},
          color={127,0,0},
          pattern=LinePattern.Dot),
        Line(
          points={{22,-80},{70,-80},{70,72}},
          color={127,0,0},
          pattern=LinePattern.Dot),
        Rectangle(
          extent={{-40,52},{-80,48}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{82,-50},{40,-54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-50,66},{-20,80},{20,80},{50,66},{40,64},{20,72},{-20,72},{-40,
              64},{-50,66}},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-50,-66},{-20,-80},{20,-80},{50,-66},{40,-64},{20,-72},
              {-20,-72},{-40,-64},{-50,-66}},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end Stratified;
