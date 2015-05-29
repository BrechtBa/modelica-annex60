within Annex60.Experimental.Benchmarks.AirFlow.Components;
model ZoneHallway
  "Zone representing a hallway connecting multiple SimpleZone models"

  parameter Modelica.SIunits.Temperature TRoom = 293.15
    "Indoor air temperature of room in K";
  parameter Modelica.SIunits.Height heightRoom = 3 "Height of room in m";
  parameter Modelica.SIunits.Length lengthRoom = 5 "Length of room in m";
  parameter Modelica.SIunits.Length widthRoom = 3 "Width of room in m";

  parameter Modelica.SIunits.CoefficientOfHeatTransfer UValue = 1
    "Heat transfer coefficient for outside wall";

  replaceable package Medium = Modelica.Media.Air.SimpleAir;
  parameter Boolean forceErrorControlOnFlow = true
    "Flag to force error control on m_flow. Set to true if interested in flow rate";

  Fluid.MixingVolumes.MixingVolume volumeHall(
    redeclare package Medium = Medium,
    m_flow_nominal=0.001,
    V=heightRoom*lengthRoom*widthRoom,
    nPorts=8,
    T_start=TRoom,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Air volume of hallway element"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conRoom(G=
        heightRoom*lengthRoom*UValue)
    "Thermal conductor between fixed T and Volume"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Airflow.Multizone.MediumColumn col(
    redeclare package Medium = Medium,
    h=heightRoom/2,
    densitySelection=Annex60.Airflow.Multizone.Types.densitySelection.fromTop)
    annotation (Placement(transformation(extent={{50,-40},{70,-20}})));
  Airflow.Multizone.MediumColumn col1(
    redeclare package Medium = Medium,
    h=heightRoom/2,
    densitySelection=Annex60.Airflow.Multizone.Types.densitySelection.fromBottom)
    annotation (Placement(transformation(extent={{50,20},{70,40}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_toZone(redeclare package Medium
      = Medium) "Direct connection to air volume without orifice"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_toZone(redeclare package Medium
      = Medium) "Direct connection to air volume without orifice"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_toOutside(redeclare package
      Medium = Medium) "Indirect connection to air volume with orifice"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_toOutside(redeclare package
      Medium = Medium) "Indirect connection to air volume with orifice"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(redeclare package Medium =
        Medium) "Indirect connection to air volume with orifice"
    annotation (Placement(transformation(extent={{-70,-110},{-50,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(redeclare package Medium =
        Medium) "Direct connection to air volume without orifice"
    annotation (Placement(transformation(extent={{-70,90},{-50,110}})));
  Airflow.Multizone.Orifice oriOutTop(
    redeclare package Medium = Medium,
    A=0.01,
    forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{68,50},{88,70}})));
  Airflow.Multizone.Orifice oriOutBottom(
    redeclare package Medium = Medium,
    A=0.01,
    forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{68,-70},{88,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(redeclare package Medium =
        Medium) "Indirect connection to air volume with orifice"
    annotation (Placement(transformation(extent={{50,-110},{70,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(redeclare package Medium =
        Medium) "Direct connection to air volume without orifice"
    annotation (Placement(transformation(extent={{50,90},{70,110}})));
  Airflow.Multizone.MediumColumn col2(
    redeclare package Medium = Medium,
    densitySelection=Annex60.Airflow.Multizone.Types.densitySelection.fromBottom,
    h=heightRoom/4) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,-60})));

  Airflow.Multizone.MediumColumn col3(
    redeclare package Medium = Medium,
    densitySelection=Annex60.Airflow.Multizone.Types.densitySelection.fromTop,
    h=heightRoom/4) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-60})));
  Airflow.Multizone.Orifice ori(
    redeclare package Medium = Medium,
    A=widthRoom*heightRoom/2,
    forceErrorControlOnFlow=forceErrorControlOnFlow) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-40,-80})));
  Airflow.Multizone.Orifice ori1(
    redeclare package Medium = Medium,
    A=widthRoom*heightRoom/2,
    forceErrorControlOnFlow=forceErrorControlOnFlow) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,-80})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTemp
    "Dry bulb air temperature"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-20,80},{20,120}}), iconTransformation(extent={{
            -128,30},{-108,50}})));
