module Scanlet
  module TranslationOperations

    class AddNewTranslation

      attr_accessor :group_id, :image_id, :index
      attr_reader :result

      def initialize(group_id, image_id)
        self.group_id = group_id
        self.image_id = image_id
      end

      def call

        image = Common::Image.find(image_id)

        @result = Scanlet::Translation.create({group_id: group_id, index: index, scan_attributes: {
            image: image.file
        }})

        self
      end

      def success?
        !result.nil? && result.valid?
      end
    end
  end
end