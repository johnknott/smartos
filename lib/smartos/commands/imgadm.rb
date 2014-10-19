module SmartOS
  module Command
    class Imgadm

      class << self
        def sources
          #imgadm sources -j
          puts  "monkey"
        end

        def add_source(url)
          #imgadm sources -a #{url}
        end

        def delete_source(url)
          #imgadm sources -a #{url}
        end

        def avail
          #imgadm avail -j
        end

        def import(uuid, pool: 'zones')
          #imgadm import #{uuid} -P #{pool} -q
        end

        def install(manifest, file, pool: 'zones')
          #imgadm import -P #{pool} -m #{manifest} -f #{file} -q
        end

        def list
          #imgadm list -j
        end

        def show(uuid)
          #imgadm show #{uuid}
        end

        def get(uuid, pool: 'zones')
          #imgadm get #{uuid} -P #{pool}
        end

        def delete(uuid, pool: 'zones')
          #imgadm delete #{uuid} -P #{pool}
        end

        def update(uuids)
          #imgadm update #{Array(uuids).join(' ')}
        end

        def create(vm_uuid, manifest: {}, output: nil, compression: 'none', incremental: false, script: nil, publish: nil, max_origin_depth: nil)
          #Imgadm.create('f7a53e9-fc4d-d94b-9205-9ff110742aaf', manifest:{name: 'NewImage', version: '1.0.0'}, script: '/var/tmp/prep-image.sh', output: '/var/tmp')
          raise 'Imgadm#create: Only one of -o(utput) or -p(ublish) may be specified' if output && publish
          str_script = script ? "-s #{script} " : nil
          str_compression = "-c #{compression} "
          str_output = output ? "-o #{output} " : nil
          str_publish = publish ? "-p #{publish} " : nil
          str_max_origin_depth = max_origin_depth ? "--max-origin-depth #{max_origin_depth} " : nil
          str_incremental = incremental ? "-i " : nil
          str_command = "imgadm create #{str_script}#{str_compression}#{str_output}#{str_publish}#{str_max_origin_depth}#{str_incremental} -q"
        end

        def publish
          #TODO
        end
      end


    end
  end
end