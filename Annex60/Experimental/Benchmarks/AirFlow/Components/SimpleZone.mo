within Annex60.Experimental.Benchmarks.AirFlow.Components;
model SimpleZone "A room as a thermal zone represented by its air volume"

  parameter Modelica.SIunits.Temperature TRoom = 293.15
    "Indoor air temperature of room in K";
  parameter Modelica.SIunits.Height heightRoom = 3 "Height of room in m";
  parameter Modelica.SIunits.Length lengthRoom = 5 "Length of room in m";
  parameter Modelica.SIunits.Length widthRoom = 5 "Width of room in m";

  parameter Modelica.SIunits.CoefficientOfHeatTransfer UValue = 1
    "Heat transfer coefficient for outside wall";

  parameter Real doorOpening = 1
    "Opening of door (between 0:closed and 1:open)";

  replaceable package Medium = Modelica.Media.Air.SimpleAir;
  parameter Boolean forceErrorControlOnFlow = true
    "Flag to force error control on m_flow. Set to true if interested in flow rate";

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conRoom(G=
        heightRoom*lengthRoom*UValue)
    "Thermal conductor between fixed T and Volume"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Fluid.MixingVolumes.MixingVolume volRoom(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=TRoom,
    m_flow_nominal=0.001,
    V=heightRoom*lengthRoom*widthRoom,
    redeclare package Medium = Medium,
    nPorts=3,
    mSenFac=75) "Indoor air volume of room"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Airflow.Multizone.DoorDiscretizedOperable door(
    redeclare package Medium = Medium,
    LClo=20*1E-4,
    wOpe=1,
    hOpe=2.2,
    CDOpe=0.78,
    CDClo=0.78,
    nCom=10,
    hA=3/2,
    hB=3/2,
    dp_turbulent(displayUnit="Pa") = 0.01,
    forceErrorControlOnFlow=forceErrorControlOnFlow) "Discretized door"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Sources.Constant const(k=doorOpening)
    annotation (Placement(transformation(extent={{28,40},{48,60}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_vent(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-110,70},{-90,90}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTemp
    "Dry bulb air temperature"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-20,80},{20,120}}), iconTransformation(extent={{
            -128,30},{-108,50}})));
equation
  connect(weaBus.TDryBul, preTemp.T);
  connect(conRoom.port_b, volRoom.heatPort) annotation (Line(
      points={{0,0},{20,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(volRoom.ports[1], door.port_b2) annotation (Line(
      points={{27.3333,-10},{27.3333,-34},{52,-34},{52,-6},{60,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volRoom.ports[2], door.port_a1) annotation (Line(
      points={{30,-10},{32,-24},{44,-24},{44,6},{60,6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(door.port_b1, port_a) annotation (Line(
      points={{80,6},{86,6},{86,60},{100,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(door.port_a2, port_b) annotation (Line(
      points={{80,-6},{86,-6},{86,-60},{100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(const.y, door.y) annotation (Line(
      points={{49,50},{54,50},{54,0},{59,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(port_a_vent, volRoom.ports[3]) annotation (Line(
      points={{-100,80},{-84,80},{-84,-54},{32.6667,-54},{32.6667,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(preTemp.port, conRoom.port_a) annotation (Line(
      points={{-40,0},{-20,0}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(info="<html>
<p>An air volume to represent a zone/room within a building that can be connected to a hallway element and to ventilation equipment. </p>
<h4>Assumptions and limitations</h4>
<p>This is a very simple room representation. The model is intended to roughly approximate a first order response of the zone to changes in outdoor air temperature. This is achieved by a thermal resistance in model conRoom and the capitancy of the mixing volume represented by the value for mSenFac. The G-Value of conRoom is approximated by the area of one outside wall multiplied with a U-Value of 1 W/(m**2*K). The value for mSenFac has been estimated from comparisons with other room models as shown in <a href=\"modelica://Annex60.Experimental.Benchmarks.AirFlow.Examples.ZoneStepResponse\">Annex60.Experimental.Benchmarks.AirFlow.Examples.ZoneStepResponse</a>.</p>
<h4>Typical use and important parameters</h4>
<p>port_a and port_b should be connected to the corresponding ports of ZoneHallway so that there is an air exchange through the door connecting the room to the hallway element. </p>
<h4>Validation</h4>
<p>This model is following the approach used in Buildings.Airflow.Multizone.Examples.Validation3Rooms, only in a more modularized way in order to be part of a scalable benchmark. First tests indicated a reasonable behavior, but it should be checked again against that test case and/or other validation cases. </p>
<h4>References</h4>
<p>Inspired by Buildings.Airflow.Multizone.Examples.Validation3Rooms </p>
</html>", revisions="<html>
<ul>
<li>
February 2015 by Marcus Fuchs:<br/>
First implementation
</li>
</ul>
</html>"));
end SimpleZone;