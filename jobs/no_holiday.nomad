job "the_numbers_no_holiday" {
  datacenters = ["dc1"]
  type        = "batch"

  group "the_numbers_no_holiday" {
    task "check_holiday" {
      driver = "raw_exec"

      # Get the holiday list
      artifact {
        source = "http://whatsaranjit.com/holiday.list"
      }
      # Get the check script
      artifact {
        source = "http://whatsaranjit.com/holiday_check.script"
      }

      # Run the check
      config {
        command = "bash"
        args    = ["-x", "local/holiday_check.script"]
      }
      # Run this before the primary job
      lifecycle {
        sidecar = false
        hook    = "prestart"
      }
    }

    # Primary job just running pings
    task "the_numbers" {
      driver = "raw_exec"

      config {
        command = "ping"
        args = ["localhost"]
      }
    }
  }
}
