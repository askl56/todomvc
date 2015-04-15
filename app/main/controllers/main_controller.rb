# By default Volt generates this controller for your Main component
module Main
  class MainController < Volt::ModelController
    model :store

    def index
      new
    end

    def new
      page._new_todo = store._todos.buffer
    end

    def current_index
      params._index.to_i
    end

    def add_todo
      page._new_todo.save! do
        flash._notices << "Todo Added"
        new
      end
    end

    def complete
      _todos.count {|v| v._completed }
    end

    def incomplete
      _todos.size - complete
    end

    def check_all
      TodoTasks.check_all
    end

    def current_todo
      _todos[current_index]
    end

    private

    # The main template contains a #template binding that shows another
    # template.  This is the path to that template.  It may change based
    # on the params._component, params._controller, and params._action values.
    def main_path
      "#{params._component || 'main'}/#{params._controller || 'main'}/#{params._action || 'index'}"
    end

    # Determine if the current nav component is the active one by looking
    # at the first part of the url against the href attribute.
    def active_tab?
      url.path.split('/')[1] == attrs.href.split('/')[1]
    end
  end
end