module Scanlet
  class GroupPresenter < PresenterBase

    attr_reader :object, :project_id

    def initialize(type = :view, group = Scanlet::Group.new, params = {})
      super type
      @object = group
      @project_id = params[:project_id] || group.project&.id
    end

    def action
      if self.new?
        Rails.application.routes.url_helpers.scanlet_groups_path
      elsif self.edit?
        Rails.application.routes.url_helpers.scanlet_group_path(@object)
      else
        ""
      end
    end

    def method
      if self.new?
        "post"
      elsif self.edit?
        "patch"
      else
        "post"
      end
    end

    def respond_json
      if @object.valid?
        {
            result: 0
        }
      else
        {
            result: 1
        }
      end

    end

    def label_submit
      if self.new?
        "Create"
      else
        "Save"
      end
    end

  end
end