module SmartOS
  module Commands
    class Vmadm < Command

        def initialize(ssh)
          @ssh = ssh
        end

        def create
        end

        def create_snapshot
        end

        def delete
        end

        def delete_snapshot
        end

        def get
        end

        def info
        end

        def install
        end

        def list
        end

        def lookup
        end

        def reboot
        end

        def receive
        end

        def reprovision
        end

        def rollback_snapshot
        end

        def send
        end

        def stop
        end

        def sysreq
        end

        def update
        end

        def validate_create
        end

        def validate_update
        end

        private

        def handle_error(result)
          desc = case result.exitcode.to_i
          when 1 then "An error occurred"
          when 2 then "Invalid usage"
          else "Unknown error"
          end

          err = "#{desc} - #{result.stderr}"
          raise SmartOS::Commands::Error,err
        end

    end
  end
end

=begin
create [-f <filename>]
create-snapshot <uuid> <snapname>
console <uuid>
delete <uuid>
delete-snapshot <uuid> <snapname>
get <uuid>
info <uuid> [type,...]
install <uuid>
list [-p] [-H] [-o field,...] [-s field,...] [field=value ...]
lookup [-j|-1] [-o field,...] [field=value ...]
reboot <uuid> [-F]
receive [-f <filename>]
reprovision [-f <filename>]
rollback-snapshot <uuid> <snapname>
send <uuid> [target]
start <uuid> [option=value ...]
stop <uuid> [-F]
sysrq <uuid> <nmi|screenshot>
update <uuid> [-f <filename>]
 -or- update <uuid> property=value [property=value ...]
validate create [-f <filename>]
validate update <brand> [-f <filename>]
=end