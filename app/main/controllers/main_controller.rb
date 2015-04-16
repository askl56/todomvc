# By default Volt generates this controller for your Main component
module Main
  class MainController < Volt::ModelController
    model :store

    def index
      new

      # Setup document click listener
      `$(document).on('click.editing', function(event) {`
        if `!$(event.target).parents('.todo-item').get(0)`
          clear_editing
        end
      `})`
    end

    def before_index_remove
      # remove document click listener
      `$(document).off('click.editing')`
    end

    def new
      page._new_todo = store._todos.buffer
    end

    def current_index
      params._index.to_i
    end

    def filtered_todos
      case params._filter
      when 'completed'
        store._todos.where(completed: true)
      when 'active'
        store._todos.where({'$or' => [{completed: false}, {completed: nil}]})
      else
        store._todos
      end
    end

    def add_todo
      if page._new_todo._label.present?
        page._new_todo.save! do
          new
        end
      end
    end

    def complete
      _todos.count {|v| v._completed }
    end

    def incomplete
      _todos.size - complete
    end

    def clear_editing
      _todos.fetch_each do |todo|
        todo.stop_editing
      end
    end

    def clear_completed
      _todos.fetch_each do |todo|
        if todo._completed
          todo.destroy
        end
      end
    end

    def set_all_to(val)
      _todos.fetch_each do |todo|
        todo._completed = val
      end
    end

    def all_complete
      incomplete == 0
    end

    # Called when the complete all checkbox is checked.
    def all_complete=(val)
      set_all_to(val)
    end

    def edit(event)
      event.stop!
      attrs.parent.clear_editing
      model.editing = true
    end

    def stop_editing
      model.stop_editing
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