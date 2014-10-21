module SmartOS
  module Commands

    CommandResult = Struct.new(:stdout, :stderr, :exitcode, :exitsignal) do
      def success?
        exitcode.to_i == 0
      end
    end

    class CommandError < StandardError; end

    def ssh_exec!(command, ssh = nil)
      ssh ||= @ssh
      stdout_data = ""
      stderr_data = ""
      exit_code = nil
      exit_signal = nil
      ssh.open_channel do |channel|
        channel.exec(command) do |ch, success|
          unless success
            abort "FAILED: couldn't execute command (ssh.channel.exec)"
          end
          channel.on_data do |ch,data|
            stdout_data+=data
          end

          channel.on_extended_data do |ch,type,data|
            stderr_data+=data
          end

          channel.on_request("exit-status") do |ch,data|
            exit_code = data.read_long
          end

          channel.on_request("exit-signal") do |ch, data|
            exit_signal = data.read_long
          end
        end
      end
      ssh.loop
      CommandResult.new(stdout_data,stderr_data,exit_code,exit_signal)
    end

    def remote_exec!(command)
      result = ssh_exec!(command)
      if result.success? 
        begin
          json = JSON.parse(result.stdout)
          return json
        rescue => e
        end
        case result.stdout.strip 
        when 'true' then return true
        when 'false' then return false
        end
      else
        raise CommandError, "Exitcode: #{result.exitcode} - #{result.stderr}" 
      end
      result.stdout
    end

    def remote_exec(command)
      result = ssh_exec!(command)
      if result.success? 
        begin
          json = JSON.parse(result.stdout)
          result.stdout = json
        rescue => e
        end
      end
      result
    end

  end
end