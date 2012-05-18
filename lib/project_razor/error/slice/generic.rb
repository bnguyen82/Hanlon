

module ProjectRazor
  module Error
    module Slice

      class Generic < ProjectRazor::Error::Generic

        def initialize(message)
          super(message)
          @http_err = :forbidden
          @std_err = 1
        end

      end

    end
  end
end
