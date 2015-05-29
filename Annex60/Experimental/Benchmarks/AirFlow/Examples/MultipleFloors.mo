within Annex60.Experimental.Benchmarks.AirFlow.Examples;
model MultipleFloors "Test case for air flow between multiple floors"
  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Air.SimpleAir;
  parameter Boolean forceErrorControlOnFlow = true;

  Components.ZoneHallway zoneHallway(redeclare package Medium = Medium,
      forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{42,-94},{62,-74}})));
  Components.SimpleZone simpleZone(redeclare package Medium = Medium,
      forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{12,-94},{32,-74}})));
  Components.OutsideEnvironment outsideEnvironment(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{72,-94},{92,-74}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-90,100},{-70,120}})));
  Components.ZoneHallway zoneHallway1(redeclare package Medium = Medium,
      forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{42,-54},{62,-34}})));
  Components.ZoneHallway zoneHallway2(redeclare package Medium = Medium,
      forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{42,-14},{62,6}})));
  Components.ZoneHallway zoneHallway3(redeclare package Medium = Medium,
      forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{42,26},{62,46}})));
  Components.SimpleZone simpleZone1(
    TRoom=293.15,
    redeclare package Medium = Medium,
    forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{12,-54},{32,-34}})));
  Components.SimpleZone simpleZone2(
    TRoom=303.15,
    redeclare package Medium = Medium,
    forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{12,-14},{32,6}})));
  Components.SimpleZone simpleZone3(
    TRoom=300.15,
    redeclare package Medium = Medium,
    forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{12,26},{32,46}})));
  Components.OutsideEnvironment outsideEnvironment1
    annotation (Placement(transformation(extent={{72,-54},{92,-34}})));
  Components.OutsideEnvironment outsideEnvironment2
    annotation (Placement(transformation(extent={{72,-14},{92,6}})));
  Components.OutsideEnvironment outsideEnvironment3
    annotation (Placement(transformation(extent={{72,26},{92,46}})));
  Components.ZoneHallway zoneHallway4(redeclare package Medium = Medium,
      forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{-62,-94},{-42,-74}})));
  Components.SimpleZone simpleZone4(redeclare package Medium = Medium,
      forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{-92,-94},{-72,-74}})));
  Components.OutsideEnvironment outsideEnvironment4(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-32,-94},{-12,-74}})));
  Components.ZoneHallway zoneHallway5(redeclare package Medium = Medium,
      forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{-62,-54},{-42,-34}})));
  Components.ZoneHallway zoneHallway6(redeclare package Medium = Medium,
      forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{-62,-14},{-42,6}})));
  Components.ZoneHallway zoneHallway7(redeclare package Medium = Medium,
      forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{-62,26},{-42,46}})));
  Components.SimpleZone simpleZone5(
    TRoom=293.15,
    redeclare package Medium = Medium,
    forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{-92,-54},{-72,-34}})));
  Components.SimpleZone simpleZone6(
    TRoom=303.15,
    redeclare package Medium = Medium,
    forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{-92,-14},{-72,6}})));
  Components.SimpleZone simpleZone7(
    TRoom=300.15,
    redeclare package Medium = Medium,
    forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{-92,26},{-72,46}})));
  Components.OutsideEnvironment outsideEnvironment5
    annotation (Placement(transformation(extent={{-32,-54},{-12,-34}})));
  Components.OutsideEnvironment outsideEnvironment6
    annotation (Placement(transformation(extent={{-32,-14},{-12,6}})));
  Components.OutsideEnvironment outsideEnvironment7
    annotation (Placement(transformation(extent={{-32,26},{-12,46}})));
  Components.Staircase staircase annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={52,70})));
  Components.Staircase staircase1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-52,70})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "modelica://Annex60/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    annotation (Placement(transformation(extent={{-24,100},{-4,120}})));
