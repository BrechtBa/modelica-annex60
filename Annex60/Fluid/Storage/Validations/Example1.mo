within Annex60.Fluid.Storage.Validations;
model Example1

  Stratified tan(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    VTan=1.225*Modelica.Constants.pi*0.272^2,
    hTan=1.225,
    dIns=0.1,
    d=0.04,
    nSeg=50,
    vol(T_start={287.151, 287.151, 287.212, 287.343, 287.474, 287.605, 287.737, 287.654, 287.622, 287.820, 288.018, 288.216, 288.414, 288.519, 288.578, 288.655, 288.732, 288.809, 288.886, 288.938, 288.967, 288.988, 289.009, 289.030, 289.051, 289.098, 289.184, 289.236, 289.288, 289.339, 289.391, 289.400, 289.295, 289.306, 289.337, 289.369, 289.400, 289.413, 289.320, 289.323, 289.363, 289.402, 289.441, 289.477, 289.378, 289.395, 289.487, 289.580, 289.441, 289.369}),
    h_port_a=1.045,
    h_port_b=0.190,
    T_start=287.9)
             annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Sources.MassFlowSource_T boundary(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) annotation (Placement(transformation(extent={{-34,0},{-14,20}})));
  replaceable package Medium = Annex60.Media.Water;
  Sources.Boundary_pT bou(          redeclare package Medium = Medium, nPorts=1)
    annotation (Placement(transformation(extent={{100,0},{80,20}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(
    tableOnFile=true,
    tableName="data",
    columns=2:21,
    fileName=classDirectory()+"/data/exp_1.mat")
    annotation (Placement(transformation(extent={{-98,4},{-78,24}})));
  Modelica.Blocks.Math.Gain lmin2kgs(k=1/60) "Conversion of liters/min to kg/s"
    annotation (Placement(transformation(extent={{-66,26},{-46,46}})));
  Sensors.TemperatureTwoPort senTemOut(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    tau=0) annotation (Placement(transformation(extent={{40,0},{60,20}})));
equation
  connect(tan.port_a, boundary.ports[1])
    annotation (Line(points={{0,10},{-8,10},{-14,10}}, color={0,127,255}));
  connect(lmin2kgs.y, boundary.m_flow_in) annotation (Line(points={{-45,36},{-42,
          36},{-42,18},{-34,18}},color={0,0,127}));
  connect(tan.port_b, senTemOut.port_a)
    annotation (Line(points={{20,10},{30,10},{40,10}}, color={0,127,255}));
  connect(senTemOut.port_b, bou.ports[1])
    annotation (Line(points={{60,10},{70,10},{80,10}}, color={0,127,255}));

  connect(combiTimeTable.y[2], boundary.T_in) annotation (Line(points={{-77,14},
          {-68,14},{-36,14}},          color={0,0,127}));
  connect(combiTimeTable.y[1], lmin2kgs.u) annotation (Line(points={{-77,14},{-72,
          14},{-72,36},{-68,36}},
                                color={0,0,127}));
   annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=3000),
    __Dymola_experimentSetupOutput(events=false));
end Example1;
