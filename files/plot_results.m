vc=valid_command.Data;
c_time=commands.calculator_value_1.value.Time;
c1=commands.calculator_value_1.value.Data;
c2=commands.calculator_value_2.value.Data;
c3=commands.calculator_value_3.value.Data;
c4=commands.calculator_value_4.value.Data;
c5=commands.calculator_value_5.value.Data;
c6=commands.calculator_value_6.value.Data;
r_time=reference_trust.trusts.Time;
r1=reference_trust.trusts.Data(1,1,:); r1=r1(:);
r2=reference_trust.trusts.Data(1,2,:); r2=r2(:);
r3=reference_trust.trusts.Data(1,3,:); r3=r3(:);
r4=reference_trust.trusts.Data(1,4,:); r4=r4(:);
r5=reference_trust.trusts.Data(1,5,:); r5=r5(:);
r6=reference_trust.trusts.Data(1,6,:); r6=r6(:);

subplot(2,3,1);
[ax h1 h2] = plotyy(c_time, [c1 vc], r_time, r1);
set(h1(1), 'LineWidth', 3); set(h1(2), 'LineWidth', 2); set(h2, 'LineWidth', 2);
title('Calculator 1')

subplot(2,3,2);
[ax h1 h2] = plotyy(c_time, [c2 vc], r_time, r2);
set(h1(1), 'LineWidth', 3); set(h1(2), 'LineWidth', 2); set(h2, 'LineWidth', 2);
title('Calculator 2')

subplot(2,3,3);
[ax h1 h2] = plotyy(c_time, [c3 vc], r_time, r3);
set(h1(1), 'LineWidth', 3); set(h1(2), 'LineWidth', 2); set(h2, 'LineWidth', 2);
title('Calculator 3')

subplot(2,3,4);
[ax h1 h2] = plotyy(c_time, [c4 vc], r_time, r4);
set(h1(1), 'LineWidth', 3); set(h1(2), 'LineWidth', 2); set(h2, 'LineWidth', 2);
title('Calculator 4')

subplot(2,3,5);
[ax h1 h2] = plotyy(c_time, [c5 vc], r_time, r5);
set(h1(1), 'LineWidth', 3); set(h1(2), 'LineWidth', 2); set(h2, 'LineWidth', 2);
title('Calculator 5')

subplot(2,3,6);
[ax h1 h2] = plotyy(c_time, [c6 vc], r_time, r6);
set(h1(1), 'LineWidth', 3); set(h1(2), 'LineWidth', 2); set(h2, 'LineWidth', 2);
title('Calculator 6')