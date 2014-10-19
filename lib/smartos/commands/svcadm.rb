module SmartOS
  module Commands
    class Svcadm < Command

        def initialize(ssh)
          @ssh = ssh
        end

        def enable
        end

        def disable
        end

        def restart
        end

        def refresh
        end

        def clear
        end

        def mark
        end

        def milestone
        end

        private

        def handle_error(result)
          desc = case result.exitcode.to_i
          when 1 then "A fatal error occurred"
          when 2 then "Invalid command line options were specified"
          when 3 then  "svcadm determined that a service instance that it was waiting for "
                       "could not reach the desired state without administrator "
                       "intervention due to a problem with the service instance itself"
          when 4 then  "svcadm determined that a service instance that it was waiting for "
                       "could not reach the desired state without administrator "
                       "intervention due to a problem with the service's dependencies"
          else "Unknown error"
          end

          err = "#{desc} - #{result.stderr}"
          raise SmartOS::Commands::Error,err
        end

    end
  end
end
