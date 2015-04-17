class Todo < Volt::Model
  # A local reactive variable to store the editing state
  reactive_accessor :editing

  def stop_editing
    self.editing = false

    # If the edit removed the label, delete the item
    if _label.blank?
      destroy
    end
  end
end