equation
  connect(weaBus.TDryBul, preTemp.T);
  connect(conRoom.port_b, volumeHall.heatPort) annotation (Line(
      points={{0,0},{20,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(port_a_toZone, volumeHall.ports[1]) annotation (Line(
      points={{-100,60},{-80,60},{-80,-24},{24,-24},{26.5,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_b_toZone, volumeHall.ports[2]) annotation (Line(
      points={{-100,-60},{-80,-60},{-80,-28},{26,-28},{27.5,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(col.port_b, oriOutBottom.port_a) annotation (Line(
      points={{60,-40},{60,-60},{68,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(oriOutBottom.port_b, port_b_toOutside) annotation (Line(
      points={{88,-60},{100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(col1.port_a, oriOutTop.port_a) annotation (Line(
      points={{60,40},{60,60},{68,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(oriOutTop.port_b, port_a_toOutside) annotation (Line(
      points={{88,60},{100,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_a1,port_a1)  annotation (Line(
      points={{-60,-100},{-60,-100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ori.port_b,port_a1)  annotation (Line(
      points={{-40,-90},{-40,-94},{-60,-100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ori1.port_b,port_b1)  annotation (Line(
      points={{40,-90},{40,-92},{60,-100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ori.port_a, col2.port_a) annotation (Line(
      points={{-40,-70},{-40,-60},{-30,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(col3.port_b, ori1.port_a) annotation (Line(
      points={{30,-60},{40,-60},{40,-70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(col2.port_b, volumeHall.ports[3]) annotation (Line(
      points={{-10,-60},{-6,-60},{-6,-30},{28,-30},{28.5,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(col3.port_a, volumeHall.ports[4]) annotation (Line(
      points={{10,-60},{2,-60},{2,-34},{30,-34},{29.5,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(col.port_a, volumeHall.ports[5]) annotation (Line(
      points={{60,-20},{60,-10},{52,-10},{52,-36},{34,-36},{30.5,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(col1.port_b, volumeHall.ports[6]) annotation (Line(
      points={{60,20},{60,-4},{50,-4},{50,-32},{38,-32},{31.5,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volumeHall.ports[7],port_b2)  annotation (Line(
      points={{32.5,-10},{40,-30},{48,-30},{48,80},{60,80},{60,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volumeHall.ports[8],port_a2)  annotation (Line(
      points={{33.5,-10},{42,-28},{44,-28},{44,80},{-60,80},{-60,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(preTemp.port, conRoom.port_a) annotation (Line(
      points={{-40,0},{-20,0}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=false), graphics),                         Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
An air volume to represent a hallway element for a scalable air flow benchmark.
</p>
<h4>Assumptions and limitations</h4>
<p>
This is a very simple room representation with a constant room temperature.
</p>
<h4>Typical use and important parameters</h4>
<p>
port_a_toZone and port_b_toZone should be connected to the corresponding ports 
of a zone model, port_a_toOutside and port_b_toOutside should be connected to 
the corresponding ports of the OutsideEnvironment. 

port_a2 and port_b2 can be connected to either a staircase model or to further 
hallway elements via their respective port_a1 and port_b2.
</p>

<h4>Validation</h4>
<p>
This model is following the approach used in 
Buildings.Airflow.Multizone.Examples.Validation3Rooms, only in a more 
modularized way in order to be part of a scalable benchmark. First tests 
indicated a reasonable behavior, but it should be checked again against that 
test case and/or other validation cases. 
</p>

<h4>References</h4>
<p>
Inspired by Buildings.Airflow.Multizone.Examples.Validation3Rooms
</p>
</html>", revisions="<html>
<ul>
<li>
February 2015 by Marcus Fuchs:<br/>
First implementation
</li>
</ul>
</html>"));
end ZoneHallway;