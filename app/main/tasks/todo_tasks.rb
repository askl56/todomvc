class TodoTasks < Volt::Task
  def check_all
    store._todos.fetch do |todos|
      todos.each do |todo|
        todo._completed = true
      end
    end
  end
end