equation
  connect(simpleZone4.port_a, zoneHallway4.port_a_toZone) annotation (Line(
      points={{-72,-78},{-62,-78}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(simpleZone4.port_b, zoneHallway4.port_b_toZone) annotation (Line(
      points={{-72,-90},{-62,-90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway4.port_a2, zoneHallway5.port_a1) annotation (Line(
      points={{-58,-74},{-58,-54}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway4.port_b2, zoneHallway5.port_b1) annotation (Line(
      points={{-46,-74},{-46,-54}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway4.port_a_toOutside, outsideEnvironment4.port_a)
    annotation (Line(
      points={{-42,-78},{-32,-78}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway4.port_b_toOutside, outsideEnvironment4.port_b)
    annotation (Line(
      points={{-42,-90},{-32,-90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway5.port_b_toOutside, outsideEnvironment5.port_b)
    annotation (Line(
      points={{-42,-50},{-32,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway5.port_a_toOutside, outsideEnvironment5.port_a)
    annotation (Line(
      points={{-42,-38},{-32,-38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(simpleZone5.port_b, zoneHallway5.port_b_toZone) annotation (Line(
      points={{-72,-50},{-62,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(simpleZone5.port_a, zoneHallway5.port_a_toZone) annotation (Line(
      points={{-72,-38},{-62,-38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway5.port_a2, zoneHallway6.port_a1) annotation (Line(
      points={{-58,-34},{-58,-14}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway5.port_b2, zoneHallway6.port_b1) annotation (Line(
      points={{-46,-34},{-46,-14}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(simpleZone6.port_b, zoneHallway6.port_b_toZone) annotation (Line(
      points={{-72,-10},{-62,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(simpleZone6.port_a, zoneHallway6.port_a_toZone) annotation (Line(
      points={{-72,2},{-62,2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway6.port_a2, zoneHallway7.port_a1) annotation (Line(
      points={{-58,6},{-58,26}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway6.port_b2, zoneHallway7.port_b1) annotation (Line(
      points={{-46,6},{-46,26}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway6.port_a_toOutside, outsideEnvironment6.port_a)
    annotation (Line(
      points={{-42,2},{-32,2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway6.port_b_toOutside, outsideEnvironment6.port_b)
    annotation (Line(
      points={{-42,-10},{-32,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway7.port_b_toOutside, outsideEnvironment7.port_b)
    annotation (Line(
      points={{-42,30},{-32,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway7.port_a_toOutside, outsideEnvironment7.port_a)
    annotation (Line(
      points={{-42,42},{-32,42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(simpleZone7.port_b, zoneHallway7.port_b_toZone) annotation (Line(
      points={{-72,30},{-62,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(simpleZone7.port_a, zoneHallway7.port_a_toZone) annotation (Line(
      points={{-72,42},{-62,42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway7.port_a2, staircase1.port_a_toHallway) annotation (Line(
      points={{-58,46},{-58,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway7.port_b2, staircase1.port_b_toHallway) annotation (Line(
      points={{-46,46},{-46,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(staircase1.port_a_bot, staircase.port_a_top) annotation (Line(
      points={{-42,64},{42,64}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(staircase1.port_b_bot, staircase.port_b_top) annotation (Line(
      points={{-42,76},{42,76}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(staircase.port_a_toHallway, zoneHallway3.port_a2) annotation (Line(
      points={{46,60},{46,46}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(staircase.port_b_toHallway, zoneHallway3.port_b2) annotation (Line(
      points={{58,60},{58,46}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(simpleZone3.port_a, zoneHallway3.port_a_toZone) annotation (Line(
      points={{32,42},{42,42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(simpleZone3.port_b, zoneHallway3.port_b_toZone) annotation (Line(
      points={{32,30},{42,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway3.port_a_toOutside, outsideEnvironment3.port_a)
    annotation (Line(
      points={{62,42},{72,42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway3.port_b_toOutside, outsideEnvironment3.port_b)
    annotation (Line(
      points={{62,30},{72,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway3.port_a1, zoneHallway2.port_a2) annotation (Line(
      points={{46,26},{46,6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway3.port_b1, zoneHallway2.port_b2) annotation (Line(
      points={{58,26},{58,6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway2.port_a_toOutside, outsideEnvironment2.port_a)
    annotation (Line(
      points={{62,2},{72,2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway2.port_b_toOutside, outsideEnvironment2.port_b)
    annotation (Line(
      points={{62,-10},{72,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway2.port_a1, zoneHallway1.port_a2) annotation (Line(
      points={{46,-14},{46,-34}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway2.port_b1, zoneHallway1.port_b2) annotation (Line(
      points={{58,-14},{58,-34}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(simpleZone1.port_a, zoneHallway1.port_a_toZone) annotation (Line(
      points={{32,-38},{42,-38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(simpleZone1.port_b, zoneHallway1.port_b_toZone) annotation (Line(
      points={{32,-50},{42,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway1.port_a_toOutside, outsideEnvironment1.port_a)
    annotation (Line(
      points={{62,-38},{72,-38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway1.port_b_toOutside, outsideEnvironment1.port_b)
    annotation (Line(
      points={{62,-50},{72,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway1.port_a1, zoneHallway.port_a2) annotation (Line(
      points={{46,-54},{46,-74}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway1.port_b1, zoneHallway.port_b2) annotation (Line(
      points={{58,-54},{58,-74}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(simpleZone.port_a, zoneHallway.port_a_toZone) annotation (Line(
      points={{32,-78},{42,-78}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(simpleZone.port_b, zoneHallway.port_b_toZone) annotation (Line(
      points={{32,-90},{42,-90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway.port_a_toOutside, outsideEnvironment.port_a) annotation (
      Line(
      points={{62,-78},{72,-78}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway.port_b_toOutside, outsideEnvironment.port_b) annotation (
      Line(
      points={{62,-90},{72,-90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(simpleZone2.port_b, zoneHallway2.port_b_toZone) annotation (Line(
      points={{32,-10},{42,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(simpleZone2.port_a, zoneHallway2.port_a_toZone) annotation (Line(
      points={{32,2},{42,2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus, outsideEnvironment7.weaBus1) annotation (Line(
      points={{-4,110},{0,110},{0,36},{-12,36}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, outsideEnvironment6.weaBus1) annotation (Line(
      points={{-4,110},{0,110},{0,-4},{-12,-4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, outsideEnvironment5.weaBus1) annotation (Line(
      points={{-4,110},{0,110},{0,-44},{-12,-44}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, outsideEnvironment4.weaBus1) annotation (Line(
      points={{-4,110},{0,110},{0,-84},{-12,-84}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, outsideEnvironment3.weaBus1) annotation (Line(
      points={{-4,110},{98,110},{98,36},{92,36}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, outsideEnvironment2.weaBus1) annotation (Line(
      points={{-4,110},{98,110},{98,-4},{92,-4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, outsideEnvironment1.weaBus1) annotation (Line(
      points={{-4,110},{98,110},{98,-44},{92,-44}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, outsideEnvironment.weaBus1) annotation (Line(
      points={{-4,110},{98,110},{98,-84},{92,-84}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,120}}), graphics),
    experiment(StopTime=3600),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-100},{100,120}})));
end MultipleFloors;