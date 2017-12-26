module Scanlet
  class PresenterBase

    def initialize(type = :new)
      @type = type

      def new?
        @type == :new
      end

      def edit?
        @type == :edit
      end

      def view?
        @type == :view
      end
    end
  end
end