module Forms
  module Hosts
    class EditFilter < Sunrise::Mutations::ProcessForm
      required { duck :host }

      optional { string :filter }

      scope :host

      def execute
        host.update(filter: filter)

        host
      end

      def default_values
        {
          filter: host.filter
        }
      end
    end
  end
end
