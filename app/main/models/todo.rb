class Todo < Volt::Model
  validate :label, length: 2
end
