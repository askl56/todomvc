class Todo < Volt::Model
  reactive_accessor :editing

  def stop_editing
    self.editing = false
    if _label.blank?
      destroy
    end
  end
end
