module Notes
  class QuickActionsService < BaseService
    UPDATE_SERVICES = {
      'Issue' => Issues::UpdateService,
      'MergeRequest' => MergeRequests::UpdateService
    }.freeze

    def self.noteable_update_service(note)
      UPDATE_SERVICES[note.noteable_type]
    end

    def self.supported?(note, current_user)
      noteable_update_service(note) &&
        current_user &&
        current_user.can?(:"update_#{note.to_ability_name}", note.noteable)
    end

    def supported?(note)
      self.class.supported?(note, current_user)
    end

    def extract_commands(note, options = {})
      return [note.note, {}] unless supported?(note)

      QuickActions::InterpretService.new(project, current_user, options).
        execute(note.note, note.noteable)
    end

    def execute(command_params, note)
      return if command_params.empty?
      return unless supported?(note)

      self.class.noteable_update_service(note).new(project, current_user, command_params).execute(note.noteable)
    end
  end
end
