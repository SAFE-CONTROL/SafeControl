rvc=referee_valid_calculator.Data;
rc=referee_command.Data; rc=rc(:);
vc=reference_command.Data;
c_time=commands.Time;
c1=commands.Data(1,:,:); c1=c1(:);
c2=commands.Data(2,:,:); c2=c2(:);
c3=commands.Data(3,:,:); c3=c3(:);
c4=commands.Data(4,:,:); c4=c4(:);
c5=commands.Data(5,:,:); c5=c5(:);
c6=commands.Data(6,:,:); c6=c6(:);
r_time=referee_trusts.Time;
r1=referee_trusts.Data(1,1,:); r1=r1(:);
r2=referee_trusts.Data(1,2,:); r2=r2(:);
r3=referee_trusts.Data(1,3,:); r3=r3(:);
r4=referee_trusts.Data(1,4,:); r4=r4(:);
r5=referee_trusts.Data(1,5,:); r5=r5(:);
r6=referee_trusts.Data(1,6,:); r6=r6(:);

close all;
figure;
figtitle('Commands, true command, related reference trust');
set(gcf, 'Position', get(0, 'Screensize'));

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



figure;
figtitle('Most trusted calculator, referee command');
set(gcf, 'Position', get(0, 'Screensize'));

[ax h1 h2] = plotyy(c_time, [vc rc], c_time, rvc);
set(h1(1), 'LineWidth', 3); set(h1(2), 'LineWidth', 2); set(h2, 'LineWidth', 2);