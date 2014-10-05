## tmc-monitoring

Not just your normal uptime monitor, this can be used to probe TMC server with real submissions
and thus not just confirming that the site is online but to confirm that the main business logic works.

`init_monitors.rb` file contains one sample configuration using the monitoring library.

### lib/mailer.rb and lib/mailer/alert.html.erb

ActionMailer based mailer for sending alerts when monitors fail.

### lib/{monitor,prober}.rb

Library for probing tms server, submitting exercises, validating the time running exercises takes and validating results returned from server.

