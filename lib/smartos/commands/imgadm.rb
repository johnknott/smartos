module SmartOS
  module Commands
    class Imgadm < Command

        def initialize(ssh)
          @ssh = ssh
        end

        def sources
          result = ssh_exec!("imgadm sources -j")
          result.success? ? JSON.parse(result.stdout) : handle_error(result)
        end

        def add_source(url)
          result = ssh_exec!("imgadm sources -a #{url}")
          result.success? ? true : handle_error(result)
        end

        def delete_source(url)
          result = ssh_exec!("imgadm sources -d #{url}")
          result.success? ? true : handle_error(result)
        end

        def avail
          result = ssh_exec!("imgadm avail -j")
          result.success? ? JSON.parse(result.stdout) : handle_error(result)
        end

        def import(uuid, pool: 'zones')
          result = ssh_exec!("imgadm import #{uuid} -P #{pool} -q")
          result.success? ? true : handle_error(result)
        end

        def install(manifest, file, pool: 'zones')
          result = ssh_exec!("imgadm import -P #{pool} -m #{manifest} -f #{file} -q")
          result.success? ? true : handle_error(result)
        end

        def list
          result = ssh_exec!("imgadm list -j")
          result.success? ? JSON.parse(result.stdout) : handle_error(result)
        end

        def show(uuid)
          result = ssh_exec!("imgadm show #{uuid}")
          result.success? ? JSON.parse(result.stdout) : handle_error(result)
        end

        def get(uuid, pool: 'zones')
          result = ssh_exec!("imgadm get #{uuid} -P #{pool}")
          result.success? ? JSON.parse(result.stdout) : handle_error(result)
        end

        def delete(uuid, pool: 'zones')
          result = ssh_exec!("imgadm delete #{uuid} -P #{pool}")
          result.success? ? true : handle_error(result)
        end

        def update(uuids)
          result = ssh_exec!("imgadm update #{Array(uuids).join(' ')}")
          result.success? ? true : handle_error(result)
        end

        #puts Imgadm.create('f7a53e9-fc4d-d94b-9205-9ff110742aaf', manifest:{name: 'NewImage', version: '1.0.0'}, script: '/var/tmp/prep-image.sh', output: '/var/tmp')
        def create(vm_uuid, manifest: nil, output: nil, compression: 'none', incremental: false, script: nil, publish: nil, max_origin_depth: nil)
          raise 'Imgadm#create: Only one of -o(utput) or -p(ublish) may be specified' if output && publish
          raise 'Imgadm#create: Manifest must be passed as either a Hash or a String' unless ['Hash','String'].include?(manifest.class.to_s)
          flags = [ {flag: '-s', value: script},
                    {flag: '-c', value: compression},
                    {flag: '-o', value: output},
                    {flag: '-p', value: publish},
                    {flag: '--max-origin-depth', value: max_origin_depth},
                    {flag: '-i', value: incremental}]

          flags_string = flags.map{ |f| f[:value] ? "#{f[:flag]} #{f[:value]} " : nil}.compact.join('')

          if manifest.is_a? Hash
            str_command = "echo '#{manifest.to_json}' | imgadm create #{flags_string}-q -m - #{vm_uuid}"
          elsif manifest.is_a? String
            str_command = "imgadm create #{flags_string}-q -m #{manifest} #{vm_uuid}"
          end
          puts str_command
        end

        def publish
          #TODO
        end

        private

        def handle_error(result)
          desc = case result.exitcode.to_i
          when 1 then "An error occurred"
          when 2 then "Usage error"
          when 3 then "ImageNotInstalled error"
          else "Unknown error"
          end

          err = "#{desc} - #{result.stderr}"
          raise SmartOS::Commands::Error,err
        end

    end
  end
end