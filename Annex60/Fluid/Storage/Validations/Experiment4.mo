within Annex60.Fluid.Storage.Validations;
model Experiment4
  extends Experiment1(
    combiTimeTable(fileName=classDirectory()+"/data/exp_4.mat"),
    tan(
      vol(T_start={281.884, 281.884, 282.170, 282.795, 283.419, 284.043, 284.668, 284.796, 284.827, 284.963, 285.099, 285.234, 285.370, 285.432, 285.460, 285.517, 285.574, 285.631, 285.688, 285.730, 285.761, 285.829, 285.898, 285.966, 286.034, 286.117, 286.220, 286.320, 286.420, 286.519, 286.619, 286.764, 287.028, 287.963, 289.019, 290.075, 291.130, 292.299, 294.092, 295.244, 296.154, 297.064, 297.973, 298.875, 299.519, 299.898, 300.103, 300.307, 300.198, 300.138})));
  annotation (experiment(StopTime=600), __Dymola_experimentSetupOutput(events=
          false));
end Experiment4;
