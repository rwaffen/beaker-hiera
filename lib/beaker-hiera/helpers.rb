module Beaker
  module DSL
    module Helpers
      # Methods that help you interact with your hiera installation. Hiera must be installed
      # for these methods to execute correctly.
      module Hiera
        # Write hiera config file on one or more provided hosts
        #
        # @param [Host, Array<Host>, String, Symbol] host
        #   One or more hosts to act upon, or a role (String or Symbol) that
        #   identifies one or more hosts.
        # @param [Array] hierarchy
        #   One or more hierarchy paths
        def write_hiera_config_on(host, hierarchy)
          block_on host do |hst|
            hiera_config = {
              backends: 'yaml',
              yaml: {
                datadir: hiera_datadir(hst),
              },
              hierarchy: hierarchy,
              logger: 'console',
            }
            create_remote_file hst, hst.puppet['hiera_config'], hiera_config.to_yaml
          end
        end

        # Write hiera config file for the default host
        #
        # @param [Array] hierarchy
        #   One or more hierarchy paths
        #
        # @see #write_hiera_config_on
        def write_hiera_config(hierarchy)
          write_hiera_config_on(default, hierarchy)
        end

        # Copy hiera data files to one or more provided hosts
        #
        # @param [Host, Array<Host>, String, Symbol] host
        #   One or more hosts to act upon, or a role (String or Symbol) that
        #   identifies one or more hosts.
        # @param [String] source
        #   Directory containing the hiera data files.
        def copy_hiera_data_to(host, source)
          block_on host do |hst|
            scp_to hst, File.expand_path(source), hiera_datadir(hst)
          end
        end

        # Copy hiera data files to the default host
        #
        # @param [String] source
        #   Directory containing the hiera data files.
        #
        # @see #copy_hiera_data_to
        def copy_hiera_data(source)
          copy_hiera_data_to(default, source)
        end

        # Get file path to the hieradatadir for a given host.
        # Handles whether or not a host is AIO-based & backwards compatibility
        #
        # @param [Host] host
        #   Host you want to use the hieradatadir from
        #
        # @return [String] Path to the hiera data directory
        def hiera_datadir(host)
          File.join(host.puppet['codedir'], 'hieradata')
        end
      end
    end
  end
end
