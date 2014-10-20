module SmartOS
  module Commands
    class Imgadm < Command

        def initialize(ssh)
          @ssh = ssh
        end

        def sources
          gz_exec("imgadm sources -j", json: true)
        end

        def add_source(url)
          gz_exec("imgadm sources -a #{url}")
        end

        def delete_source(url)
          gz_exec("imgadm sources -d #{url}")
        end

        def avail
          gz_exec("imgadm avail -j", json: true)
        end

        def import(uuid, pool: 'zones')
          gz_exec("imgadm import #{uuid} -P #{pool} -q")
        end

        def install(manifest, file, pool: 'zones')
          gz_exec("imgadm import -P #{pool} -m #{manifest} -f #{file} -q")
        end

        def list
          gz_exec("imgadm list -j", json: true)
        end

        def show(uuid)
          gz_exec("imgadm show #{uuid}", json: true)
        end

        def get(uuid, pool: 'zones')
          gz_exec("imgadm get #{uuid} -P #{pool}", json: true)
        end

        def delete(uuid, pool: 'zones')
          gz_exec("imgadm delete #{uuid} -P #{pool}")
        end

        def update(uuids)
          gz_exec("imgadm update #{Array(uuids).join(' ')}")
        end

        def publish(imgapi_url)
          gz_exec("imgadm publish -m #{manifest} -f #{file} -q #{imgapi_url}")
        end

        def create( vm_uuid, manifest: nil, output: nil, compression: 'none',
                    incremental: false, script: nil, publish: nil, max_origin_depth: nil)
          raise 'Only one of -o(utput) or -p(ublish) may be specified' if output && publish
          raise 'Manifest must be passed as either a Hash or a String' unless [Hash,String].include?(manifest.class)

          flags = [ {flag: '-s', value: script},
                    {flag: '-c', value: compression},
                    {flag: '-o', value: output},
                    {flag: '-p', value: publish},
                    {flag: '--max-origin-depth', value: max_origin_depth},
                    {flag: '-i', value: incremental}]

          flags_string = flags.map{ |f| f[:value] ? "#{f[:flag]} #{f[:value]} " : nil}.compact.join('')

          gz_exec case manifest.class
            when String then "imgadm create #{flags_string}-q -m #{manifest} #{vm_uuid}"
            when Hash then "echo '#{manifest.to_json}' | imgadm create #{flags_string}-q -m - #{vm_uuid}"
          end

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