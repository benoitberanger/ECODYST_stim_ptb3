function Plot( self )

self.AssertSignalReady();

figure
plot(self.time, self.signal)
axis tight
xlabel('time (s)')
ylabel('signal')
legend('Left','right')

end
