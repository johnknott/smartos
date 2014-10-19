module SmartOS
  module Command
    class Imgadm

      class << self
        def sources
          #imgadm sources -j
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

        def import(uuid, pool = 'zones')
          #imgadm import #{uuid} -P #{pool} -q
        end

        def install(manifest, file, pool = 'zones')
          #imgadm import -P #{pool} -m #{manifest} -f #{file} -q
        end

        def list
          #imgadm list -j
        end

        def show(uuid)
          #imgadm show #{uuid}
        end

        def get(uuid, pool = 'zones')
          #imgadm get #{uuid} -P #{pool}
        end

        def delete(uuid, pool = 'zones')
          #imgadm delete #{uuid} -P #{pool}
        end

        def update(uuids)
          #imgadm update #{Array(uuids).join(' ')}
        end

        def create
          #TODO
        end

        def publish
          #TODO
        end
      end


    end
  end
end